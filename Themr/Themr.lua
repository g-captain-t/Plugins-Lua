local properties = {
	"Text Color",
	"Background Color",
	"Selection Color",
	"Selection Background Color",
	"Operator Color",
	"Number Color",
	"String Color",
	"Comment Color",
	"Keyword Color",
	"Warning Color",
	"Find Selection Background Color",
	"Matching Word Background Color",
	"Build-in Function Color",
	"Whitespace Color",
	"Current Line Highlight Color",
	"Debugger Current Line Color",
	"Debugger Error Line Color",
	"Local Method Color",
	"Local Property Color",
	"\"nil\" Color",
	"Bool Color",
	"\"function\" Color",
	"\"local\" Color",
	"\"self\" Color",
	"Luau Keyword Color",
	"Function Name Color",
	"TODO Color",
	"Script Ruler Color",
	"Script Bracket Color"
}

local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local sSettings = settings()

local function Save()
	ChangeHistoryService:SetWaypoint("Themr: Saving theme")
	local module = Instance.new("ModuleScript")
	local src = "return {"
	for _, property in ipairs (properties) do 
		local value = sSettings.Studio[property]
		local prefix, suffix = "", ""
		if typeof(value) == "Color3" then
			prefix, suffix = "Color3.new(", ")"
		end
		src = src.."%[\""..property.."\"%] = "..prefix..tostring(value)..suffix..";"
	end
	src = src.."}"
	module.Source = src
	module.Name = "ThemeModule"
	module.Parent = workspace
	print("Themr: Saved current editor theme!")
	ChangeHistoryService:SetWaypoint("Themr: Saved theme")
end

local function Load()
	local selected = Selection:Get()[1]
	assert(typeof(selected)=="Instance" and selected:IsA("ModuleScript"), 
		"Please select a theme module first!")
	local theme = require(selected)
	ChangeHistoryService:SetWaypoint("Themr: Loading theme")
	for property, value in pairs (theme) do 
		pcall(function() sSettings.Studio[property] = value end)
	end
	print("Loaded script editor theme!")
	ChangeHistoryService:SetWaypoint("Themr: Loaded theme")
end

local toolbar = plugin:CreateToolbar("Themr")
local SaveButton = toolbar:CreateButton("Save", "Save your current editor theme", "rbxassetid://5614579544")
local LoadButton = toolbar:CreateButton("Load", "Load an editor theme", "rbxassetid://5614579544")

SaveButton.Click:Connect(Save)
LoadButton.Click:Connect(Load)
