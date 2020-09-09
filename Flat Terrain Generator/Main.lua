
-- Generation Functions
function partProperties(part)
	part.Anchored = true
	part.Material = Enum.Material.Grass
	part.Transparency = 0
	part.CanCollide = true
	part.Color = Color3.fromRGB(150,200,150)
end
function generateFlat(size, height, multiple, startpos)
	
	local group = Instance.new("Model") group.Name = "FlatTerrain" group.Parent = workspace
	
	local rootPart = Instance.new("Part") 
	partProperties(rootPart)
	rootPart.Parent = group
	rootPart.Size = Vector3.new(size, height, size)
	rootPart.Position = Vector3.new(startpos.X, startpos.Y, startpos.Z) 
	
	for i=1,multiple-1 do -- X Positive Axis
		local currentPart = Instance.new("Part") 
		partProperties(currentPart)
		currentPart.Parent = group
		currentPart.Size = Vector3.new(size, height, size)
		currentPart.Position = Vector3.new(startpos.X+currentPart.Size.X*i, startpos.Y, startpos.Z) 
	end
	
	for i=1,multiple-1 do -- Z Positive Axis, also fills the terrain
		local currentPart = Instance.new("Part") 
		partProperties(currentPart)
		currentPart.Parent = group
		currentPart.Size = Vector3.new(size, height, size)
		currentPart.Position = Vector3.new(startpos.X, startpos.Y, startpos.Z+currentPart.Size.Z*i) 
		
		for i2=1,multiple-1 do -- Fills the terrain in the X positive axis
			local currentPart = Instance.new("Part") 
			partProperties(currentPart)
			currentPart.Parent = group
			currentPart.Size = Vector3.new(size, height, size)
			currentPart.Position = Vector3.new(startpos.X+currentPart.Size.X*i2, startpos.Y, startpos.Z+currentPart.Size.Z*i) 
		end
		for i3=1,multiple-1 do -- Fills the terrain in the X negative axis
			local currentPart = Instance.new("Part") 
			partProperties(currentPart)
			currentPart.Parent = group
			currentPart.Size = Vector3.new(size, height, size)
			currentPart.Position = Vector3.new(startpos.X-currentPart.Size.X*i3, startpos.Y, startpos.Z+currentPart.Size.Z*i) 
		end
	end
	
	for i=1,multiple-1 do -- X Negative Axis
		local currentPart = Instance.new("Part") 
		partProperties(currentPart)
		currentPart.Parent = group
		currentPart.Size = Vector3.new(size, height, size)
		currentPart.Position = Vector3.new(startpos.X-currentPart.Size.X*i, startpos.Y, startpos.Z) 
	end
	
	for i=1,multiple-1 do -- Z Negative Axis, also fills the terrain
		local currentPart = Instance.new("Part") 
		partProperties(currentPart)
		currentPart.Parent = group
		currentPart.Size = Vector3.new(size, height, size)
		currentPart.Position = Vector3.new(startpos.X, startpos.Y, startpos.Z-currentPart.Size.Z*i) 
		
		for i2=1,multiple-1 do -- Fills the terrain in the X negative axis
			local currentPart = Instance.new("Part") 
			partProperties(currentPart)
			currentPart.Parent = group
			currentPart.Size = Vector3.new(size, height, size)
			currentPart.Position = Vector3.new(startpos.X-currentPart.Size.X*i2, startpos.Y, startpos.Z-currentPart.Size.Z*i) 
		end
		for i3=1,multiple-1 do -- Fills the terrain in the X positive axis
			local currentPart = Instance.new("Part") 
			partProperties(currentPart)
			currentPart.Parent = group
			currentPart.Size = Vector3.new(size, height, size)
			currentPart.Position = Vector3.new(startpos.X+currentPart.Size.X*i3, startpos.Y, startpos.Z-currentPart.Size.Z*i) 
		end
	end
	
	--made by g_captain
	game:GetService("ChangeHistoryService"):SetWaypoint("Generated")
end

function undoNil(Input)
	if Input:IsA("TextBox") then
		Input.FocusLost:Connect(function()
		if tonumber(Input.Text) == nil then Input.Text = "0" end
		end)
	end
end 

-- Variables

local ui = script.Parent.Interface.Frame
local partConfigure = ui.Parts
local positionConfigure = ui.Positions
local generateButton = ui.Generate

local InputX = positionConfigure.XInput
local InputY = positionConfigure.YInput
local InputZ = positionConfigure.ZInput

local InputSize = partConfigure.SizeInput
local InputHeight = partConfigure.HeightInput
local InputRadius = partConfigure.RadiusInput

local currentSize, currentHeight, currentRadius, currentStartPos, currentStartY


-- Clean up nils so the output won't be flooded
InputSize.FocusLost:Connect(function()
	if tonumber(InputSize.Text~= nil) and tonumber(InputSize.Text) > 2048 then
		InputSize.Text = "2048"
	end
end)

undoNil(InputSize) undoNil(InputRadius) undoNil(InputHeight)
undoNil(InputX) undoNil(InputY) undoNil(InputZ)

-- The generation
generateButton.MouseButton1Click:Connect(function()

	currentSize = tonumber(InputSize.Text)
	currentHeight = tonumber(InputHeight.Text)
	currentRadius = math.floor(tonumber(InputRadius.Text))
	currentStartY = -currentHeight/2
	currentStartPos = Vector3.new(tonumber(InputX.Text),currentStartY+tonumber(InputY.Text),tonumber(InputZ.Text))
	
	generateFlat(currentSize,currentHeight,currentRadius,currentStartPos)
end)
