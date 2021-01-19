--[[

gitimport
Author: g_captain
Import GitHub files and repositories into Roblox

]]

local HTTP = game:GetService("HttpService")
local Selection = game:GetService("Selection")
local gitimport = {}

local function getraw(url)
	--// Returns the raw URL
	local israw = url:find("https://raw.githubusercontent.com/.-/.-/")
	if israw then return url end
	assert(url:find("https://github.com/.-/.-/"), "Link provided must be a github.com or raw.githubusercontent.com link!")
	local rawurl = url:gsub("https://github.com/(.-)/(.-)/.-/(.+)", "https://raw.githubusercontent.com/%1/%2/%3")
	return rawurl
end

local function getfilename(url)
	local _, _, r = url:reverse():find("aul%.(.-)/")
	_,_,r = r and url:reverse():find("(.-)/") or nil,nil,r
	return r and r:reverse()
end

local function getreponame(url)
	local _, _, name = url:find("https://.-%.com/.-/(.-)/") 
	_,_,name = name and url:find(".-/(.-)") or nil,nil,name
	return name
end

local function ismodule(src)
	local testm = Instance.new("ModuleScript")
	local s,_ = pcall(function() 
		testm.Source = src
		require(testm) 
	end)
	testm:Destroy()
	return s
end

function gitimport.ImportToSelection(url)
	--// Import a source into a selected script
	local s = Selection:Get()[1]
	assert(s:IsA("Script") or s:IsA("ModuleScript"), "Selected object must be a script!")
	local success, raw = pcall(function()
		local rawurl = getraw(url)
		return HTTP:GetAsync(rawurl)
	end)
	assert(success, "Error importing source to selected:" .. raw)
	s.Source = raw
	warn("Successfully imported to selection from " .. url .. "!")
end

function gitimport.ImportToNewScript(url, scriptclass)
	--// Convert a source url to a new script
	
	local success, raw = pcall(function()
		local rawurl = getraw(url)
		return HTTP:GetAsync(rawurl)
	end)
	
	assert(success, "Error importing to new script from URL: " .. raw)

	local filename = getfilename(url)
	local name, class = filename, scriptclass or "Script"
	if not scriptclass then
		if filename:match("(.-).server") then
			name = filename:match("(.-).server")
			class = "Script"
		elseif filename:match("(.-).client") then
			name = filename:match("(.-).client")
			class = "LocalScript"
		elseif ismodule(raw) then
			class = "ModuleScript"
		end
	end

	local newscript = Instance.new(class)
	newscript.Name = name
	return newscript
end

function gitimport.getcontent(get, foldername)
	--// Import a folder from api.github.com/repos/[author]/[repo]/contents/
	local s, content = pcall(function()
		local c = HTTP:GetAsync(get)
		return c and HTTP:JSONDecode(c)
	end)
	assert(s, content)

	local contentfolder = Instance.new("Folder")
	contentfolder.Name = foldername

	for _, item in pairs(content) do
		local isfolder = item.download_url == nil
		local _, _, name = item.name:find("(.-)%.lua") 
		name = isfolder and item.name or name
		if name then --// Is a .lua file or a folder
			game:GetService("RunService").Heartbeat:Wait()
			print("Importing " .. item.name .. "...")
			if isfolder then
				--// Repeat new folder
				local get = item.url
				local childfolder = gitimport.getcontent(get, item.name)
				childfolder.Parent = contentfolder
			else
				--// Insert script directly
				local newscript = gitimport.ImportToNewScript(item.download_url)
				newscript.Parent = contentfolder
			end
		end
	end

	return contentfolder
end

function gitimport.ImportRepository(shorturl)
	--// Import an entire repository as a folder
	local _, _, reponame = shorturl:find(".-/(.-)")
	assert(reponame, "Error importing from short URL: Please provide the URL in a Username/Repository format!")
	local get = "https://api.github.com/repos/" .. shorturl .. "/contents/"
	local repofolder = gitimport.getcontent(get, reponame)
	if repofolder then
		repofolder.Parent = workspace
		warn("Successfully imported repository " .. shorturl .. "!")
	end
end

return gitimport
