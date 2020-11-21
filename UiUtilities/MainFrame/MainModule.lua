-- Where I store all the functions
local tools = {}
local Selection = game:GetService("Selection")
local History = game:GetService("ChangeHistoryService")


--[[ General
Change font & font size
ZIndex Increment
Set Anchorpoint & Position
Copy/Swap Properties
]]

function tools.Font(stringFont, descendantsToo)
	local font = Enum.Font[stringFont]
	local toChange = (descendantsToo and Selection:Get()[1]:GetDescendants() or Selection:Get())
	for i,v in pairs (toChange) do
		pcall(function() v.Font = font end)
	end
	print("Changed font")
	History:SetWaypoint("Change Fonts")
end

function tools.FontSize(stringFontSize, descendantsToo)
	local fontsize = tonumber(stringFontSize)
	local toChange = (descendantsToo and Selection:Get()[1]:GetDescendants() or Selection:Get())
	for i,v in pairs (toChange) do
		pcall(function() v.TextSize = fontsize end)
	end
	print("Changed font size to "..stringFontSize)
	History:SetWaypoint("Change Font Sizes")
end

function tools.IncZIndex(stringIncrement, descendantsToo)
	local increment = tonumber(stringIncrement)
	local toChange = (descendantsToo and Selection:Get()[1]:GetDescendants() or Selection:Get())
	for i,v in pairs (toChange) do
		pcall(function() v.ZIndex = v.ZIndex + increment end)
	end
	print("Increment ZIndex "..stringIncrement)
	History:SetWaypoint("Increment ZIndex")
end


function tools.Anchor (APoint, Position)
	local toChange = Selection:Get()
	for i,v in pairs (toChange) do
		pcall (function() v.AnchorPoint = APoint v.Position = Position end)
	end
	print("Anchor points")
	History:SetWaypoint("Anchor Points")
end

function tools.CopyProperty (property)
	local toChange = Selection:Get()
	local sample = toChange[1]
	for i,v in pairs (toChange) do
		pcall (function() if v == sample then return end
			v[property] = sample[property]
		end)
	end
	print("Copied property "..property)
	History:SetWaypoint("Copy Properties")
end

function tools.SwapProperty(property)
	History:SetWaypoint("Swapped Properties")
	local toChange = Selection:Get()
	local current1Value = toChange[1][property]
	local current2Value = toChange[2][property]
	pcall (function() toChange[1][property] = current2Value end)
	pcall (function() toChange[2][property] = current1Value end)
	print("Swapped Property "..property)
	History:SetWaypoint("Swapped Properties")
end


--[[FRAME SCALE ACTIONS -- When done, do all of these functions
Scale = Object.Absolute/Parent.Absolute

Create a clone backup
Convert all descendants to scale size & scale position
Convert text to scale
Add ARConstraint to selected

]]


function tools.AddARConstraint() 
	local selected = Selection:Get()
	for i,o in pairs (selected) do
		local AR = Instance.new("UIAspectRatioConstraint")
		local Ratio = o.AbsoluteSize.X / o.AbsoluteSize.Y
		AR.AspectRatio = Ratio
		AR.Parent = o
	end
	print("Added constraint")
	History:SetWaypoint("Add AR Constraint")
end

function tools.BackupClone()
	local selected = Selection:Get()
	for i,o in pairs (selected) do
		local oc = o:Clone()
		oc.Name = oc.Name.." [Backup]" oc.Parent = o.Parent
	end
	print("Cloned Backup")
	History:SetWaypoint("Cloned Backup")
end

function tools.ScaleText(descendantsToo)
	local toScale = (descendantsToo and Selection:Get()[1]:GetDescendants() or Selection:Get())
	for i,v in pairs (toScale) do 
		pcall( function()
		v.Size = UDim2.new(v.Size.X.Scale, v.Size.X.Offset, (v.TextBounds.Y/v.Parent.AbsoluteSize.Y) , v.Size.Y.Offset)
		v.TextScaled = true
		end) 
	end
	print("Scaled text")
	History:SetWaypoint("Convert Text to Scale")
end

local function GetAxis(frame)
	local fsize = frame.SizeConstraint
	local V1, V2
	if fsize==Enum.SizeConstraint.RelativeXX then V1,V2 = "X","X"
	elseif fsize==Enum.SizeConstraint.RelativeXY then V1,V2 = "X","Y"
	elseif fsize==Enum.SizeConstraint.RelativeYY then V1,V2 = "Y","Y" end
	return V1, V2
end

function tools.Scale(size, position, descendantsToo)
	local toScale = (descendantsToo and Selection:Get()[1]:GetDescendants() or Selection:Get())
	for i,v in pairs (toScale) do pcall( function()
		local V1, V2 = GetAxis(v)
		local AbsSize = v.AbsoluteSize
		local AbsSizeParent = v.Parent.AbsoluteSize
		v.Size = size and UDim2.new((AbsSize[V1]/AbsSizeParent.X), 0, (AbsSize[V2]/AbsSizeParent.Y) , 0) or v.Size
		
		local vPos= v.Position
		v.Position = position and UDim2.new((vPos.X.Offset/AbsSizeParent.X + vPos.X.Scale), 0, (vPos.Y.Offset/AbsSizeParent.Y + vPos.Y.Scale) , 0) or v.Position
		end) 
	end 
	print("Scaled objects")
	History:SetWaypoint("Scale")
end

function tools.Offset(size, position, descendantsToo)
	local toOffset = (descendantsToo and Selection:Get()[1]:GetDescendants() or Selection:Get())
	for i,v in pairs (toOffset) do pcall( function()
			local AbsSize = v.AbsoluteSize
			local AbsSizeParent = v.Parent.AbsoluteSize
			v.Size = size and UDim2.new(0, AbsSize.X, 0, AbsSize.Y) or v.Size

			local vPos = v.Position
			v.Position = position and UDim2.new(0,(vPos.X.Scale*AbsSizeParent.X + vPos.X.Scale), 0, (vPos.Y.Scale*AbsSizeParent.Y + vPos.Y.Scale)) or v.Position
		end) 
	end 
	print("Offset objects")
	History:SetWaypoint("Offset")
end

return tools
