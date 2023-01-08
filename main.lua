--[[
    Very Fluffy client yes yes

    Credits to the following people:
    https://github.com/Babyhamsta - CoreGui Bypasses,
    https://github.com/7GrandDadPGN - Vape V4 but for Roblox,
    Sorry but I dont support pedos - Infinite Yield
]]


local config = { -- default/template config, dont touch it >:C
    Name = "Fluffy", -- name of hud
    Colors = { -- colors
        Background = Color3.new(1, 1, 1),
        Accent = {
            Default = Color3.new(),
            NoBackground = Color3.new(1, 1, 1)
        },
        Button = {
            Default = Color3.fromRGB(225, 225, 225),
            Faded = Color3.fromRGB(180, 180, 180)
        }
    },
    Font = Enum.Font.SourceSansLight, -- font of text
    BackgroundImage = nil, -- background image of frames
    BackgroundTransparency = .2, -- transparency of background image
    HudElement = { -- hud element values
        Position = {
            assetDownloadHeader = {
                Start = UDim2.new(0, 0, -.1, 0),
                End = UDim2.new()
            }
        }, -- Position of hud elements
        Tween = {
            assetDownloadHeader = {
                TweenType = Enum.EasingStyle.Quad,
                TweenDirection = Enum.EasingDirection.InOut,
                Time = .5
            }
        } -- Tweens of the hud elements
    }
}
local firstTimer = false

local github_repo
do
    local creator = "Lua69"
    local repo = "Fluffy"
    github_repo = "https://raw.githubusercontent.com/" .. creator .. "/" .. repo .. "/main/"
end

local getasset = getsynasset or getcustomasset or function(location) -- fetch a asset from the web!
    return "rbxasset://" .. location -- daily jjsploit user XD
end

local cloneref = cloneref or function(g) -- cloneref to pretty much hide the instances from the game, (Btw I didnt make this)
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

    function f.invalidate(g) -- gets the instances in the the object and sets them to nil
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

local writefile = writefile or function() -- Unable to writefile, pretty bad exploit man.
    return false
end

local readfile = readfile or function() -- YOU CANT EVEN READFILE? WOW MAN
    return false
end

local isfile = isfile or function(file) -- Detect if the file exists or not
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil
end

local realRobloxTask = task -- idk I think this works
local task = {} -- override it with a table
if KRNL_LOADED then -- last time I tried to use task.wait on krnl, it failed for me.
    task.delay = realRobloxTask.delay
    task.spawn = realRobloxTask.spawn
    task.wait = function(t)
        local time = t or 0.05 -- default roblox wait time is 0.05
        local tick = tick()

        repeat
            RunService.PreRender:Wait()
        until tick() - tick >= time
    end
else
    task = realRobloxTask
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

function random(min, max) -- roblox's math.random is not really random sometimes tbh
    return Random.new():NextInteger(min, max)
end

function randomString() -- generate a random long string of text
    local array = {}
    local len = random(0, 100)

    for i = 1, len, 1 do
        array[i] = string.char(math.random(1, 128))
    end

    return table.concat(array)
end

local Player = Players.LocalPlayer
local cachedassets = {}
local yield = task.wait
local rblxStudio = RunService:IsStudio()

if not isfolder("fluffy") then
    firstTimer = true
    makefolder("fluffy")
    makefolder("fluffy/assets")
    makefolder("fluffy/sounds")
end

if shared.FluffyHUD then
    error("Fluffy HUD seems to be already running!", 0)
    return
end

if rblxStudio then
    CoreGui = Player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = randomString()
gui.DisplayOrder = 9e9
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protect_gui(gui)
gui.Parent = cloneref(CoreGui)
gui.Parent = game.CoreGui
gui.OnTopOfCoreBlur = true
shared.FluffyHUD = gui

function fetchModule(module)
    return loadstring(requestfunc({
        Url = github_repo .. "modules/" .. module .. ".lua",
        Method = "GET"
    }).Body)
end

local scaleUI = fetchModule("AutoScaleLibrary")

function PropertyExists(obj, prop)
	return ({pcall(function()if(typeof(obj[prop])=="Instance")then error()end end)})[1]
end

function fetchAsset(path)
    if not isfile(path) then    
        task.spawn(function()
            local position, tween = config.HudElement.Position.assetDownloadHeader, config.HudElement.Tween.assetDownloadHeader

            local txt = Instance.new("TextLabel", gui)
            txt.Size = UDim2.new(1, 0, 0.1, 0)
            txt.Position = position.Start
            txt.Text = "Downloading " .. path
            txt.BackgroundTransparency = 1
            txt.TextScaled = true
            txt.Font = config.Font
            txt.TextColor3 = config.Colors.Accent.NoBackground

            TweenService:Create(txt, TweenInfo.new(tween.Time, tween.TweenType, tween.TweenDirection), {Position = position.End}):Play()

            repeat
                yield()
            until isfile(path)

            txt:Destroy()
        end)
        local req = requestfunc({
            Url = github_repo .. path:gsub("fluffy/", ""),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if not cachedassets[path] then
        cachedassets[path] = getasset(path)
    end
    return cachedassets[path]
end

function recalibrateGUIObject(obj)
    scaleUI.SetSize(obj, "Scale")
    scaleUI.SetPosition(obj, "Scale")
    scaleUI.ScaleText(obj)
end

function createHUDElement() -- creates a hud element
    local img = Instance.new("ImageLabel", gui)
    img.Name = randomString()
    img.BackgroundTransparency = 1
    img.AnchorPoint = Vector2.new(.5, .5)
    img.ImageTransparency = config.BackgroundTransparency

    if config.BackgroundImage then
        img.Image = config.BackgroundImage
    else
        img.Image = fetchAsset("fluffy/assets/WindowBlur.png")
        img.ScaleType = Enum.ScaleType.Slice
        img.SliceCenter = Rect.new(10, 10, 10, 10)
    end

    return img
end

local coreGuiNames = {
    "TeleportGui",
    "RobloxPromptGui",
    "RobloxNetworkPauseNotification",
    "DevConsoleMaster",
    "InGameFullscreenTitleBarScreen",
    "ThemeProvider",
    "PlayerList",
    "PurchasePrompt",
    "HeadsetDisconnectedDialog",
    "TeleportEffectGui",
    "AvatarEditorPrompts"
}

if rblxStudio then
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
else
    for _, obj in next, CoreGui:GetChildren() do
        for _, name in next, coreGuiNames do
            if obj.Name == name then
                obj.Enabled = false
            end
        end
    end
end

-- coregui bypasses
if not rblxStudio then
    fetchModule("Bypasses")()
end

local leaderstats = createHUDElement()
leaderstats.Size = UDim2.new(.1, 0, .4, 0)
leaderstats.Position = UDim2.new(.925, 0, .2, 0)
recalibrateGUIObject(leaderstats)