local function ConnectButton(Button)

	local defImgColor = Button.ImageColor3
	local defBkgColor = Button.BackgroundColor3
	local newColor = script.NewColor.Value


	local TS = game:GetService("TweenService")
	local TSInfo =  TweenInfo.new(0.1)
	local GoalEnd = {ImageColor3=newColor, BackgroundColor3=newColor}
	local GoalBack = {ImageColor3=defImgColor, BackgroundColor3=defBkgColor}

	local TS_ON = TS:Create(Button, TSInfo, GoalEnd)
	local TS_OFF = TS:Create(Button, TSInfo, GoalBack)

	Button.MouseEnter:Connect(function() TS_ON:Play() end)
	Button.MouseLeave:Connect(function() TS_OFF:Play() end)

	Button.MouseButton1Click:Connect(function()
		local object = Button.Object.Value
		if not object then return end
		local QuarantineFolder = workspace:FindFirstChild("[GC_BackdoorScan] Quarantined")
		if not QuarantineFolder then QuarantineFolder = Instance.new("Folder",workspace) QuarantineFolder.Name = "[GC_BackdoorScan] Quarantined" end
		object.Parent = QuarantineFolder
		Button:Destroy()
	end)
	
end

local function ButtonsList(List)
	List.ChildAdded:Connect(function(child)
		if child.Name == "Item" or child:IsA("UIListLayout") then return end
		ConnectButton(child)
	end)
	
	local layout = List:FindFirstChildWhichIsA("UIListLayout")
	local absoluteContentSize = layout.AbsoluteContentSize
	List.CanvasSize = UDim2.new(0, 0, 0, absoluteContentSize.Y)
	
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local absoluteContentSize = layout.AbsoluteContentSize
		List.CanvasSize = UDim2.new(0, 0, 0, absoluteContentSize.Y)
	end)
end

ButtonsList(script.Parent.RFlags)
ButtonsList(script.Parent.OFlags)
ButtonsList(script.Parent.YFlags)
