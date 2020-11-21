local List = script.Parent

local layout = List:FindFirstChildWhichIsA("UIListLayout")
local absoluteContentSize = layout.AbsoluteContentSize
List.CanvasSize = UDim2.new(0, 0, 0, absoluteContentSize.Y)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	local absoluteContentSize = layout.AbsoluteContentSize
	List.CanvasSize = UDim2.new(0, 0, 0, absoluteContentSize.Y)
end)
