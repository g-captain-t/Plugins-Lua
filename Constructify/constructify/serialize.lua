--[[

Serialize
Author: g_captain
Serializes Roblox datatypes into tables. A serialized value looks like this:
{"Vector3",{13,4,3}}

BrickColor
CFrame
Color3
EnumItem
NumberRange
UDim
UDim2
Vector2
Vector3

]]

local Serialize = {}

function Serialize.pack(dtype, value)
	return {dtype, value}
end
local pack = Serialize.pack

Serialize.lib = {
	["BrickColor"] = {
		serialize = function(value) 
			return pack("BrickColor", {tostring(value)})
		end,
	},
	["CFrame"] = {
		serialize = function(value)
			return pack("CFrame", {value:GetComponents()})
		end,
	},
	["Color3"] = {
		serialize = function(value)
			local f = math.floor
			-- return pack("Color3", {f(value.R*255), f(value.G*255), f(value.B*255)})
			--// Just for the constructor, use RGB/255
			return pack("Color3", {value.R, value.G, value.B})
		end,
	},
	["EnumItem"] = {
		serialize = function(value)
			local str = tostring(value)
			local _, _, k, v = str:find("Enum%.(%a+)%.(%a+)")
			local split = {k, v}
			return pack("EnumItem", split)
		end,
	},
	["NumberRange"] = {
		serialize = function(value)
			return pack("NumberRange", {value.Min, value.Max})
		end,
	},
	["UDim"] = {
		serialize = function(value)
			return pack("UDim", {value.Scale, value.Offset})
		end,
	},
	["UDim2"] = {
		serialize = function(value)
			return pack("UDim2", {value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset})
		end,
	},
	["Vector2"] = {
		serialize = function(value)
			return pack("Vector2", {value.X, value.Y})
		end,
	},
	["Vector3"] = {
		serialize = function(value)
			return pack("Vector3", {value.X, value.Y, value.Z})
		end,
	}
}

function Serialize.Serialize(value)
	local Type = typeof(value)
	if Serialize.lib[Type] then
		return Serialize.lib[Type].serialize(value)
	else
		return value
	end
end

return Serialize
