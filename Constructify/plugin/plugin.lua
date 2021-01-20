local constructify = require(script.Parent.constructify)
local Selection = game:GetService("Selection")

local toolbar = plugin:CreateToolbar("Constructify") --// I have no thumbnail
local One = toolbar:CreateButton("Get Constructor", "Get the constructor of the selected object", "rbxassetid://5614579544")
local All = toolbar:CreateButton("Get All Constructors", "Get all constructors of the selected object and its children", "rbxassetid://5614579544")

local function export(str,name)
	local strval = Instance.new("StringValue")
	strval.Name = name
	strval.Value = str
	strval.Parent = workspace
end

One.Click:Connect(function()
	local selected = Selection:Get()
	assert(selected[1], "Select an object first!")
	local str = constructify(selected[1], nil, nil, true)
	export(str,selected[1].Name)
	warn("Constructify finished!")
end)

All.Click:Connect(function()
	local selected = Selection:Get()
	assert(selected[1], "Select an object first!")
	local str = constructify(selected[1])
	export(str,selected[1].Name)
	warn("Constructify finished!")
end)
