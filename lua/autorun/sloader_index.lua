sLoader = {}

local function ServerInclude(File, dir)
    if SERVER then
        include(dir..File)
        print("[SV] - " ..File)
    end
end

local function SharedInclude(File, dir)
    if SERVER then
        AddCSLuaFile(dir..File)
    end
    include(dir..File)
    print("[SH] - " ..File)
end

local function ClientInclude(File, dir)
    if SERVER then
        AddCSLuaFile(dir..File)
    end
    include(dir..File)
    print("[CL] - " ..File)
end

local actions = {
    ["cl"] = function(File, dir) ClientInclude(File, dir) end,
    ["sh"] = function(File, dir) SharedInclude(File, dir) end,
    ["sv"] = function(File, dir) ServerInclude(File, dir) end
}

local function IncludeDir(dir)
    dir = dir .. "/"
    local File, Directory = file.Find(dir.."*", "LUA")

    for k, v in ipairs(File) do
        if !string.EndsWith(v, ".lua") then error(string.format("sLoader - Unable to load a non Lua file, Aborting ! (%s)", dir..v)) end
            local file_extension = string.Left(v, 2)
            actions[file_extension](v, dir)
    end
    
    for k, v in ipairs(Directory) do
        IncludeDir(dir..v)
    end

end

function sLoader.loadPath(path)
    IncludeDir(path)
end
