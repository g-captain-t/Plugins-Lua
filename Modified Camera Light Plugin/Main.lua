-- Camera Light Plugin
-- Crazyman32
-- August 3, 2013

-- Modified June 29, 2014
-- Configured for published use

-- Modified February 28, 2017
-- API standardizations
-- Updater bound to RenderStep
-- GUI is not created until plugin is first used
-- Light recreates itself if created
-- Light remembers property changes made during life of studio session


-- So it isn't in the way of the camera:
local OFFSET = CFrame.new(0, 0, 2)
local RENDER_BIND_NAME = "CameraLightPluginUpdate"

local isOn = false
local interface = script.Parent.Interface

local lightPart
local overrides = {}

local brightness = 1
local range = 60
local color = Color3.new(1,1,1)




-- Get the light part:
local function GetLightPart()
	if ((not lightPart) or (not lightPart.Parent)) then
		if (lightPart) then
			lightPart:Destroy()
		end
		lightPart = Instance.new("Part")
		lightPart.Name = "CameraLight"
		lightPart.Anchored, lightPart.Locked, lightPart.CanCollide, lightPart.Archivable = true, true, false, false
		lightPart.TopSurface, lightPart.BottomSurface = Enum.SurfaceType.Smooth, Enum.SurfaceType.Smooth
		lightPart.Size = Vector3.new(0.2, 0.2, 0.2)
		lightPart.Transparency = 1
		local light = Instance.new("SpotLight", lightPart)
		light.Brightness = brightness -- Brightness
		light.Color = color -- Color
		light.Range = range -- Range
		light.Angle = 120
		light.Enabled = true
		lightPart.Parent = game.Workspace
		light.Changed:Connect(function(property)
			if (property ~= "Parent") then
				overrides[property] = light[property]
			end
		end)
		for property,value in pairs(overrides) do
			light[property] = value
		end
	end
	return lightPart
end


-- Update light position to camera's position:
function UpdateLight()
	GetLightPart().CFrame = workspace.CurrentCamera.CFrame * OFFSET
	GetLightPart().SpotLight.Brightness = brightness -- Brightness
	GetLightPart().SpotLight.Color = color -- Color
	GetLightPart().SpotLight.Range = range -- Range
end



--UI

function checkParameter(inputBox) -- Must be number
	if tonumber(inputBox.Text) == nil then inputBox.Text = "1" end
end

-- Toggle the light:

interface.Frame.Toggle.MouseButton1Click:Connect(function ()
	isOn = not isOn
	if isOn then
		game:GetService("RunService"):BindToRenderStep(RENDER_BIND_NAME, Enum.RenderPriority.Camera.Value - 1, UpdateLight)
	else
		game:GetService("RunService"):UnbindFromRenderStep(RENDER_BIND_NAME)
		lightPart:Destroy()
	end
end)

-- Brightness & Range input
local brightnessinput = interface.Frame.BrightnessInput
local rangeinput = interface.Frame.RangeInput

brightnessinput.FocusLost:Connect(function()
	checkParameter(brightnessinput)
	brightness = tonumber(brightnessinput.Text)
end)
rangeinput.FocusLost:Connect(function()
	checkParameter(rangeinput)
	range = tonumber(rangeinput.Text)
end)

-- Color Change

local colorpicker = interface.ColorPicker
colorpicker.Display:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
	color = colorpicker.Display.BackgroundColor3
end)


-- Original code by sleitnick's Camera Light 
-- (https://www.roblox.com/library/163874890/Camera-Light)
-- UI and customizable features by g_captain 
