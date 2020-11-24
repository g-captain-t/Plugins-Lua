local Sidebar = script.Parent.Sidebar
local Content = script.Parent.Scroll.Content
local Main = require(script.Parent.Functions)
local UI = require(script.Parent.UIModule)

local isOrdered = Sidebar.Toggles_IsOrdered
UI.ConnectToggle(isOrdered, "RichText")

local KeyInput = Sidebar.Input_Key
local NameInput = Sidebar.Input_Name
local ScopeInput = Sidebar.Input_Scope

Sidebar.OP_Lookup.MouseButton1Click:Connect(function()
	Main.Lookup(NameInput.Text, KeyInput.Text, Content, isOrdered.RichText, ScopeInput.Text)
end)

Sidebar.OP_Save.MouseButton1Click:Connect(function()
	Main.Save(NameInput.Text, KeyInput.Text, Content.Text, isOrdered.RichText, ScopeInput.Text)
end)
