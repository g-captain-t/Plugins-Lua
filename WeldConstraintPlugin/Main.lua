local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local function Weld(part, part1)
  local wc = Instance.new("WeldConstraint")
  wc.Part0 = part1 wc.Part1 = part
  wc.Parent = part1
end

local function Main()
  local currentSelections = Selection:Get()
  if currentSelections[1] == nil then warn("Can't weld: Select a group or several parts first to weld!") return end

  local parts = {}
  for i, selection in ipairs (currentSelections) do 
    if selection:IsA("BasePart") then table.insert(parts,selection) 
      else for i, v in pairs(selection:GetDescendants()) do if v:IsA("BasePart") then table.insert(parts,v) end end
    end 
  end
  for i, v in ipairs(parts) do if i~=1 then Weld(v,parts[1]) end end

  ChangeHistoryService:SetWaypoint("Quick WeldConstraints")
  warn("Parts successfully welded to "..part[1].Name.."!")
end

-- Bind to button
local openPlugin = plugin:CreateToolbar("CameraLight"):CreateButton("Quick WeldConstraint","Select a group or several parts to weld!","rbxassetid://0")
openPlugin.Click:Connect(Main)

-- Plugin version of WeldConstraint welding by g_captain
