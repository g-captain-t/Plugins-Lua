-- Where I store all the functions
local tools = {}
local Selection = game:GetService("Selection")
local History = game:GetService("ChangeHistoryService")



--[[ General
Change font
Set Anchorpoint & Position
]]

function tools.Font(stringFont, descendantsToo)
	local font = Enum.Font[stringFont]
	local toChange = (descendantsToo and Selection:Get():GetDescendants() or Selection:Get())
	for i,v in pairs (toChange) do
		v.Font = font
	end
	print("Changed font")
	History:SetWaypoint("Change Fonts")
end

function tools.Anchor (APoint, Position)
	local toChange = Selection:Get()
	for i,v in pairs (toChange) do
		v.AnchorPoint = APoint
		v.Position = Position
	end
	print("Anchor points")
	History:SetWaypoint("Anchor Points")
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
	local toScale = (descendantsToo and Selection:Get():GetDescendants() or Selection:Get())
	for i,v in pairs (toScale) do
		v.Size = UDim2.new(v.Size.X.Scale, v.Size.X.Offset, (v.TextBounds.Y/v.Parent.AbsoluteSize.Y) , v.Size.Y.Offset)
		v.TextScaled = true
	end
	print("Scaled text")
	History:SetWaypoint("Convert Text to Scale")
end

function tools.Scale(size, position, descendantsToo)
	local toScale = (descendantsToo and Selection:Get():GetDescendants() or Selection:Get())
	for i,v in pairs (toScale) do
		local AbsSize = v.AbsoluteSize
		local AbsSizeParent = v.Parent.AbsoluteSize
		v.Size = size and UDim2.new((AbsSize.X/AbsSizeParent.X), 0, (AbsSize.Y/AbsSizeParent.Y) , 0) or v.Size
		
		local AbsPos= v.AbsolutePosition
		local AbsPosParent = v.Parent.AbsolutePosition
		v.Position = position and UDim2.new((AbsPos.X/AbsPosParent.X), 0, (AbsPos.Y/AbsPosParent.Y) , 0) or v.Position
	end
	print("Scaled objects")
	History:SetWaypoint("Scale")
end

return tools
