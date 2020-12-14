-- SkyFolder by g_captain
-- A plugin for me to pack lighting and skies in a folder, and load them whenever I want

local function Save()
	local Lighting = game:GetService("Lighting")
	local SkyFolder = Instance.new("Folder")
	SkyFolder.Name = "SkyFolder"

	local LightingModule = Instance.new("ModuleScript", SkyFolder)
	LightingModule.Name = "LightingModule"
	local LightingProperties = {
		"Ambient", "Brightness", "ColorShift_Bottom", "ColorShift_Top", "EnvironmentDiffuseScale", "EnvironmentSpecularScale", "OutdoorAmbient", "ShadowSoftness", "ClockTime", "GeographicLatitude", "ExposureCompensation"
	}
	local longstring = "local Properties = {"
	for _, prop in pairs (LightingProperties) do
		longstring = longstring.."\n[\""..prop.."\"] = "..tostring(Lighting[prop])..";"
	end
	LightingModule.Source = longstring.."\n}\nreturn Properties"


	local Children = Instance.new("Folder", SkyFolder)
	Children.Name = "Children"
	for _, child in pairs (Lighting:GetChildren()) do
		child:Clone().Parent = Children
	end

	SkyFolder.Parent = Lighting
	print("Saved SkyFolder!")
end

local function Load()
	local Lighting = game:GetService("Lighting")
	local Selection = game:GetService("Selection")
	local History = game:GetService("ChangeHistoryService")
	History:SetWaypoint("Loading SkyFolder")

	local SkyFolder = Selection:Get()[1]
	if not SkyFolder then warn("Select a SkyFolder first!") return end

	local LightingModule = SkyFolder:FindFirstChild("LightingModule")
	if LightingModule then
		for property, value in pairs (require(LightingModule)) do
			pcall(function() Lighting[property] = value end)
		end
	end
	
	local Children = SkyFolder:FindFirstChild("Children")
	if Children then
		for _, child in pairs (Children:GetChildren()) do
			child:Clone().Parent = Lighting
		end
	end

	print(SkyFolder.Name.." successfully loaded!")
	History:SetWaypoint("Loaded SkyFolder")
end

local toolbar = plugin:CreateToolbar("SkyFolder")
local SaveButton = toolbar:CreateButton("Save", "Save the current Lighting", "rbxassetid://6086217020")
local LoadButton = toolbar:CreateButton("Load", "Load a selected SkyFolder", "rbxassetid://6086216649")

SaveButton.Click:Connect(Save)
LoadButton.Click:Connect(Load)
