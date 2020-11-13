-- LIBRARY

-- Yellow flags: - Only caution warnings, may not need to remove as a lot of non-malicious systems also use this. Just a reminder to check the source, developer or context of the script.
-- Orange flags: - Check immediately if this is from a trusted source.
-- RedFlags: -- most likely exploits or backdoors.

local Library = {}

 Library.yellowFlags = {	
	"PromptPurchase", "serverscriptservice"
}
 Library.orangeFlags = {
	"loadstring","string.byte",":Run()", "script.Parent=game.ServerScriptService", "require","TeleportService", 
	":IsStudio()", "math.ldexp"
}
 Library.redFlags = { 
	"synapse", "getfenv","setfenv", "getsenv", "luraph", "Instance.new('Script", 'Instance.new("Script',
	"IronBrew", "bruh_I", "bruh_l", "Illll", "IlIl", "llllI", "\239\191\188", "obfuscat", "haxor"
}

 Library.badNames = { -- credits to Dan_PanMan 's Antivirus
	"","script..", "c-rex", "vaccine", "spread", "fire", "INfecTION","Script......Or is it...", "4D Being", "ThisScriptIsAJumpStartToAHe�lthyLifestyle", "micolord","ProperGr�mmerNeededInPhilosiphalLocations;insertNoobHere","bryant90","OH SNAP YOU GOT INFECTED XD XD XD","Wormed","NOISE","N0ISESCRIPT","Virus","ISt�rtHere","garmo hacked ur place","N00B 4TT4CK!","d��������������ng.........you got owned...","letgo09","sonicthehedgehogxx Made this!!","VIVRUS","WTFZ0R","IMAHAKWTFZ","I'm getting T1R33D","System Error 69605X09423","STFU NOOB","SkapeTTAJA","FreeStyleM�yGoAnywhereIfNeeded","Hello...I �m Your New Lord Lolz","Hello I am your new lord lolz","Elkridge Fire Department","Zackisk","join teh moovment!","Kill tem!";"StockSound";"Deth 2 teh samurai!";"OHAI";"OH SNAP YOU GOT INFECTED XD XD XD";"No samurai plzzz";"4D Being";"Virus";"4dbeing";"4d being";"loser";"infected";"rolf";"Wildfire";"geometry";"guest talker";"anti-lag";"snap infection";"numbrez";"imahakwtfz";"wtfzor";"d??????????????ng.........you got owned...";"vivrus";"zomg saved";"hello...i ?m your new lord lolz";"worm";"guest_talking_script";"snapreducer";"snap-reducer";"script.....or..is.it";"timer";"datacontrollers";"chaotic";"teleportscript";"spreadify";"antivirussoftware";"2_2_1_1_s_s_";"safity lock";"ropack";"no availiblitly lock";"protection";"whfcjgysa";"073dea7p";"Snap Reducer";"ROFL";"Anti Lag";"AntiLag";"AntiVirus";"Anti-Virus";"Anti Virus";"Guest Free Chat Script";"lol";"bob";"Snap Remover";"SnapRemover";"N00B 4TT4CK";"garmo hacked ur place";"?9001";"bryant90";"Dont Worry Im A Friendly Virus";"IsAVirus";"Wormed";"stanley12345678910";"micolord";"charlie84";"cahrlie84";"SkapeTTAJA";"STFU NOOB";"Random?GoesHere:3";"Making Cat Ice Cream Make Me Happy!";"ANTIVIRISIS";"ANTIVIRIS";"77?";"IAmHereToHe?lYourPlace";"ProperGr?mmerNeededInPhilosiphalLocations;insertNoobHere";"I'm getting T1R33D";"H4XXX :3";"Sunstaff";"boomboom9188";"FreeStyleM?yGoAnywhereIfNeeded";"ThisScriptIsAJumpStartToAHe?lthyLifestyle";"d??????????????ng.........you got owned...";"Deidara4 is sick of you noobs.";"Fire";"FeelFreeToIns3rtGramm?tic?lErrorsHere";"Nomnomnom1 will hack you too! MWAHAHA!";"ZXMLFCSAJORWQ#)CXFDRE)$#Q)JCOUSEW#)@!HOIFDS(AEQ#HI*DFHRI(#FA";"NoNoIDon'tNeedAllOfYourAwkw?rdSovietArguments";[[""''""''""?|`?]];"ISt?rtHere";"**virusmaster**";"Vivurursdd"
}

local u = string.upper	
function Library.matchString(source, Flag)
	local match, letters = string.find(u(source), u(Flag))
	if match ~= nil then return true end
end	

function Library.ExtraChecks(aScript)
	local flaggedChecks = {} -- The checks and message
	local Checks = { 
		{(aScript.Name == ""), "Script's name is blank"};
		{(Library.matchString(aScript.Source, "\239\191\188")), "Hidden character"};
	}
	for i, v in pairs (Checks) do if v[1] then table.insert(flaggedChecks, v[2]) end end
	return flaggedChecks
end


return Library
