local mFrame = script.Parent.Parent
local defButtonColor = mFrame.RFlags_Button.ImageColor3
local newButtonColor = mFrame.RFlags_Button.NewButtonColor.Value

local function onClick(Frame)
	script.Parent.Value = Frame.Name
end

local function UpdateUI ()
	local Category = script.Parent.Value
	local Frame = mFrame:FindFirstChild(Category)
	local Button = mFrame:FindFirstChild(Category.."_Button")
	if not (Frame and Button) then return end
	
	for i,v in pairs (mFrame:GetChildren()) do 
		if v:IsA("ScrollingFrame") and v ~= Frame then v.Visible = false end
		if mFrame:FindFirstChild(v.Name.."_Button") ~= nil and v ~= Button then 
			mFrame[v.Name.."_Button"].ImageColor3 = defButtonColor
		end
	end
	Frame.Visible = true
	Button.ImageColor3 = newButtonColor
end


script.Parent:GetPropertyChangedSignal("Value"):Connect(UpdateUI)

mFrame.RFlags_Button.MouseButton1Click:Connect(function() onClick(mFrame.RFlags) end)
mFrame.YFlags_Button.MouseButton1Click:Connect(function() onClick(mFrame.YFlags) end)
mFrame.OFlags_Button.MouseButton1Click:Connect(function() onClick(mFrame.OFlags) end)
