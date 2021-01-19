local gitimport = require(script.Parent.gitimport)
local Selection = game:GetService("Selection")
local CHS = game:GetService("ChangeHistoryService")

local toolbar = plugin:CreateToolbar("GitImport") --// I have no thumbnail
local File = toolbar:CreateButton("Import File", "Import a .lua file into a script", "rbxassetid://5614579544")
local Repo = toolbar:CreateButton("Import Repo", "Import a repository into workspace", "rbxassetid://5614579544")

local RepoFrame = script.Parent.ImportRepo
local FileFrame = script.Parent.ImportFile

RepoFrame.Size, RepoFrame.Position = UDim2.new(1,0,1,0), UDim2.new(0,0,0,0)
FileFrame.Size, FileFrame.Position = UDim2.new(1,0,1,0), UDim2.new(0,0,0,0)

local repowidgetinfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,  -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	296,    -- Default width of the floating window
	177,    -- Default height of the floating window
	296,    -- Minimum width of the floating window
	177     -- Minimum height of the floating window
)
local repowidget = plugin:CreateDockWidgetPluginGui("Import Repository", repowidgetinfo)
repowidget.Title = "Import Repository"  
RepoFrame.Parent = repowidget

local filewidgetinfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	false,   -- Widget will be initially enabled
	false,  -- Don't override the previous enabled state
	296,    -- Default width of the floating window
	177,    -- Default height of the floating window
	296,    -- Minimum width of the floating window
	177     -- Minimum height of the floating window
)
local filewidget = plugin:CreateDockWidgetPluginGui("Import File", filewidgetinfo)
filewidget.Title = "Import File"  
FileFrame.Parent = filewidget

File.Click:Connect(function()
	filewidget.Enabled = not filewidget.Enabled
end)

Repo.Click:Connect(function()
	repowidget.Enabled = not repowidget.Enabled
end)

RepoFrame.Import.MouseButton1Click:Connect(function()
	local shorturl = RepoFrame.URL.Text
	if shorturl:len() == 0 then return end
	CHS:SetWaypoint("Starting repo import")
	gitimport.ImportRepository(shorturl)
	CHS:SetWaypoint("Finished repo import")
end)

FileFrame.Actions.ImportSelected.MouseButton1Click:Connect(function()
	local url = FileFrame.URL.Text
	if url:len() == 0 then return end
	local class = FileFrame.ScriptClass.selected.Value or "Script"
	CHS:SetWaypoint("Starting file import")
	gitimport.ImportToSelection(url,class)
	CHS:SetWaypoint("Finished file import")
end)

FileFrame.Actions.ImportNew.MouseButton1Click:Connect(function()
	local url = FileFrame.URL.Text
	if url:len() == 0 then return end
	local class = FileFrame.ScriptClass.selected.Value or "Script"
	CHS:SetWaypoint("Starting file import")
	local newscript = gitimport.ImportToNewScript(url,class)
	newscript.Parent = workspace
	CHS:SetWaypoint("Finished file import")
end)

local radiobuttons = {}
local oncolor = FileFrame.ScriptClass.color_on.Value
local offcolor = FileFrame.ScriptClass.color_off.Value

local function updatebuttons()
	local currentselected = FileFrame.ScriptClass.selected.Value
	for _, radio in ipairs(radiobuttons) do
		if radio.Parent.Name == currentselected then
			radio.ImageColor3 = oncolor
			radio.On.Visible = true
		else
			radio.ImageColor3 = offcolor
			radio.On.Visible = false
		end
	end
end

for _, class in ipairs (FileFrame.ScriptClass:GetChildren()) do
	if class:IsA("Frame") then
		table.insert(radiobuttons,class.Radio)
		class.Radio.MouseButton1Click:Connect(function()
			FileFrame.ScriptClass.selected.Value = class.Name
			updatebuttons()
		end)
		class.Radio.On.ImageColor3 = oncolor
	end
end

FileFrame.ScriptClass.selected.Value = "Script"
updatebuttons()
