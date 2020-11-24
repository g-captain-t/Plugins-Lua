local module = {}
local DS = game:GetService("DataStoreService")
local HTTPS = game:GetService("HttpService")
local History = game:GetService("ChangeHistoryService")
local DSS = require(script.DSS)

function module.Lookup(Name, Key, OutputBox, isOrdered, scope)
	local store = isOrdered and DSS.GetOrderedStore(Name, scope) or DSS.GetDataStore(Name, scope) print(store)
	local success, entry = DSS.Get(store,Key) print(entry)
	local jsonString = HTTPS:JSONEncode(entry) print(jsonString)
	OutputBox.Text = jsonString
end

function module.Save(Name, Key, newJSON, isOrdered, scope)
	History:SetWaypoint("Changing "..Name.." "..tostring(Key).." to "..newJSON)
	local store = isOrdered and DSS.GetOrderedStore(Name) or DSS.GetDataStore(Name)	print(store)
	local newEntry = HTTPS:JSONDecode(newJSON)	print(newJSON,newEntry)
	local success, err = DSS.Set(store, Key, newEntry) print(success, err)
	print("Changed "..Name.." "..tostring(Key).." to "..newJSON)
	History:SetWaypoint("Changed "..Name.." "..tostring(Key).." to "..newJSON)
end

return module


--[[ NOTE TO SELF
To test, select the DSS module and paste this in command bar:
local DS = game:GetService("DataStoreService") local DSS = require(game.Selection:Get()[1])
local Store = DS:GetDataStore("DSPluginTest")
DSS.Set(Store,"Entry1",
{
	["Foo"] = 10; 
	["Bar"] = false;}
)
Lookup DSPluginTest, Entry1
]]
