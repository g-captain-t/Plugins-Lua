-- G_Captain's Backdoor Scanner
-- g-captain-t/Plugins-Lua/blob/master/

local interface = script.Parent.Interface
local Lb = require(script.Parent.Library)

-- SCANS
local function con (list) return table.concat(list,", ")end
local u = string.upper	

local function CheckScript(theScript)
	local source = theScript.Source
	local flags = {Red={}, Orange={}, Yellow={}}	-- The detected flags in string. 
	
	for _, flag in pairs (Lb.yellowFlags) do if Lb.matchString(source, flag) then table.insert(flags["Yellow"], flag) end end
	for _, flag in pairs (Lb.orangeFlags) do if Lb.matchString(source, flag) then table.insert(flags["Orange"], flag) end end
	for _, flag in pairs (Lb.redFlags) do if Lb.matchString(source, flag) then table.insert(flags["Red"], flag) end end
	for _, flag in pairs (Lb.badNames) do if theScript.Name == flag then table.insert(flags["Red"], flag)end end
	for i, flag in pairs (Lb.ExtraChecks(theScript)) do table.insert(flags["Red"], flag) end

	if (flags["Red"][1] or flags["Orange"][1] or flags["Yellow"][1])==nil then return false end
	return true, flags
end

local function Scan()
	local ScriptCount = 0
	local FlaggedScripts = {}
	
	for i,d in pairs (game:GetDescendants()) do
		local canCheck, isScript = pcall(function() return(d:IsA("Script")) end)
		if canCheck and isScript then  
			ScriptCount = ScriptCount+1
			interface.Frame.ScriptCount.Text = "Scripts Scanned: "..tostring(ScriptCount)
			
			local isFlagged, Flags = CheckScript(d)
			if  isFlagged then table.insert(FlaggedScripts, {d, Flags}) 
			end
		end
	end
	
	--{ AMaliciousScript, {Red={},Orange={},Yellow={}}
	-- Sort the data
	
	--INTERFACE
	for i, v in pairs (interface.Frame["RFlags"]:GetChildren()) do if v.Name ~= "Item" and not v:IsA("UIListLayout") then v:Destroy() end end
	for i, v in pairs (interface.Frame["OFlags"]:GetChildren()) do if v.Name ~= "Item" and not v:IsA("UIListLayout") then v:Destroy() end end
	for i, v in pairs (interface.Frame["YFlags"]:GetChildren()) do if v.Name ~= "Item" and not v:IsA("UIListLayout") then v:Destroy() end end
	
	for i, flagData in pairs (FlaggedScripts) do 	
		local theScript = flagData[1]
		local flagTable = flagData[2]
		
		local scriptName = theScript:GetFullName()
		local warningLevel
		if flagTable["Yellow"][1] ~= nil then warningLevel = "YFlags" end
		if flagTable["Orange"][1] ~= nil then warningLevel = "OFlags" end
		if flagTable["Red"][1] ~= nil then warningLevel = "RFlags" end
		
		local joinedWarnings = con(flagTable["Red"]).." "..con(flagTable["Orange"]).." "..con(flagTable["Yellow"])
		
		local frame = interface.Frame[warningLevel]
		local clonedItem = frame["Item"]:Clone()
		clonedItem.Name = theScript.Name
		clonedItem.TextLabel.Text = scriptName.."\n"
			..joinedWarnings
			.."\nClick here to quarantine script!"
		clonedItem:WaitForChild("Object").Value = theScript
		clonedItem.Parent = frame
		clonedItem.Visible = true
	end
	
	interface.Frame.ScriptCount.Text = interface.Frame.ScriptCount.Text.."\nFlagged Scripts: "..tostring(#FlaggedScripts)
	interface.Frame["RFlags_Button"].TextLabel.Text = interface.Frame["RFlags_Button"].TextLabel.Text.."\n("..tostring(#interface.Frame["RFlags"]:GetChildren()-2)..")"
	interface.Frame["OFlags_Button"].TextLabel.Text = interface.Frame["OFlags_Button"].TextLabel.Text.."\n("..tostring(#interface.Frame["OFlags"]:GetChildren()-2)..")"
	interface.Frame["YFlags_Button"].TextLabel.Text = interface.Frame["YFlags_Button"].TextLabel.Text.."\n("..tostring(#interface.Frame["YFlags"]:GetChildren()-2)..")"	
end 

-- Bind to button
local pluginOn = false
local openPlugin = plugin:CreateToolbar("GCap's Backdoor Scan"):CreateButton("Backdoor Scan","Quarantines flagged scripts, their location, and the flags","rbxassetid://5899414710")

openPlugin.Click:Connect(function()
	pluginOn = not pluginOn
	openPlugin:SetActive(pluginOn)
	interface.Enabled = pluginOn
	if pluginOn then interface.Parent = game.CoreGui
	else interface.Parent = script.Parent end
end)

interface.Frame.Scan.MouseButton1Click:Connect(Scan)
