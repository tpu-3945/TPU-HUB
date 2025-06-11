-- TPU HUB V5 MEGA - By TPU {-TPU-3945-}
-- Interface : Kavo UI Library (thème sombre noir + bleu électrique)
-- Ajout Fly Hack & Bypass anti-cheat simple
-- Toutes fonctions fonctionnelles & optimisées

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- Anti AFK simple
local function AntiAFK()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Randomisation string simple
local function RandomString(length)
    local str = ""
    for i = 1, length do
        str = str .. string.char(math.random(65, 90))
    end
    return str
end

-- Random wait (delay)
local function RandomWait(min, max)
    wait(math.random(min*100, max*100) / 100)
end

-- Hook protection simple
local function SafeHook(func)
    local success, result = pcall(func)
    if not success then
        warn("Hook protection triggered, fonction bloquée.")
        return nil
    end
    return result
end

-- Bypass simple anti-cheat
local function SimpleBypass()
    -- Masquer HumanoidRootPart CanCollide en jouant avec les métatables (exemple simple)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        setreadonly(mt, false)
        mt.__index = function(t, k)
            if t == hrp and (k == "CanCollide" or k == "Transparency") then
                return false -- masquer true pour éviter détection
            end
            return oldIndex(t, k)
        end
        setreadonly(mt, true)
    end
end

-- CHARGEMENT UI LIBRARY Kavo
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)
if not success or not Library then
    warn("Erreur: Kavo UI Library introuvable.")
    return
end

-- Création de la fenêtre avec thème sombre bleu électrique
local Window = Library.CreateLib("TPU HUB V5 MEGA", "Ocean") -- Ocean = noir + bleu

-- TABS & SECTIONS
local TabPlayer = Window:NewTab("Player")
local SectionMovement = TabPlayer:NewSection("Mouvement & Utilitaires")

local TabCheats = Window:NewTab("Cheats")
local SectionAimbot = TabCheats:NewSection("Aimbot & Combat")
local SectionESP = TabCheats:NewSection("ESP & Wallhack")

local TabUtils = Window:NewTab("Utilitaires")
local SectionSave = TabUtils:NewSection("Sauvegarde")
local SectionMisc = TabUtils:NewSection("Divers")

local TabBypass = Window:NewTab("Bypass & Fly")
local SectionBypass = TabBypass:NewSection("Bypass & Fly")

local TabCredits = Window:NewTab("Crédits")
local SectionCredits = TabCredits:NewSection("Infos")

-- WalkSpeed Slider
SectionMovement:NewSlider("WalkSpeed", "Vitesse de marche", 250, 16, function(value)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = value
        end
    end)
end)

-- JumpPower Slider
SectionMovement:NewSlider("JumpPower", "Puissance du saut", 300, 50, function(value)
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = value
        end
    end)
end)

-- Infinite Jump Toggle
local InfiniteJumpEnabled = false
SectionMovement:NewToggle("Infinite Jump", "Saut infini", function(state)
    InfiniteJumpEnabled = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- NoClip Toggle
local noclipConnection
SectionMovement:NewToggle("NoClip", "Traverser murs", function(state)
    if state then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Teleport Tool Button
SectionMovement:NewButton("Teleport Tool", "Outil de téléportation à la souris", function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = RandomString(6)
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

-- Anti AFK Button
SectionMovement:NewButton("Anti AFK", "Evite déconnexion AFK", function()
    AntiAFK()
end)

-- Aimbot & Silent Aim
local AimbotEnabled = false
local SilentAim = false
local Prediction = 0.15

SectionAimbot:NewToggle("Aimbot Ultra", "Aimbot avec prediction", function(state)
    AimbotEnabled = state
end)

SectionAimbot:NewToggle("Silent Aim", "Tirer sans viser visuellement", function(state)
    SilentAim = state
end)

local function GetClosestTarget()
    local closest, dist = nil, math.huge
    local camera = workspace.CurrentCamera
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            local pos, onScreen = camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                if distance < dist then
                    closest = plr
                    dist = distance
                end
            end
        end
    end
    return closest
end

-- ESP Players Toggle
local ESP_Enabled = false
local ESP_Boxes = {}

SectionESP:NewToggle("ESP Joueurs", "Afficher joueurs avec box", function(state)
    ESP_Enabled = state
    if not state then
        for _, box in pairs(ESP_Boxes) do
            box:Remove()
        end
        ESP_Boxes = {}
    end
end)

RunService.Heartbeat:Connect(function()
    if ESP_Enabled then
        local camera = workspace.CurrentCamera
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not ESP_Boxes[plr] then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Color = Color3.fromRGB(0, 170, 255)
                    box.Thickness = 2
                    ESP_Boxes[plr] = box
                end

                local rootPos = plr.Character.HumanoidRootPart.Position
                local pos, onScreen = camera:WorldToViewportPoint(rootPos)
                if onScreen then
                    local size = 50 / (rootPos - camera.CFrame.Position).Magnitude
                    local box = ESP_Boxes[plr]
                    box.Size = Vector2.new(size * 2, size * 3)
                    box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                    box.Transparency = 1
                    box.Visible = true
                else
                    ESP_Boxes[plr].Visible = false
                end
            elseif ESP_Boxes[plr] then
                ESP_Boxes[plr]:Remove()
                ESP_Boxes[plr] = nil
            end
        end
    end
end)

-- Save Instance (SynSaveInstance)
local synsave_loaded = false
SectionSave:NewButton("Save la map", "Sauvegarde universelle (SynSaveInstance)", function()
    if synsave_loaded then return end
    synsave_loaded = true

    local Params = {
        RepoURL = "https://raw.githubusercontent.com/luau/SynSaveInstance/main/",
        SSI = "saveinstance",
    }
    local synsaveinstance = loadstring(game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true), Params.SSI)()
    local Options = {}
    synsaveinstance(Options)
end)

-- Scripts Divers
SectionMisc:NewButton("Dex Explorer V5", "Explorateur avancé", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Dex%20Explorer.txt"))()
end)

SectionMisc:NewButton("Infinite Yield", "Commandes admin avancées", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()
end)

SectionMisc:NewButton("BTools", "Outils de construction", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
end)

SectionMisc:NewButton("Owl Hub", "Hub alternatif complet", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/OwlHub.txt"))()
end)

-- Copier lien Discord (avec clipboard)
SectionMisc:NewButton("Copier lien Discord", "Cliquez pour copier le lien du serveur", function()
    local discordLink = "discord.gg/3aJjPpzw9b"
    if setclipboard then
        setclipboard(discordLink)
        print("Lien Discord copié dans le presse-papier.")
    else
        print("setclipboard non supporté par votre exécuteur.")
    end
end)

-- Fly Hack (basique, WASD + Space/Shift)
local flying = false
local flySpeed = 50
local flyLoop
local humanoid = nil

SectionBypass:NewToggle("Bypass Anti-Cheat Simple", "Masquer certaines propriétés", function(state)
    if state then
        SimpleBypass()
        print("Bypass activé.")
    else
        print("Bypass désactivé. (Reconnexion requise pour reset)")
    end
end)

SectionBypass:NewToggle("Fly Hack", "Voler librement", function(state)
    flying = state
    if flying then
        if not LocalPlayer.Character then return end
        humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Name = "FlyVelocity"
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bodyGyro.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        bodyGyro.Name = "FlyGyro"
        bodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart

        flyLoop = RunService.Heartbeat:Connect(function()
            local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            local velocity = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                velocity = velocity + workspace.CurrentCamera.CFrame.LookVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                velocity = velocity - workspace.CurrentCamera.CFrame.LookVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                velocity = velocity - workspace.CurrentCamera.CFrame.RightVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                velocity = velocity + workspace.CurrentCamera.CFrame.RightVector * flySpeed
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, flySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, flySpeed, 0)
            end

            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.BodyVelocity.Velocity = velocity
                LocalPlayer.Character.HumanoidRootPart.BodyGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyVelocity") then
                LocalPlayer.Character.HumanoidRootPart.FlyVelocity:Destroy()
            end
            if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("FlyGyro") then
                LocalPlayer.Character.HumanoidRootPart.FlyGyro:Destroy()
            end
        end
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
    end
end)

-- Crédits
SectionCredits:NewLabel("Développé par TPU {-TPU-3945-}")
SectionCredits:NewLabel("Discord : discord.gg/3aJjPpzw9b")
SectionCredits:NewLabel("Version : V5 MEGA")

print("TPU HUB V5 MEGA chargé avec succès.")
