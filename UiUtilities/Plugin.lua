local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	255,    -- Default width of the floating window
	377,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)

-- Widget

local toolbar = plugin:CreateToolbar("UI Utilities")
local pluginButton = toolbar:CreateButton("UI Utilities", "g_captain's UI utilities", "rbxassetid://5085732245")

local widget = plugin:CreateDockWidgetPluginGui("g_UiUtilities", widgetInfo)
widget.Title = "UI Utilities"  

local mFrame = script.Parent.MainFrame
mFrame.Parent = widget

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled 
	mFrame.Visible = widget.Enabled
end)
