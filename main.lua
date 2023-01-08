--[[
    Very Fluffy client yes yes

    Credits to the following people:
    https://github.com/Babyhamsta - CoreGui Bypasses,
    https://github.com/7GrandDadPGN - Vape V4 but for Roblox,
    Sorry but I dont support pedos - Infinite Yield
]]

local config = { -- default config, dont touch it boi
    Name = "Fluffy", -- name of hud
    Colors = { -- colors
        Background = Color3.fromRGB(255, 255, 255), -- background color of frames
        AccentColor = Color3.fromRGB() -- text, button, etc. color
    },
    FontType = Enum.Font.SourceSansLight, -- font of text
    BackgroundImage = nil, -- Background image of frames
    BackgroundTransparency = .2, -- Transparency of background image
    HudElementPositions = {}, -- Position of the hud elements
    HudElementTweenTypes = {} -- Tweens of the hud elements
}


local getasset = getsynasset or getcustomasset or function(location) -- fetch a asset from the web!
    return "rbxasset://" .. location -- daily jjsploit user XD
end
local cloneref = cloneref or function(g) -- cloneref to pretty much hide the instances from the game
    if RunService:IsStudio() then
        g.Parent = CoreGui
    end

    local a = Instance.new("Flag")
    local InstanceList

    for b, c in pairs(getreg()) do
        if type(c) == "table" and #c then
            if rawget(c, "__mode") == "kvs" then
                for d, e in pairs(c) do
                    if e == a then
                        InstanceList = c;
                        break
                    end
                end
            end
        end
    end

    local f = {}

    function f.invalidate(g)
        if not InstanceList then
            return
        end
        for b, c in pairs(InstanceList) do
            if c == g then
                InstanceList[b] = nil;
                return g
            end
        end
    end

    return f.invalidate(g)
end
local protect_gui = syn.protect_gui or function(obj) -- Protect gui if your a synapse user
    obj.Parent = CoreGui
end
local requestfunc =
    syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or
        function(tab) -- http request
            if tab.Method == "GET" then
                return {
                    Body = game:HttpGet(tab.Url, true),
                    Headers = {},
                    StatusCode = 200
                }
            else
                return {
                    Body = "Bro fr stop using jjsploit",
                    Headers = {},
                    StatusCode = 404
                }
            end
        end
local isfile = isfile or function(file) -- Detect if the file exists or not
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil
end
local writefile = writefile or function() -- Unable to writefile, pretty bad exploit man.
    return
end
local readfile = readfile or function() -- YOU CANT EVEN READFILE? WOW MAN
    return
end

loadstring(requestfunc({
    Url = "https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/Bypasses.lua",
    Method = "GET"
}).Body)()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local cachedassets = {}

local math = {
    random = function(min, max) -- roblox's math.random is not really random sometimes tbh
        return Random.new():NextInteger(min, max)
    end
}

function randomString(len) -- generate a random long string of text
    local array = {}

    for i = 1, len, 1 do
        array[i] = string.char(math.random(1, 128))
    end

    return table.concat(array)
end

if shared.FluffyHUD then
    error("Fluffy HUD seems to be already running!", 0)
    return
end

if RunService:IsStudio() then
    CoreGui = Player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = randomString(math.random(0, 100))
gui.DisplayOrder = 9e9
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
protect_gui(gui)
gui.Parent = cloneref(CoreGui)
gui.OnTopOfCoreBlur = true
shared.FluffyHUD = gui

function fetchasset(path)
    if not isfile(path) then
        task.spawn(function()
            local textlabel = Instance.new("TextLabel")
            textlabel.Size = UDim2.new(1, 0, 0.1, 0)
            textlabel.Text = "Downloading " .. path
            textlabel.BackgroundTransparency = 1
            textlabel.TextScaled = true
            textlabel.Font = config.Font
            textlabel.TextColor3 = config.Colors.AccentColor
            textlabel.Position = UDim2.new(0, 0, 0, -36)
            textlabel.Parent = gui

            repeat task.wait() until betterisfile(path)

            textlabel:Remove()
        end)
        local req = requestfunc({
            Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if cachedassets[path] == nil then
        cachedassets[path] = getasset(path) 
    end
    return cachedassets[path]
end

function createHUDElement(tbl) -- creates a hud element
    local img = Instance.new("ImageLabel", tbl.Parent)
    img.BackgroundTransparency = 1
    img.AnchorPoint = Vector2.new(.5, .5)
    img.ImageTransparency = config.BackgroundTransparency

    if config.BackgroundImage then
        img.Image = config.BackgroundImage
    else
        img.Image = 
    end

    return img
end