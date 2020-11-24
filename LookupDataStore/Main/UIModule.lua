local ui = {}

function ui.ConnectToggle(toggle, Value)
	local disabled = Enum.ButtonStyle.RobloxRoundButton
	local enabled = Enum.ButtonStyle.RobloxRoundDefaultButton
	toggle.MouseButton1Click:Connect(function()
		toggle[Value] = not toggle[Value]
		toggle.Style = toggle[Value] and enabled or disabled
	end)
end

return ui
