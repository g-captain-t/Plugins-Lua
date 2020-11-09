-- G_Captain's Backdoor Scans
-- Prints out the backdoor keywords found in scripts.
-- g-captain-t/Plugins-Lua/blob/master/


local Lb = require(script.Parent.Library)

local Iletters = {"I","l","1"}
for i=1, 3 do local onLetter = Iletters[i] 
	for i2=1,3 do local onLetter2 = Iletters[i2] 
		for i3=1,3 do 
			local onLetter3 = Iletters[i3] 
			local joined = onLetter..onLetter2..onLetter3
			table.insert (Lb.redFlags, onLetter..onLetter2..onLetter3)
			-- Counts as Yellow unless multiple of them are found "CanCollide" "BillboardGui" "Falling"
		end
	end
end -- Insert all the possible 3-character I1l's into redFlags




-- SCANS

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
