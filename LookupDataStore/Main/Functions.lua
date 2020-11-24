local module = {}
local DS = game:GetService("DataStoreService")
local HTTPS = game:GetService("HttpService")
local History = game:GetService("ChangeHistoryService")
local DSS = require(script.DSS) print(DSS)

function module.Lookup(Name, Key, OutputBox)
	local store = DSS.GetDataStore(Name) print(store)
	local success, entry = DSS.Get(store,Key) print(entry)
	local jsonString = HTTPS:JSONEncode(entry) print(jsonString)
	OutputBox.Text = jsonString
end

function module.Save(Name, Key, newJSON)
	History:SetWaypoint("Changing "..Name.." "..tostring(Key).." to "..newJSON)
	local store = DSS.GetDataStore(Name)	print(store)
	local newEntry = HTTPS:JSONDecode(newJSON)	print(newJSON,newEntry)
	local success, err = DSS.Set(store, Key, newEntry) print(success, err)
	History:SetWaypoint("Changed "..Name.." "..tostring(Key).." to "..newJSON)
end

return module


--[[
To test, select the DSS module and paste this in command bar:
local DS = game:GetService("DataStoreService") local DSS = require(game.Selection:Get()[1])
local Store = DS:GetDataStore("DSPluginTest")
DSS.Set(Store,"Entry1",
{
	["Foo"] = 10; 
	["Bar"] = 13;}
)


Lookup DSPluginTest, Entry1
]]
