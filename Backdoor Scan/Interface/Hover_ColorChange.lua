local defImgColor = script.Parent.ImageColor3
local defBkgColor = script.Parent.BackgroundColor3
local newColor = script.NewColor.Value

local TS = game:GetService("TweenService")
local TSInfo =  TweenInfo.new(0.1)
local GoalEnd = {ImageColor3=newColor, BackgroundColor3=newColor}
local GoalBack = {ImageColor3=defImgColor, BackgroundColor3=defBkgColor}

local TS_ON = TS:Create(script.Parent, TSInfo, GoalEnd)
local TS_OFF = TS:Create(script.Parent, TSInfo, GoalBack)

script.Parent.MouseEnter:Connect(function() TS_ON:Play() end)
script.Parent.MouseLeave:Connect(function() TS_OFF:Play() end)
