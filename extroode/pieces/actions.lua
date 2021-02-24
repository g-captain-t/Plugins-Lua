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