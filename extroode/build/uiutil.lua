local uiutil = {}

-- select(button, list) -- move the selected to the button and make everything else unselected
-- hover(button)

function uiutil.select(button, list)
	for i, child in ipairs (list:GetChildren()) do 
		local isbutton = child:IsA("GuiButton")
		if isbutton and child==button then 
			child.BorderSizePixel = 3
		elseif isbutton then
			child.BorderSizePixel = 0
		end
	end
end

function uiutil.select2(button, list)
	for i, child in ipairs (list:GetChildren()) do 
		local isbutton = child:IsA("GuiButton")
		if isbutton and child == button then 
			child.BorderSizePixel = 3
			child.BorderColor3 = Color3.fromRGB(119, 122, 143)
		elseif isbutton then
			child.BorderSizePixel = 2
			child.BorderColor3 = Color3.fromRGB(235, 235, 243)
		end
	end
end

function uiutil.hover(button)
	if not button:IsA("GuiButton") then return end
	button.MouseEnter:Connect(function()

	end)
	button.MouseLeave:Connect(function()

	end)
end

function uiutil.hoverall(t)
	for _, obj in ipairs (t) do 
		uiutil.hover(obj)
	end
end

return uiutil