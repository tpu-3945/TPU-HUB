-- TPU HUB V8 - ULTRA PUISSANT - By TPU-3945
-- Interface: Kavo UI Library (Midnight Theme)
-- Sécurité: Anti-ban avancé, Auto-Bypass, Optimisation FPS, GarbageCode random

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- UI Library
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)
if not success then return end

local Window = Library.CreateLib("TPU HUB V8 | ULTRA", "Midnight")

-- Tabs
local TabPlayer = Window:NewTab("Player")
local SectionMovement = TabPlayer:NewSection("Mouvements")

local TabCheats = Window:NewTab("Cheats")
local SectionCombat = TabCheats:NewSection("Combat")
local SectionVisual = TabCheats:NewSection("Vision")

local TabMisc = Window:NewTab("Utilitaires")
local SectionUtils = TabMisc:NewSection("Outils")
local SectionExploit = TabMisc:NewSection("Exploits")

local TabCredits = Window:NewTab("Credits")
local SectionCredits = TabCredits:NewSection("By TPU-3945")

-- WalkSpeed / JumpPower
SectionMovement:NewSlider("WalkSpeed", "Vitesse du joueur", 500, 16, function(v)
    LocalPlayer.Character.Humanoid.WalkSpeed = v
end)
SectionMovement:NewSlider("JumpPower", "Puissance de saut", 300, 50, function(v)
    LocalPlayer.Character.Humanoid.JumpPower = v
end)

-- Infinite Jump
local IJ = false
SectionMovement:NewToggle("Saut infini", "Permet de sauter en l'air", function(s)
    IJ = s
end)
UserInputService.JumpRequest:Connect(function()
    if IJ then LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState("Jumping") end
end)

-- Fly Hack
local flying = false
SectionMovement:NewToggle("Fly", "Vol dans les airs", function(state)
    flying = state
    local char = LocalPlayer.Character
    local hrp = char:WaitForChild("HumanoidRootPart")
    local bg = Instance.new("BodyGyro", hrp)
    local bv = Instance.new("BodyVelocity", hrp)
    bg.P = 9e4; bg.maxTorque = Vector3.new(9e9,9e9,9e9); bg.cframe = hrp.CFrame
    bv.velocity = Vector3.new(0,0,0); bv.maxForce = Vector3.new(9e9,9e9,9e9)
    RunService.RenderStepped:Connect(function()
        if not flying then bg:Destroy() bv:Destroy() return end
        bg.cframe = workspace.CurrentCamera.CFrame
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
        bv.velocity = dir.unit * 75
    end)
end)

-- ESP Box
SectionVisual:NewButton("ESP Box", "Montre les joueurs", function()
    loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
end)

-- ESP Avancé
SectionVisual:NewButton("ESP Avancé", "ESP couleurs et équipes", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
end)

-- Silent Aimbot
SectionCombat:NewButton("Silent Aimbot", "Visée auto silencieuse", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Main.lua"))()
end)

-- Kill Aura
SectionCombat:NewButton("KillAura", "Frappe automatique", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/9M8CNWhf"))()
end)

-- TriggerBot
SectionCombat:NewButton("TriggerBot", "Tir automatique", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/1UGD3ZSm"))()
end)

-- NoClip
SectionMovement:NewToggle("NoClip", "Traverse les murs", function(val)
    if val then
        RunService.Stepped:Connect(function()
            for _,p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
end)

-- GodMode
SectionExploit:NewButton("GodMode", "Immortalité", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/Kz2N5sHr"))()
end)

-- Auto Farm
SectionExploit:NewButton("Auto Farm", "Farm automatique", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/zFz4y82g"))()
end)

-- Auto Parry
SectionCombat:NewButton("Auto Parry", "Parade automatique", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/VqCwUGTz"))()
end)

-- Auto Quête
SectionExploit:NewButton("Auto Quête", "Accepte automatiquement", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/NKwY1mBz"))()
end)

-- Save Instance
SectionUtils:NewButton("Sauvegarder Map", "Save Instance complet", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/InfyHaxx/Universal-Save-Instance/main/main.lua"))()
end)

-- FPS Boost
SectionUtils:NewButton("Boost FPS", "Optimisation graphique", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/eC8xLJgY"))()
end)

-- Server Hop
SectionUtils:NewButton("Server Hop", "Change de serveur", function()
    local PlaceID = game.PlaceId
    local servers = game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100")
    local data = HttpService:JSONDecode(servers)
    for _,v in pairs(data.data) do
        if v.playing < v.maxPlayers then
            TeleportService:TeleportToPlaceInstance(PlaceID, v.id, LocalPlayer)
            break
        end
    end
end)

-- Anti Ban avancé
pcall(function()
    hookfunction(getfenv().pcall, function(...) return true end)
    hookfunction(getfenv().xpcall, function(...) return true end)
    setreadonly(getrawmetatable(game), false)
    local old = getrawmetatable(game).__namecall
    getrawmetatable(game).__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "Kick" then
            return nil
        end
        return old(self, unpack(args))
    end)
end)

-- Discord
SectionCredits:NewButton("Rejoindre Discord", "Copie le lien Discord", function()
    setclipboard("https://discord.gg/3aJjPpzw9b")
    print("Lien Discord copié !")
end)

-- Labels finaux
SectionCredits:NewLabel("TPU HUB V8")
SectionCredits:NewLabel("By TPU-3945")
SectionCredits:NewLabel("MADE WITH ❤️ - XENO Compatible")
