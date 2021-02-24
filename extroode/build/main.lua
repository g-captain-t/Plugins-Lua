-- # OBJECTS

local function newpixel()
	return {
		p=nil;
		r=1;
		c="FFFFFF";
		d=0;
	}
end

local function newproject()
	local self = {
		name = "MyProject";
		canvas = {};
	}
	for y = 1, 16 do 
		self.canvas[y] = {}
		for x = 1, 16 do 
			self.canvas[y][x] = newpixel()
		end
	end
	return self
end

local function newstate()
	return {
		selectedcolor = "FFFFFF";
		selecteddepth = 1;
		selectedpart = "square";
		currentmode = "build";
		currentproject = newproject();
	}
end

local uifolder = script.Parent.UI
local ui = uifolder.UI
local widget

local display = ui.Display
local canvas = display.Canvas 
local viewport = display.Viewport 

local rightbar = ui.RightBar 
local colorpalette = rightbar.ColorPalette 
local depthpalette = rightbar.DepthPalette

local leftbar = ui.LeftBar 

local topbar = ui.TopBar 
local titlebar = topbar.Title 
local actions = ui.TopBar.Actions 
local aexport = actions.Export
local aimport = actions.Import
local arender = actions.Render
local aclear = actions.Clear

local bottombar = ui.BottomBar
local lookup = require(script.Parent.lookup)
local uiutil = require(script.Parent.uiutil)

-- # PLUGIN

--[[local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,  -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	255,    -- Default width of the floating window
	377,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)]]

local toolbar = plugin:CreateToolbar("extroode")
local pluginButton = toolbar:CreateButton("Open", "Open the extroode editor", "rbxassetid://6092226894")

local core = game:GetService("CoreGui")
widget = core:FindFirstChild("extroode_screen")
if widget then
	widget:Destroy()
end

widget = uifolder.extroode_screen --plugin:CreateDockWidgetPluginGui("extroode", widgetInfo)
--widget.Title = "extroode"  
ui.Visible = widget.Enabled
ui.Parent = widget.body

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled 
	ui.Visible = widget.Enabled
	if widget.Enabled then
		plugin:Activate(true)
		widget.Parent = core
	else
		plugin:Deactivate()
		widget.Parent = uifolder
	end
end)


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

local state

-- # FUNCTIONS

local function Import(project)
	local Type = type(project)
	if Type=="string" then 
		project = util.jsondecode(project)
	end
	state.project = project
	titlebar.Text = project.name 
	for _, pxframe in ipairs(canvas:GetChildren()) do 
		local pxX, pxY = util.fromcoords(pxframe.Name)
		if pxframe.ClassName == "Frame" then 
			local pixeldata = project.canvas[pxY][pxX]
			pxframe.Icon.Image = lookup.particons[pixeldata.p] or ""
			pxframe.Icon.ImageColor3 = util.HexToC3(pixeldata.c)
			pxframe.Depth.Text = tostring(pixeldata.d)
			if pixeldata.p ~= "square" and pixeldata.p then 
				pxframe.Icon.Rotation = (pixeldata.r-1)*90
				pxframe.Icon.Size = UDim2.new(1,0,1,0) 
			end
		end
	end
end

local function Clear()
	Import(newproject())
end

local function Export()
	local file = Instance.new("ModuleScript")
	file.Source = "return '"..util.jsonencode(state.project).."'"
	file.Name = state.project.name
	local folder = util.findfolder()
	file.Parent = folder
	return file
end

local function Render(donotparent)
	local container = Instance.new("Model")

	for y, row in ipairs(state.project.canvas) do 
		for x, pixeldata in ipairs(row) do 
			if not pixeldata.p then 
				continue 
			end
			local partmodel = lookup.parts[pixeldata.p]
			if not partmodel then 
				continue 
			end
			partmodel = partmodel:Clone()
			partmodel.Size = Vector3.new(
				pixeldata.d,
				partmodel.Size.Y,
				partmodel.Size.Z
			)
			partmodel.Position = Vector3.new(
				0,
				-x,
				-y
			)
			local prevector = {
				math.floor(pixeldata.r*-90),
				0,
				0
			}
			-- Roblox has weird issues with setting vectors. For example, -180,0,0 becomes 0,-180,0 
			-- when set from code, but 0,180,180 when set by the properties tab. So we have to
			-- process this manually
			if pixeldata.r == 2 then
				prevector = {90, 180, 0}
			end
			partmodel.Orientation = Vector3.new(unpack(prevector))
			partmodel.Orientation = partmodel.Orientation * Vector3.new(1,1,0)
			if pixeldata.p =="roundcorner" then
				print(x,y, pixeldata.r, pixeldata.r*-90, partmodel.Orientation)
			end
			partmodel.Color = util.HexToC3(pixeldata.c)
			partmodel.Parent = container
		end
	end

	if not donotparent then
		local folder = util.findfolder()
		container.Parent = folder
	end

	return container
end

local function MouseDrag(mouseX,mouseY)
	local mouse = util.input.getmouse()
	local pxframe = util.input.gethoveredobjects(canvas)[1]
	if not (pxframe and pxframe:IsDescendantOf(canvas)) then return end 
	local project = state.project
	local pxX, pxY = util.fromcoords(pxframe.Name)
	local pixeldata = project.canvas[pxY][pxX]
	local mode = state.currentmode

	if mode=="build" then 
		local currentcolor = state.selectedcolor
		local currentpart = state.selectedpart
		local currentparticonid = lookup.particons[currentpart] or ""
		if currentpart~="" then 
			pixeldata.d = tonumber(pixeldata.d) < 1 and 1 or tonumber(pixeldata.d)
			pixeldata.c = currentcolor
			pixeldata.p = currentpart
			pxframe.Icon.ImageColor3 = util.HexToC3(currentcolor)
		else
			pixeldata.d = 0
			pixeldata.p = nil
		end
		pxframe.Icon.Image = currentparticonid
	elseif mode=="paint" then 
		if not pixeldata.p then return end
		local currentcolor = state.selectedcolor
		pixeldata.c = currentcolor
		pxframe.Icon.ImageColor3 = util.HexToC3(currentcolor)
	elseif mode=="depth" then 
		local currentdepth = state.selecteddepth
		pixeldata.d = currentdepth
		pxframe.Depth.Text = tostring(currentdepth)
		print(currentdepth)
	elseif mode=="preview" then 
		--nothing
	end
end

-- str:match("^a"):upper()..str:match("^a(.+)")

local function ModeSelect(mode)
	print(mode)
	local button = leftbar[mode]
	uiutil.select(button, button.Parent)
	mode = mode:lower()
	state.currentmode = mode
	local function closeviewport()
		local render = viewport:FindFirstChildOfClass("Model")
		if render then render:Destroy()	end
		viewport.Visible = false
	end
	local function toggledepth(bool)
		for _, pxframe in ipairs(canvas:GetChildren()) do 
			local x,y = util.fromcoords(pxframe.Name)
			if pxframe.ClassName=="Frame" and x and y then 
				local pixeldata = state.project.canvas[y][x]
				pxframe.Depth.Text = pixeldata.d
				pxframe.Depth.Visible = pixeldata.p ~=nil and bool or false
			end
		end
	end
	if mode=="build" then 
		colorpalette.Visible = true
		depthpalette.Visible = false
		toggledepth(false)
		closeviewport()
	elseif mode=="paint" then 
		colorpalette.Visible = true
		depthpalette.Visible = false
		toggledepth(false)
		closeviewport()
	elseif mode=="depth" then 
		colorpalette.Visible = false
		depthpalette.Visible = true
		toggledepth(true)
		closeviewport()
	elseif mode=="preview" and state.currentmode~="preview" then 
		local render = Render(true)
		render.Parent = viewport
		viewport.Visible = true
	end
end

local function Rotate(mouseX,mouseY)
	local pxframe = util.input.gethoveredobjects(canvas)[1] 
	if not (pxframe and pxframe:IsDescendantOf(canvas)) then return end
	local project = state.project
	local pxX, pxY = util.fromcoords(pxframe.Name)
	local pixeldata = project.canvas[pxY][pxX]
	if pixeldata.p == "square" or not pixeldata.p then return end
	pixeldata.r = pixeldata.r == 8 and 1 or pixeldata.r + 1
	pxframe.Icon.Rotation = (pixeldata.r-1)*90
	pxframe.Icon.Size = UDim2.new(1,0,1,0) 
	print(pixeldata.r, project.canvas[pxY][pxX].r)
end

local function DepthSelect(option)
	option = option or state.selecteddepth
	local button = depthpalette:FindFirstChild(option)
	uiutil.select(button, depthpalette)
	state.selecteddepth = tonumber(option)
end

local function ColorSelect(option)
	option = option or state.selectedcolor
	local button = colorpalette:FindFirstChild(option)
	uiutil.select2(button, colorpalette)
	state.selectedcolor = option
end

local function PartSelect(option)
	option = option or state.selectedpart
	local button = bottombar:FindFirstChild(option)
	uiutil.select(button, bottombar)
	state.selectedpart = option
end

local function TitleChange(newtitle)
	newtitle = newtitle or state.project.name
	state.project.name = newtitle
	titlebar.Text = newtitle
end

local function Initial()
	state = newstate()
	Import(newproject())
	DepthSelect()
	ColorSelect()
	PartSelect()
	TitleChange()
end

Initial()

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