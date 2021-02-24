local lookup = {}
local store = script.Parent.Store

-- looking for colors? she moved, talk to util for hextoC3

lookup.particons = {}
local particonfolder = store.PartIcons
for _, icon in ipairs(particonfolder:GetChildren()) do 
	lookup.particons[icon.Name] = icon.Image
end

lookup.parts = {}
local partfolder = store.Parts
for _, part in ipairs(partfolder:GetChildren()) do 
	lookup.parts[part.Name] = part
end

return lookup