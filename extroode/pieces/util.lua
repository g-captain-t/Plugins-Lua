

-- # UTIL

local util = {}

util.input = {}
local inputs = util.input -- using the plural because seeing the keyword highlight is annoying
local UIS = game:GetService("UserInputService")
inputs.mouse = plugin:GetMouse()

inputs.isdragging = false
inputs._dragstart = Instance.new("BindableEvent")
inputs._dragend = Instance.new("BindableEvent")
inputs.dragstart = inputs._dragstart.Event
inputs.dragend = inputs._dragend.Event

inputs.getmouse = function()
	inputs.mouse = inputs.mouse
	if not inputs.mouse then 
		inputs.mouse = plugin:GetMouse()
		inputs.dragstart = inputs.mouse.Button1Down
		inputs.dragend = inputs.mouse.Button1Up
	end
	return inputs.mouse
end

inputs.mouse.Button1Down:Connect(function()
	inputs.isdragging = true
	inputs._dragstart:Fire(inputs.mouse)
end)
inputs.mouse.Button1Up:Connect(function()
	inputs.isdragging = false
	inputs._dragend:Fire(inputs.mouse)
end)

local RS = game:GetService("RunService")

inputs.mouseisinsideobj = function (obj, mouse)
	local mouse = mouse or inputs.getmouse()
	local min = {X=obj.AbsolutePosition.X, Y=obj.AbsolutePosition.Y}
	local max = {X=obj.AbsolutePosition.X + obj.AbsoluteSize.X, Y=obj.AbsolutePosition.Y + obj.AbsoluteSize.Y}
	local passX = mouse.X > min.X and mouse.X < max.X
	local passY = mouse.Y > min.Y and mouse.Y < max.Y
	return (passX and passY) 
end

inputs.gethoveredobjects = function(parent, mouse)
	local mouse = mouse or inputs.getmouse()
	local objects = {}
	for _, v in ipairs (parent:GetChildren()) do 
		if v:IsA("GuiObject") and inputs.mouseisinsideobj(v,mouse) then 
			table.insert(objects,v)
		end
	end
	return objects
end



util.findfolder = function()
	local folder = workspace:FindFirstChild("extroode_exports")
	if not folder then 
		folder = Instance.new("Folder")
		folder.Name = "extroode_exports"
		folder.Parent = workspace
	end
	return folder
end

util.tocoords = function (x,y,digits) 
	digits = digits or 2
	x = tostring(x) y = tostring(y) x = x:len() < digits and "0"..x or x   
	y = y:len() < digits and "0"..y or y  
	return x..","..y    
end
util.fromcoords = function (coord) 
	local x = coord:match("(%d-),%d+")
	local y = coord:match("%d-,(%d+)")
	return tonumber(x),tonumber(y)
end

util.C3ToHex = function(c3)
	local r,g,b = math.floor(c3.R*255), math.floor(c3.G*255), math.floor(c3.B*255)
	return string.format("%X%X%X", r, g, b)
end

util.HexToC3 = function(hex)      -- from https://gist.github.com/jasonbradley/4357406
	hex = hex:gsub("#","")
	local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
	return Color3.fromRGB(r,g,b)
end

local http = game:GetService("HttpService")

util.jsondecode = function(x)
	return http:JSONDecode(x)
end

util.jsonencode = function(x)
	return http:JSONEncode(x)
end

local Selection = game:GetService("Selection")
util.getselected = function()
	return Selection:Get()[1]
end

util.isstudio = function()
	return RS:IsStudio()
end

--[[util.saveobj = function(object)
	Selection:Set({object})
	PluginManager():ExportSelection()
end]]
