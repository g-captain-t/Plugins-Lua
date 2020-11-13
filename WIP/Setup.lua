local openPlugin = plugin:CreateToolbar("  "):CreateButton(
	" ---Title--- "," ---Description--- "," ---Thumbnail--- ")
local interface = script.Parent:WaitForChild("Interface")
interface.Parent = game.CoreGui

local Toggle = false
openPlugin.Click:Connect(function()
	Toggle = not Toggle
	openPlugin:SetActive(Toggle)
	interface.Enabled = Toggle 
end)
