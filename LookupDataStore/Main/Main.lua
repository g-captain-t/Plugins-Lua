local Sidebar = script.Parent.Sidebar
local Content = script.Parent.Scroll.Content
local Main = require(script.Parent.Functions)


local KeyInput = Sidebar.KeyInput
local NameInput = Sidebar.NameInput
Sidebar.Lookup.MouseButton1Click:Connect(function()
	Main.Lookup(NameInput.Text, KeyInput.Text, Content)
end)

Sidebar.Save.MouseButton1Click:Connect(function()
	Main.Save(NameInput.Text, KeyInput.Text, Content.Text)
end)
