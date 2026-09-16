--[[
    Steal an Egg - Ultimate Admin Panel Bypass v5.0.0
    COMPREHENSIVE EDITION - All Features Combined
    Author: Nyx
    Target: Steal an Egg (Roblox)
    
    Features:
    - Multi-layer metamethod hooks (__namecall, __index, __newindex)
    - Remote auto-detection and direct hooking
    - Continuous UI repair system
    - Anti-tamper hook monitor
    - Custom toast notifications
    - Player stats spoofing
    - Auto-execute admin commands
    - Connection monitoring
]]

-- ═══════════════════════════════════════════
-- INITIALIZATION
-- ═══════════════════════════════════════════

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local DEBUG = true
local TAG = "[Nyx-v5]"

local function log(msg)
    if DEBUG then print(TAG .. " " .. msg) end
end

log("Initializing Ultimate Bypass v5.0.0...")

-- ═══════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════

local function notify(title, message, color)
    pcall(function()
        local gui = Instance.new("ScreenGui")
        gui.Name = "NyxNotif_" .. math.random(1000,9999)
        gui.ResetOnSpawn = false
        gui.Parent = PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 300, 0, 80)
        frame.Position = UDim2.new(1, -320, 0, 20)
        frame.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
        frame.BorderSizePixel = 0
        frame.Parent = gui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame
        
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -20, 0, 30)
        titleLbl.Position = UDim2.new(0, 10, 0, 5)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = title
        titleLbl.TextColor3 = Color3.fromRGB(255,255,255)
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = 16
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.Parent = frame
        
        local msgLbl = Instance.new("TextLabel")
        msgLbl.Size = UDim2.new(1, -20, 0, 40)
        msgLbl.Position = UDim2.new(0, 10, 0, 35)
        msgLbl.BackgroundTransparency = 1
        msgLbl.Text = message
        msgLbl.TextColor3 = Color3.fromRGB(200,200,200)
        msgLbl.Font = Enum.Font.Gotham
        msgLbl.TextSize = 13
        msgLbl.TextXAlignment = Enum.TextXAlignment.Left
        msgLbl.TextWrapped = true
        msgLbl.Parent = frame
        
        TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -320, 0, 20)}):Play()
        task.delay(4, function()
            TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 10, 0, 20)}):Play()
            task.wait(0.6)
            gui:Destroy()
        end)
    end)
end

-- ═══════════════════════════════════════════
-- METAMETHOD HOOKS (CORE BYPASS)
-- ═══════════════════════════════════════════

-- 1. __namecall hook
local old_namecall
old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    if not checkcaller() and self and typeof(self) == "Instance" then
        local method = getnamecallmethod()
        
        if method == "InvokeServer" then
            local remoteName = self.Name or ""
            local lowerName = remoteName:lower()
            
            local keywords = {
                "request", "unlock", "enable", "check", "auth", "perm",
                "verify", "admin", "creator", "panel", "feature", "access",
                "validate", "license", "key", "token", "session", "role",
                "staff", "mod", "owner", "dev", "command", "tool",
                "camera", "hide", "spawn", "teleport", "give", "set",
                "manage", "server", "scene", "collection", "character"
            }
            
            local isTarget = false
            for _, kw in ipairs(keywords) do
                if lowerName:find(kw) then
                    isTarget = true
                    break
                end
            end
            
            if isTarget then
                log("Intercepted: " .. remoteName)
                return {
                    Ok = true, Success = true, Allowed = true,
                    HasAccess = true, IsAdmin = true, IsCreator = true,
                    IsStaff = true, IsOwner = true, Level = 999,
                    Unlocked = true, Access = true, Reserved = true,
                    State = {
                        Admin = true, Creator = true, Staff = true,
                        Owner = true, Access = true, Reserved = true,
                        Level = 999,
                        Permissions = {"all", "admin", "creator", "staff", "owner", "full_access"},
                        Commands = {
                            free_camera = true, hide_ui = true, hide_nameplates = true,
                            character = true, collection = true, scene = true,
                            servers = true, manage = true, spawn = true,
                            teleport = true, give_item = true, set_money = true,
                            admin_panel = true, unlock_all = true, fly = true,
                            noclip = true, speed = true, god_mode = true
                        },
                        Players = {}, Active = {}, Servers = {}, TargetActive = {},
                        Data = { Admin = true, Creator = true, Unlocked = true, Bypassed = true }
                    }
                }
            end
        end
        
        if method == "FireServer" then
            local remoteName = self.Name or ""
            local lowerName = remoteName:lower()
            local blockKw = {"validate", "verify", "check", "auth", "heartbeat", "anti", "detect", "scan", "report", "kick", "ban"}
            for _, kw in ipairs(blockKw) do
                if lowerName:find(kw) then
                    log("Blocked: " .. remoteName)
                    return nil
                end
            end
        end
    end
    return old_namecall(self, ...)
end))

log("__namecall hook installed")

-- 2. __index hook
local old_index
old_index = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not checkcaller() and self and typeof(self) == "Instance" then
        if (key == "Active" or key == "Selectable") and self:IsA("GuiButton") then
            return true
        end
        if key == "Visible" and self:IsA("GuiObject") then
            return true
        end
        if key == "Admin" or key == "IsAdmin" or key == "HasAccess" then
            return true
        end
    end
    return old_index(self, key)
end))

log("__index hook installed")

-- 3. __newindex hook
local old_newindex
old_newindex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
    if not checkcaller() and self and typeof(self) == "Instance" then
        if (key == "Active" or key == "Selectable") and self:IsA("GuiButton") and value == false then
            return
        end
        if key == "Visible" and self:IsA("GuiObject") and value == false then
            return
        end
        if (key == "Locked" or key == "IsLocked") and value == true then
            return
        end
    end
    return old_newindex(self, key, value)
end))

log("__newindex hook installed")

-- ═══════════════════════════════════════════
-- GUI REPAIR SYSTEM
-- ═══════════════════════════════════════════

local function fixGUI()
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            gui.Enabled = true
            gui.ResetOnSpawn = false
            gui.IgnoreGuiInset = true
            
            for _, obj in ipairs(gui:GetDescendants()) do
                if obj:IsA("TextLabel") then
                    local text = obj.Text:lower()
                    if text:find("locked") or text:find("admin only") or text:find("no access") then
                        obj.Text = "UNLOCKED"
                        obj.TextColor3 = Color3.fromRGB(0, 255, 0)
                        obj.BackgroundTransparency = 1
                    end
                end
                
                if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                    obj.Selectable = true
                    obj.Active = true
                    obj.Visible = true
                    obj.ZIndex = math.max(obj.ZIndex, 10)
                    obj.AutoButtonColor = true
                    
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text:lower():find("locked") then
                            child:Destroy()
                        end
                        if child:IsA("Frame") and child.BackgroundTransparency < 0.8 then
                            child.BackgroundTransparency = 1
                        end
                    end
                end
                
                if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
                    obj.Visible = true
                    obj.ZIndex = math.max(obj.ZIndex, 5)
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("TextLabel") and child.Text:lower():find("locked") then
                            child:Destroy()
                        end
                    end
                end
                
                if obj:IsA("ImageLabel") then
                    local imgId = obj.Image:lower()
                    if imgId:find("lock") or imgId:find("padlock") then
                        obj.Visible = false
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    pcall(fixGUI)
end)

task.wait(2)
fixGUI()
notify("Nyx Bypass", "Admin Panel Unlocked & UI Fixed", Color3.fromRGB(0, 150, 0))
log("GUI repair system active")

-- ═══════════════════════════════════════════
-- REMOTE SCANNER & DIRECT HOOK
-- ═══════════════════════════════════════════

local function scanAndHookRemotes()
    local function scanContainer(container)
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("RemoteFunction") then
                local name = obj.Name:lower()
                local keywords = {"admin", "creator", "panel", "auth", "perm", "check", "verify", "request", "unlock", "enable", "access"}
                local isTarget = false
                for _, kw in ipairs(keywords) do
                    if name:find(kw) then isTarget = true break end
                end
                
                if isTarget then
                    pcall(function()
                        local oldInvoke = obj.InvokeServer
                        hookfunction(obj.InvokeServer, newcclosure(function(...)
                            if not checkcaller() then
                                return {Ok=true, Success=true, Allowed=true, HasAccess=true, IsAdmin=true, Level=999, Unlocked=true}
                            end
                            return oldInvoke(...)
                        end))
                        log("Direct hooked: " .. obj.Name)
                    end)
                end
            end
        end
    end
    pcall(function() scanContainer(ReplicatedStorage) end)
    pcall(function() scanContainer(game:GetService("Workspace")) end)
end

task.wait(3)
scanAndHookRemotes()
task.spawn(function()
    while task.wait(10) do pcall(scanAndHookRemotes) end
end)

log("Remote scanner active")

-- ═══════════════════════════════════════════
-- PLAYER STATS SPOOFING
-- ═══════════════════════════════════════════

local function spoofStats()
    pcall(function()
        local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
        if leaderstats then
            for _, stat in ipairs(leaderstats:GetChildren()) do
                if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                    stat.Value = 999999999
                elseif stat:IsA("StringValue") then
                    stat.Value = "ADMIN"
                end
            end
        end
        
        for _, obj in ipairs(LocalPlayer:GetDescendants()) do
            if obj:IsA("BoolValue") and (obj.Name:lower():find("admin") or obj.Name:lower():find("access")) then
                obj.Value = true
            end
            if obj:IsA("IntValue") and obj.Name:lower():find("level") then
                obj.Value = 999
            end
        end
    end)
end

task.wait(5)
spoofStats()
task.spawn(function()
    while task.wait(5) do pcall(spoofStats) end
end)

log("Stats spoofing active")

-- ═══════════════════════════════════════════
-- AUTO-EXECUTE ADMIN COMMANDS
-- ══════════════════════════════════════════

local function tryAdminCommands()
    pcall(function()
        local commonRemotes = {
            "Request", "AdminRequest", "CreatorRequest",
            "CheckAdmin", "VerifyAdmin", "GetPermissions",
            "UnlockPanel", "EnableAdmin", "ActivateAdmin"
        }
        
        for _, remoteName in ipairs(commonRemotes) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
            if remote and remote:IsA("RemoteFunction") then
                pcall(function()
                    local result = remote:InvokeServer()
                    log("Invoked " .. remoteName .. ": " .. tostring(result))
                end)
            end
        end
    end)
end

task.wait(7)
tryAdminCommands()

-- ══════════════════════════════════════════
-- HOOK MONITOR (ANTI-TAMPER)
-- ═══════════════════════════════════════════

task.spawn(function()
    while task.wait(15) do
        pcall(function()
            local mt = getrawmetatable(game)
            if mt and mt.__namecall ~= old_namecall then
                log("Hook tampered. Re-applying...")
                old_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                    if not checkcaller() and self then
                        local m = getnamecallmethod()
                        if m == "InvokeServer" then
                            return {Ok=true, Success=true, Allowed=true, HasAccess=true, IsAdmin=true, Level=999}
                        end
                    end
                    return old_namecall(self, ...)
                end))
                notify("Nyx Bypass", "Hook Re-applied Successfully", Color3.fromRGB(255, 165, 0))
            end
        end)
    end
end)

-- ═══════════════════════════════════════════
-- FINAL STATUS
-- ═══════════════════════════════════════════

log("═══════════════════════════════════════")
log("Ultimate Admin Panel Bypass v5.0.0")
log("═══════════════════════════════════════")
log("Status: ACTIVE")
log("Hooks: __namecall, __index, __newindex")
log("GUI Repair: RenderStepped loop")
log("Remote Scanner: Active (10s interval)")
log("Stats Spoofing: Active (5s interval)")
log("Hook Monitor: Active (15s interval)")
log("═══════════════════════════════════════")
log("Panel should be fully accessible now.")
log("If features still locked, execute again.")
log("═══════════════════════════════════════")

notify("Nyx v5.0.0", "All Systems Active - Panel Unlocked", Color3.fromRGB(0, 200, 0))

return true
