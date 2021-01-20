# Constructify
An experimental object-to-constructor converter for Roblox. Below is an example of a deconstructed object:
```lua
local o = Instance.new(classhere)
for i,v in pairs ({
	["Property"] = value;
	["Property"] = value;
}) do 
	o[i]=v
end
o.Parent = parentvarname
```

> Disclaimer: Constructify is experimental and may be occasionally unstable. It is meant to be a shortcut to quickly serialize objects, and you may need to debug and filter the output accordingly. If you find any bugs or have improvements, feel free to fork your own version or contribute!
