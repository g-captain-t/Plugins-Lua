--[[

GitImport
Author: g_captain
Importing GitHub files and repositories into Roblox

]]
local HTTP = game:GetService("HTTPService")
local GitImport = {}

local function getraw(url)
    --// Returns the raw URL
    local israw = url:find("https://raw.githubusercontent.com/.-/.-/")
    if israw then
        return url
    end
    assert(
        url:find("https://github.com/.-/.-/"),
        "Link provided must be a github.com or raw.githubusercontent.com link!"
    )
    local rawurl = url:gsub("https://github.com/(.-)/(.-)/.-/(.+)", "https://raw.githubusercontent.com/%1/%2/%3")
    return rawurl
end

local function getfilename(url)
    local _, _, r = url:reverse():find("aul%.(.-)/") or url:reverse():find("(.-)/")
    return r and r:reverse()
end

local function getreponame(url)
    local _, _, name = url:find("https://.-%.com/.-/(.-)/") or url:find(".-/(.-)")
    return name
end

local function ismodule(src)
    return pcall(
        function()
            require(loadstring(src)())
        end
    )
end

function GitImport.ImportToSelection(url)
    --// Import a source into a selected script
    local s = Selection:Get()[1]
    assert(s:IsA("Script") or s:IsA("ModuleScript"), "Selected object must be a script!")
    local success, raw =
        pcall(
        function()
            local rawurl = getraw(url)
            return HTTP:GetAsync(rawurl)
        end
    )
    assert(success, "Error importing source to selected:" .. v)
    s.Source = rawurl
    warn("Successfully imported to selection from " .. url .. "!")
end

function GitImport.ImportToNewScript(url, scriptclass)
    --// Convert a source url to a new script
    local success, raw =
        pcall(
        function()
            local rawurl = getraw(url)
            return HTTP:GetAsync(rawurl)
        end
    )
    assert(success, "Error importing to new script from URL: " .. v)

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

function GitImport.getcontent(get, foldername)
    --// Import a folder from api.github.com/repos/[author]/[repo]/content/
    local s, content =
        pcall(
        function()
            local c = HTTP:GetAsync(get)
            return c and HTTP:JSONDecode(c)
        end
    )
    assert(s, content)

    local contentfolder = Instance.new("Folder")
    contentfolder.Name = foldername

    for _, item in pairs(content) do
        wait()
        print("Importing " .. content.name .. "...")

        local isfolder = content.download_url ~= nil
        local _, _, name = content.name:find("(.-)%.lua") or isfolder and nil, nil, content.name
        if name then --// Is a .lua file or a folder
            if isfolder then
                --// Repeat new folder
                local get = content.html_url
                local childfolder = GitImport.getcontent(get, content.name)
                childfolder.Parent = contentfolder
            else
                --// Insert script directly
                local newscript = GitImport.ImportToNewSccript(content.download_url)
                newscript.Parent = contentfolder
            end
        end
    end

    return contentfolder
end

function GitImport.ImportRepository(shorturl)
    --// Import an entire repository as a folder
    local _, _, reponame = shorturl:find(".-/(.-)")
    assert(reponame, "Error importing from short URL: Please provide the URL in a Username/Repository format!")
    local get = "https://api.github.com/repos/" .. shorturl .. "/content/"
    local repofolder = getcontent(get, reponame)
    if repofolder then
        repofolder.Parent = game
        warn("Successfully imported repository " .. shorturl .. "!")
    end
end

return GitImport
