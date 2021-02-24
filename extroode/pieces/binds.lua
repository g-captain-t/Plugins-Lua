
-- # BINDS

local UIS = game:GetService("UserInputService")

for _, button in ipairs(colorpalette:GetChildren()) do 
	if button:IsA("ImageButton") then 
		button.MouseButton1Click:Connect(function()
			ColorSelect(util.C3ToHex(button.ImageColor3))
		end)
		uiutil.hover(button)
	end
end

for _, button in ipairs(depthpalette:GetChildren()) do 
	if button:IsA("TextButton") then 
		button.MouseButton1Click:Connect(function()
			DepthSelect(button.Name)
		end)
		uiutil.hover(button)
	end
end

for _, button in ipairs(leftbar:GetChildren()) do 
	if button:IsA("ImageButton") then 
		button.MouseButton1Click:Connect(function()
			ModeSelect(button.Name)
		end)
		uiutil.hover(button)
	end
end

titlebar.FocusLost:Connect(function()
	TitleChange(titlebar.Text)
end)

aexport.MouseButton1Click:Connect(Export)
aimport.MouseButton1Click:Connect(function()
	local selected = util.getselected()
	local s, v = pcall(function()
		return require(selected)
	end)
	assert(s, "Cannot import selected. Error: "..v)
	Import(v)
end)
arender.MouseButton1Click:Connect(Render)
aclear.MouseButton1Click:Connect(Clear)

uiutil.hoverall({aexport,aimport,arender,aclear})

local bottombar = ui.BottomBar

for _, button in ipairs(bottombar:GetChildren()) do 
	if button:IsA("ImageButton") then 
		button.MouseButton1Click:Connect(function()
			PartSelect(button.Name)
		end)
		uiutil.hover(button)
	end
end

util.input.dragstart:Connect(function(mouse)
	local starttime = os.clock()
	if not util.input.mouseisinsideobj(canvas) then return end
	wait(.1)
	while util.input.isdragging do 
		RS.RenderStepped:Wait()
		MouseDrag(mouse.X, mouse.Y)
	end
	local dt = os.clock()-starttime
	if dt <= 0.15 then
		if state.currentmode ~= "build" then return end
		local mouse = util.input.getmouse()
		Rotate(mouse.X, mouse.Y)
	end
end)

--[[for i, pxframe in ipairs (canvas:GetChildren()) do 
	if pxframe.ClassName == "ImageButton" then 
		-- MB1Click theoretically should require a down and up, so detecting 
		-- drags will be the higher priority
		pxframe.MouseButton1Click:Connect(function()
			if state.currentmode ~= "build" then return end
			local mouse = util.input.getmouse()
			Rotate(mouse.X, mouse.Y)
		end)
	end
end]]

--[[UIS.InputBegan:Connect(function(input,gameprocessed)
	if gameprocessed or not widget.Enabled then return end
	if input.KeyCode == Enum.KeyCode.R then
		-- supposedly rotate
	end
end)]]