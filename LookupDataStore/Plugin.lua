local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	435,    -- Default width of the floating window
	325,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)

-- Widget

local toolbar = plugin:CreateToolbar("DataStore")
local pluginButton = toolbar:CreateButton("Lookup DataStore", "Lookup and modify DataStores in JSON formatting", "rbxassetid://5996904118")

local widget = plugin:CreateDockWidgetPluginGui("DataStore", widgetInfo)
widget.Title = "Lookup DataStore"  

local mFrame = script.Parent.Interface.Main
mFrame.Parent = widget

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled 
	mFrame.Visible = widget.Enabled
end)
