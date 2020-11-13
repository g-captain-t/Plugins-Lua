--[[

Gets the current selection. Mirrors it in an axis as soon as position changes, positions it relative to the
axis plane block's position. I will be using the X axis in this draft.
Rotations will be opposite except the current rotation's axis. 
When other properties change (e.g size, color) change it.

]]

local SelectionService = game:GetService("Selection")
local currentAxis = "X"
local selectedPlane = false
local targetBlock = SelectionService:Get()[1]
local planePart

-- Current Axis is X

function createPlane()
    planePart = Instance.new("Part",workspace)
    planePart.Transparency = 0.5
    planePart.CastShadow = false
    planePart.Size = Vector3.new(0.2, 1042, 1042)
    planePart.Position = targetBlock.Position
    selectedPlane = true
end

createPlane()

SelectionService.Changed:Connect(function()
    if not selectedPlane then
        targetBlock = SelectionService:Get()[1]
        createPlane()
    end
end)

function updatePosition(selectedPart, partClone)
    if partClone == nil then partClone = selectedPart:Clone() partClone.Parent = workspace end
    
    local offset -- Let's find how much the clone has to move
    if selectedPart.Position.X > planePart.Position.X then -- part is on the right
        offset = planePart.Position.X - (selectedPart.Position.X - planePart.Position.X)
    else -- part is on the left
        offset = planePart.Position.X + (planePart.Position.X - selectedPart.Position.X)
    end

    partclone.Position = Vector3.new(offset, 
    selectedPart.Position.Y, selectedPart.Position.Z) 
end

function updateRotation(selectedPart, partClone)
    -- we will negative the current rotation
    if partClone == nil then partClone = selectedPart:Clone() partClone.Parent = workspace end
    
    partClone.Rotation = Vector3.new(selectedPart.Rotation.X,
    -(selectedPart.Rotation.Y), -(selectedPart.Rotation.Z))
end



----

SelectionService.SelectionChanged:Connect(function() 
    if selectedPlane then
    
        local selections = SelectionService:Get()
        for i, selection in pairs (selections) do
            if selection:IsA("BasePart") then
 
                updateRotation(selection)
                
                updatePosition(selection)
                selection.Changed:Connect(function()
                    updateRotation(selection)
                    updatePosition(selection)
                end)
            end
        end
        
    end
end)

-[[ Errors
37: attempt to index nil with 'Position'
clonePart is not detected. Plus the code clones every part. You need to add the destroy() for cloned parts

]]
