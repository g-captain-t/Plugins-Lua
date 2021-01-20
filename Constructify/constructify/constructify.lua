--[[

Constructify
Author: g_captain
Generates the constructor string of any object and its children in this format:

local o = Instance.new(classhere)
for i,v in pairs ({
	["Property"] = value;
	["Property"] = value;
}) do 
	o[i]=v
end
o.Parent = parentvarname

]]


local Ser = require(script.serialize)
local HTTPS = game:GetService("HttpService")

local httpenabled, latestjson = pcall(function()
	return HTTPS:GetAsync("https://anaminus.github.io/rbx/json/api/latest.json")
end)
latestjson = latestjson and HTTPS:JSONDecode(latestjson)


--// Table shortcuts

local function tablemerge(t1,t2)
	for i,v in pairs (t2) do
		if type(i)=="string" then
			t1[i]=v
		else
			table.insert(t1,v)
		end
	end
end
local function tablefind(t,value)
	for i,v in pairs (t) do
		if v==value then return i,v end
	end
end

--// Retrieves all the properties of a class from anaminus' API dump
local gp = {} -- Allow the function to call itself

local function GetProperties(class)
	assert(httpenabled, "Error retrieving properties. Please check if HTTP requests are enabled.")
	local properties = {}
	for _,data in pairs (latestjson) do
		if data.type=="Property" and data.Class==class and not tablefind(data.tags,"readonly") then
			table.insert(properties,data.Name)
		elseif data.type=="Class" and data.Name==class then
			--// Insert superclass as well for inherited properties
			wait()
			local superclassprops = data.Superclass and gp.GetProperties(data.Superclass) or {}
			--// merge properties
			tablemerge(properties, superclassprops)
		end
	end
	return properties
end

gp.GetProperties = GetProperties

--// Returns the string form of a key-value pair
--// ["Key"] = Value;

local function toIV(index,value)
	local str = "[\""..index.."\"] = "
	local Type = typeof(value)
	local val
	if Type == "EnumItem" then
		val = tostring(value)
	elseif Type == "BrickColor" then
		val = "BrickColor.new(\""..tostring(value).."\")"
	elseif Type == "Rect" then
		val = "Rect.new(Vector2.new("..value.Min.X..","..value.Min.Y.."),Vector2.new("..value.Max.X..","..value.Max.Y.."))"
	elseif Ser.lib[Type] then
		local serd = Ser.Serialize(value)
		val = serd[1]..".new("
		for i,v in pairs (serd[2]) do 
			if i==#serd[2] then 
				val=val..v
			else 
				val=val..v..","
			end
		end
		val = val..")"
	elseif Type=="number" or Type=="boolean" then
		val = tostring(value)
	elseif Type=="string" then
		val = "\""..value.."\""
	else print(Type)
	end
	return val and str..val..";"
end

--// Main

local c = {}

local function constructify (obj, variableName, parentvarname, ignoreDescendants)
	if obj:IsA("Script") or obj:IsA("ModuleScript") then return end

	variableName = variableName or obj.Name
	variableName = variableName:gsub("%s+","_")
	
	local class = obj.ClassName
	--// Check if instance is creatable
	--// Also compare to default so we only take the changed properties
	local success, default = pcall( function ()
		return Instance.new(class)
	end)
	if not success then return end
	local properties = GetProperties(class)
	
	print("Getting constructors for "..obj.Name.."...")

	local str = "local "..variableName.." = Instance.new(\""..class.."\")\nfor i,v in pairs ({"

	for _, property in pairs (properties) do 
		local vstr
		local s,value = pcall(
			function() 
				return obj[property]
			end)
		if s and value and value ~= default[property] and property ~= "Parent" and typeof(property) ~= "Instance" then
			vstr = toIV(property, value)
		end
		str=vstr and str..vstr.."\n" or str
	end

	str = str.."}) do \n	"..variableName.."[i] = v\nend\n"

	--// If the parent variable name is probided
	str = parentvarname and str..variableName..".Parent = "..parentvarname or str

	--// Retrieve the children's constructors and merge it
	if not ignoreDescendants then 
		for _,child in pairs (obj:GetChildren()) do 
			local childstr = c.constructify(child, child.Name, variableName)
			str = childstr and str.."\n\n"..childstr or str
		end
	end

	default:Destroy()
	return str
end

c.constructify = constructify

return constructify
