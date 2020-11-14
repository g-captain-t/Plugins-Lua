-- The old non-interface main code that only prints the results in output.
-- This is kept here as a reference to the main mechanism that just sorts the data, before throwing in an interface and additional actions.

local Lb = require(script.Parent.Library)

local u = string.upper	
local function matchString(source, Flag)
	local match, letters = string.find(u(source), u(Flag))
	if match ~= nil then return true end
end	

local function CheckScript(theScript)
	local source = theScript.Source
	local flags = {}	-- The detected flags in string. 
	
	for _, flag in pairs (Lb.yellowFlags) do if matchString(source, flag) then table.insert(flags, flag) end end
	for _, flag in pairs (Lb.orangeFlags) do if matchString(source, flag) then table.insert(flags, flag) end end
	for _, flag in pairs (Lb.redFlags) do if matchString(source, flag) then table.insert(flags, flag) end end
	for _, flag in pairs (Lb.badNames) do if theScript.Name == flag then table.insert(flags, flag)end end
	for i, flag in pairs (Lb.ExtraChecks(theScript)) do table.insert(flags, flag) end

	if flags[1]==nil then return false end
	return true, flags
end

local function Scan()
	local ScriptCount = 0
	local FlaggedScripts = {}
	
	
	for i,d in pairs (game:GetDescendants()) do
		local canCheck, isScript = pcall(function() return(d:IsA("Script")) end)
		if canCheck and isScript then  
			ScriptCount = ScriptCount+1
			local isFlagged, Flags = CheckScript(d)
			if  isFlagged then
				local stringFlags = table.concat(Flags,", ")
				table.insert(FlaggedScripts, {d, stringFlags})   -- Example: AMaliciousScript, "getfenv, loadstring"
			end
		end
	end
	
	-- All the data has been sorted, now print it out
	warn("---------------------------------------------")
	for i, flagData in pairs (FlaggedScripts) do 	
		warn("[Backdoor Scan] FLAG:", flagData[1]:GetFullName(), flagData[2]) 
	end
	warn("---------------------------------------------")
	warn("[Backdoor Scan] Total Scripts Scanned:", ScriptCount)
	warn("[Backdoor Scan] Flagged Scripts:", #FlaggedScripts)
end 

-- Bind to button
local openPlugin = plugin:CreateToolbar("GCap's Backdoor Scan"):CreateButton("Backdoor Scan","Prints out flagged scripts, their location, and the flags","rbxassetid://5899414710")
openPlugin.Click:Connect(Scan)
