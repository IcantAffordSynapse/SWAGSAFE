rconsolecreate()
rconsoleclear()
rconsoleinfo([[
╭╴╭─╮╷ ╷╭─╮╭─╴╭─╮╭─╮╭─╴╭─╴╶╮
│ ╰─╮│╷│├─┤│╶╮╰─╮├─┤├╴ ├╴  │
╰╴╰─╯╰┴╯╵ ╵╰─╯╰─╯╵ ╵╵  ╰─╴╶╯

]])
rconsoleprint("Loading..")

local tweenService = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local httpservice = game:GetService("HttpService")
local players = game:GetService("Players")

local plr = players.LocalPlayer

local uiid = "rbxassetid://90075992800735"
local elementsid = "rbxassetid://76876137339934"

local requiredFuncs = {
    "getrawmetatable",
    "getcustomasset",
    "hookmetamethod",
    "setreadonly",
    "isfile",
    "identifyexecutor"
}
local unsupportedFuncs = {}

local hasAllFuncs = true
for _, f in ipairs(requiredFuncs) do
    if type(getfenv()[f]) ~= "function" then
        hasAllFuncs = false
        table.insert(unsupportedFuncs, f)
    end
end

if identifyexecutor():lower() == "xeno" then
    hasAllFuncs = false
    table.insert(unsupportedFuncs, "getcustomasset")
end

local supportedIds = {
    ["MM2"] = 142823291,
    ["GAG2"] = 97598239454123,
    ["AM"] = 920587237,
    ["PS99"] = 8737899170
}

local realJobId = game.JobId
local realUserId = players.LocalPlayer.UserId
local realUsername = players.LocalPlayer.Name

local settings = {
    DetailedLogs = false,
    Disconnect = true,
    JobId = realJobId,
    UserId = realUserId,
    Username = realUsername
}

---
-- WEAO Vars
---
local endpoint = "https://weao.xyz/api/status/exploits/"
local executorsToShow = {
    ["volt"] = "https://cdn.weao.gg/slug/volt/logo.png",
    ["madium"] = "https://files.catbox.moe/59gwaf.png",
    ["velocity"] = "https://cdn.weao.gg/slug/velocity/logo.png"
}

if not isfolder("SwagSafe") then makefolder("SwagSafe") end

rconsoleprint("Grabbing UI Elements..")

local mainUI = game:GetObjects(uiid)[1]
local elementsObjects = game:GetObjects(elementsid)[1]
local introWarning = mainUI.introwarning
local mainframe = mainUI.mainwindow

local btns = mainframe.topbar.btns
local closeBtn = btns.closebtn
local miniBtn = btns.minibtn

mainframe.GroupTransparency = 1
mainframe.Interactable = false
mainframe.Size = UDim2.new(0.456, 0, 0.608, 0)
mainframe.UIStroke.Transparency = 1

local inoutInfo = TweenInfo.new(
    0.25,
    Enum.EasingStyle.Quad,
    Enum.EasingDirection.Out
)

rconsoleprint("Setting up Intro UI")
---
-- Intro UI
---
introWarning.continuebtn.MouseButton1Click:Connect(function()
    introWarning:TweenSize(UDim2.new(0.304, 0, 0.424, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad)
    tweenService:Create(
        introWarning,
        inoutInfo,
        {
            GroupTransparency = 1
        }
    ):Play()
    tweenService:Create(
        introWarning.UIStroke,
        inoutInfo,
        {
            Transparency = 1
        }
    ):Play()
    introWarning.Interactable = false

    mainframe:TweenSize(UDim2.new(0.476, 0, 0.608, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad)
    tweenService:Create(
        mainframe,
        inoutInfo,
        {
            GroupTransparency = 0
        }
    ):Play()
    tweenService:Create(
        mainframe.UIStroke,
        inoutInfo,
        {
            Transparency = 0.71
        }
    ):Play()
    mainframe.Interactable = true
end)

rconsoleprint("Setting up Mainframe UI")
---
-- Mainframe UI
---
local dragging = false
local dragInput, mousePos, framePos

mainframe.topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = mainframe.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainframe.topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

uis.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        mainframe.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

local function tweenTopBtn(which, isIn)
    tweenService:Create(
        which,
        TweenInfo.new(0.05),
        {
            BackgroundTransparency = isIn and 0.25 or 1
        }
    ):Play()
end

closeBtn.MouseEnter:Connect(function() tweenTopBtn(closeBtn, true) end)
miniBtn.MouseEnter:Connect(function() tweenTopBtn(miniBtn, true) end)
closeBtn.MouseLeave:Connect(function() tweenTopBtn(closeBtn, false) end)
miniBtn.MouseLeave:Connect(function() tweenTopBtn(miniBtn, false) end)

---
-- Elements Handler
---
rconsoleprint("Getting Elements module..")
local elementsModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/IcantAffordSynapse/SWAGSAFE/refs/heads/main/stuff/elements.lua"))()
local elements = elementsModule:load(elementsObjects, mainframe)

local settingsect = elements:Section("Settings", "rbxassetid://88225959356315")
local executorsect = elements:Section("Executors", "rbxassetid://136054589554766")

---
-- Listing Support
---
if hasAllFuncs then
    elements:AddLog(identifyexecutor() .. " is fully supported!", Color3.fromRGB(0, 255, 0))
else
    elements:AddLog(identifyexecutor() .. " is NOT supported! Things won't work.", Color3.fromRGB(255, 0, 0))
    for i, v in pairs(unsupportedFuncs) do
        elements:AddLog("   > " .. v, Color3.fromRGB(255, 0, 0))
    end
end

---
-- Settings Handler
---
rconsoleprint("Setting up Settings..")
settingsect:Label("Universal Safety")

settingsect:Toggle("Randomized Job ID", true, function(v)
    local new1 = v and httpservice:GenerateGUID(false) or realJobId
    settings.JobId = new1
    elements:AddLog("Set Job ID: " .. new1, Color3.fromRGB(255, 255, 0))
end)
settingsect:Toggle("Randomized UserIds", false, function(v)
    local new1 = v and Random.new():NextInteger(1000, 5199585634) or realUserId
    settings.UserId = new1
    elements:AddLog("Set User IDs to: " .. new1, Color3.fromRGB(255, 255, 0))
end)
settingsect:Toggle("Randomized Usernames", false, function(v)
    local new1 = v and httpservice:GenerateGUID(false) or realUsername
    settings.Username = new1
    elements:AddLog("Set Usernames to: " .. new1, Color3.fromRGB(255, 255, 0))
end)

settingsect:Label("On Detection")

settingsect:Toggle("Disconnect", settings.Disconnect, function(v)
    settings.Disconnect = v
end)

settingsect:Label("Logs")

settingsect:Toggle("Detailed Logs", settings.DetailedLogs, function(v)
    settings.DetailedLogs = v
end)

---
-- Executors Handler
---
rconsoleprint("Setting up Executor list..")
for execName, execImg in pairs(executorsToShow) do
    rconsoleprint("    > Grabbing details for " .. execName)
    local weaoDetails = httpservice:JSONDecode(game:HttpGet("https://weao.xyz/api/status/exploits/" .. execName))
    if not isfile("SwagSafe/"..execName..".png") then
        rconsoleprint("    > Downloading icon for " .. execName)
        writefile("SwagSafe/"..execName..".png", game:HttpGet(execImg))
    end

    task.wait()

    print(isfile("SwagSafe/"..execName..".png"))

    local execDetails = {
        img = getcustomasset("SwagSafe/"..execName..".png"),
        title = execName,
        working = weaoDetails.updateStatus,
        device = weaoDetails.platform,
        sunc = tostring(weaoDetails.suncPercentage) .. " sUNC" or "unknown sUNC",
        price = weaoDetails.free and "Free" or weaoDetails.cost
    }

    for i, v in pairs(execDetails) do
        print(i, v)
    end

    executorsect:Executor(execDetails, function()
        setclipboard(weaoDetails.websitelink)
        elements:AddLog("Copied: " .. weaoDetails.websitelink .. ", to Clipboard!", Color3.fromRGB(0, 255, 0))
    end)
end

-- Closing/Minimize logic
closeBtn.MouseButton1Click:Connect(function()
    mainUI:Destroy()
end)

rconsoleprint("Parenting UI..")
local hui = gethui or get_hidden_gui
if hui then
    mainUI.Parent = hui()
else
    mainUI.Parent = game:GetService("CoreGui")
end

---
-- Universal Protection
---
rconsoleprint("Setting up Job ID Spoofer..")
local oldIndex
oldIndex = hookmetamethod(game, "__index", function(self, key)
    local caller = checkcaller()

    if self == game and key == "JobId" then
        elements:AddLog("Job ID access detected, returning: " .. settings.JobId, Color3.fromRGB(0, 255, 0))
        return settings.JobId
    end
    if caller then
        if self == plr then
            if key == "UserId" then
                elements:AddLog("User ID access detected, returning: " .. settings.UserId, Color3.fromRGB(0, 255, 0))
                return settings.UserId
            elseif key == "Name" then
                elements:AddLog("Username access detected, returning: " .. settings.Username, Color3.fromRGB(0, 255, 0))
                return settings.Username
            end
        end
    end
    
    return oldIndex(self, key)
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()

    if self == game and (method == "HttpGet" or method == "HttpGetAsync") then
        local args = {...}
        local url = tostring(args[1])

        if url:lower():find("project%-reverse") then
            elements:AddLog("Attempt to run a known malicious service, Blocked.", Color3.fromRGB(255, 0, 0))
            elements:AddLog("   > " .. url, Color3.fromRGB(255, 255, 0))

            return nil
        end
    end

    return oldNamecall(self, ...)
end)

---
-- Game Protection
---
rconsoleprint("Checking Game..")
elements:AddLog("SwagSafe v0.01 BETA", Color3.fromRGB(0, 255, 255))
if game.PlaceId == supportedIds["MM2"] then
    rconsoleprint("Setting up MM2..")
    local sendRequestEvent = game:GetService("ReplicatedStorage").Trade.SendRequest
    local acceptRequestEvent = game:GetService("ReplicatedStorage").Trade.AcceptRequest

    local mt = getrawmetatable(game)
    local nc = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        if self == sendRequestEvent or self == acceptRequestEvent then
            local args = {...}
            local old = getthreadidentity()
            local caller = checkcaller()

            pcall(function()
                setthreadidentity(8)
                elements:AddLog("BLOCKED: " .. self.Name, Color3.fromRGB(0, 255, 0))
                if settings.DetailedLogs then
                    for i, arg in ipairs(args) do
                        elements:AddLog("   > ARG: " .. tostring(arg), Color3.fromRGB(0, 255, 0))
                    end
                    elements:AddLog("   > VIA EXECUTOR: " .. tostring(caller), Color3.fromRGB(0, 255, 0))
                end
                if settings.Disconnect then
                    game:Shutdown()
                end
                setthreadidentity(old)
            end)

            return nil
        end

        return nc(self, ...) -- murpy woz here 2026
        --murpy can confirm this, 2026
    end

    setreadonly(mt, true)
elseif game.PlaceId == supportedIds["GAG2"] then
    rconsoleprint("Setting up GAG2..")
    local MainEvent = game:GetService("ReplicatedStorage").SharedModules.Packet.RemoteEvent

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall

    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        if self == MainEvent then
            local packet = select(1, ...)
            local old = getthreadidentity()

            if typeof(packet) == "buffer" and buffer.len(packet) >= 1 then
                local packetId = buffer.readu8(packet, 0)

                if packetId == 0xF6 then
                    local caller = checkcaller()
                    local args = settings.DetailedLogs and table.pack(...) or nil

                    pcall(function()
                        setthreadidentity(8)
                        elements:AddLog("BLOCKED: " .. self.Name, Color3.fromRGB(0, 255, 0))
                        if settings.DetailedLogs and args then
                            for i = 1, args.n do
                                elements:AddLog("   > ARG: " .. tostring(args[i]), Color3.fromRGB(0, 255, 0))
                            end
                            elements:AddLog("   > VIA EXECUTOR: " .. tostring(caller), Color3.fromRGB(0, 255, 0))
                        end
                        if settings.Disconnect then
                            game:Shutdown()
                        end
                        setthreadidentity(old)
                    end)
                    return nil
                end
            end
        end

        return oldNamecall(self, ...)
    end

    setreadonly(mt, true)
elseif game.PlaceId == supportedIds["AM"] then
    rconsoleprint("Setting up Adopt me..")
    local acceptDecline = game:GetService("ReplicatedStorage").API["TradeAPI/AcceptOrDeclineTradeRequest"]
    local acceptNego = game:GetService("ReplicatedStorage").API["TradeAPI/AcceptNegotiation"]
    local confirmTrade = game:GetService("ReplicatedStorage").API["TradeAPI/ConfirmTrade"]
    local giftPlayer = game:GetService("ReplicatedStorage").API["TradeAPI/GiveItem"]
    local startTrade = game:GetService("ReplicatedStorage").API["TradeAPI/SendTradeRequest"]

    local mt = getrawmetatable(game)
    local nc = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        if self == acceptDecline
        or self == acceptNego
        or self == confirmTrade
        or self == giftPlayer
        or self == startTrade then
            local args = {...}
            local old = getthreadidentity()
            local caller = checkcaller()

            pcall(function()
                setthreadidentity(8)
                elements:AddLog("BLOCKED: " .. self.Name, Color3.fromRGB(0, 255, 0))
                if settings.DetailedLogs then
                    for i, arg in ipairs(args) do
                        elements:AddLog("   > ARG: " .. tostring(arg), Color3.fromRGB(0, 255, 0))
                    end
                    elements:AddLog("   > VIA EXECUTOR: " .. tostring(caller), Color3.fromRGB(0, 255, 0))
                end
                if settings.Disconnect then
                    game:Shutdown()
                end
                setthreadidentity(old)
            end)

            return nil
        end

        return nc(self, ...)
    end

    setreadonly(mt, true)
elseif game.PlaceId == supportedIds["PS99"] then
    rconsoleprint("Setting up ps99..")
    local acceptDecline = game:GetService("ReplicatedStorage").Network["Server: Trading: Request"]

    local mt = getrawmetatable(game)
    local nc = mt.__namecall
    setreadonly(mt, false)

    mt.__namecall = function(self, ...)
        if self == acceptDecline then
            local args = {...}
            local old = getthreadidentity()
            local caller = checkcaller()

            pcall(function()
                setthreadidentity(8)
                elements:AddLog("BLOCKED: " .. self.Name, Color3.fromRGB(0, 255, 0))
                if settings.DetailedLogs then
                    for i, arg in ipairs(args) do
                        elements:AddLog("   > ARG: " .. tostring(arg), Color3.fromRGB(0, 255, 0))
                    end
                    elements:AddLog("   > VIA EXECUTOR: " .. tostring(caller), Color3.fromRGB(0, 255, 0))
                end
                if settings.Disconnect then
                    game:Shutdown()
                end
                setthreadidentity(old)
            end)

            return nil
        end

        return nc(self, ...)
    end

    setreadonly(mt, true)
end

rconsoleprint("Complete! Enjoy.")
rconsoleclear()
rconsoledestroy()
