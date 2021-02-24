
-- # PLUGIN

--[[local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,  -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	255,    -- Default width of the floating window
	377,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)]]

local toolbar = plugin:CreateToolbar("extroode")
local pluginButton = toolbar:CreateButton("Open", "Open the extroode editor", "rbxassetid://6092226894")

local core = game:GetService("CoreGui")
widget = core:FindFirstChild("extroode_screen")
if widget then
	widget:Destroy()
end

widget = uifolder.extroode_screen --plugin:CreateDockWidgetPluginGui("extroode", widgetInfo)
--widget.Title = "extroode"  
ui.Visible = widget.Enabled
ui.Parent = widget.body

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled 
	ui.Visible = widget.Enabled
	if widget.Enabled then
		plugin:Activate(true)
		widget.Parent = core
	else
		plugin:Deactivate()
		widget.Parent = uifolder
	end
end)
