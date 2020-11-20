local Tools = require(script.Parent.MainModule)
local UI = require(script.Parent.UIModule)

--- General 
local AnchorPoints = script.Parent.Gen_Anchor
for i,v in pairs (AnchorPoints:GetChildren()) do
	v.MouseButton1Click:Connect(function()Tools.Anchor(v.AnchorPoint, v.Position) end)
end

local Fonts = script.Parent.Gen_Font
Fonts.All.MouseButton1Click:Connect(function()Tools.Font(Fonts.Input.Text, true)end)
Fonts.Selected.MouseButton1Click:Connect(function()Tools.Font(Fonts.Input.Text, false) end)

local FontSize = script.Parent.Gen_FontSize
FontSize.All.MouseButton1Click:Connect(function()Tools.FontSize(FontSize.Input.Text, true)end)
FontSize.Selected.MouseButton1Click:Connect(function()Tools.FontSize(FontSize.Input.Text, false) end)

local CopyProps = script.Parent.Gen_PropertyCopy
CopyProps.Button.MouseButton1Click:Connect(function() Tools.CopyProperty(CopyProps.Input.Text) end)

local SwapProps = script.Parent.Gen_PropertySwap
SwapProps.Button.MouseButton1Click:Connect(function() Tools.SwapProperty(SwapProps.Input.Text) end)

--- Frame Scale Actions

local AspectRatio = script.Parent.Scale_AddAspectRatio
AspectRatio.MouseButton1Click:Connect(Tools.AddARConstraint)

local BackupClone = script.Parent.Scale_BackupClone
BackupClone.MouseButton1Click:Connect(Tools.BackupClone)

local ScaleText = script.Parent.Scale_ScaleText
ScaleText.ScaleAllText.MouseButton1Click:Connect(function()Tools.ScaleText(true) end)
ScaleText.ScaleText.MouseButton1Click:Connect(function() Tools.ScaleText(false) end)

local ScaleObj = script.Parent.Scale_ScaleObj
local SO_Pos = ScaleObj.position
local SO_Size = ScaleObj.size
UI.ConnectToggle(SO_Pos); UI.ConnectToggle(SO_Size)
ScaleObj.ScaleAll.MouseButton1Click:Connect(function()Tools.Scale(SO_Size.RichText, SO_Pos.RichText, true) end)
ScaleObj.ScaleSelect.MouseButton1Click:Connect(function()Tools.Scale(SO_Size.RichText, SO_Pos.RichText, false) end)

local OffsetObj = script.Parent.Scale_OffsetObj
local OO_Pos = OffsetObj.position
local OO_Size = OffsetObj.size
UI.ConnectToggle(OO_Pos); UI.ConnectToggle(OO_Size)
OffsetObj.OffsetAll.MouseButton1Click:Connect(function()Tools.Offset(OO_Size.RichText, OO_Pos.RichText, true) end)
OffsetObj.OffsetSelect.MouseButton1Click:Connect(function()Tools.Offset(OO_Size.RichText, OO_Pos.RichText, false) end)
