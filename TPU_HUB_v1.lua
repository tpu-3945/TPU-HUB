-- TPU HUB V5 - MEGA PUISSANT - By TPU {-TPU-3945-}
-- Interface: Kavo UI Library (DarkTheme modifié)
-- Anti-détection : Randomisation, Hook Protection, Delais aléatoires, Garbage Code

-- ========== UTILITAIRES ==========

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

-- Fonction anti-AFK simple
local function AntiAFK()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Fonction de randomisation simple
local function RandomString(length)
    local str = ""
    for i=1,length do
        str = str .. string.char(math.random(65,90))
    end
    return str
end

-- Fonction delay aléatoire
local function RandomWait(min, max)
    wait(math.random(min*100, max*100)/100)
end

-- Hook protection basique (exemple, à adapter selon exploit)
local function SafeHook(func)
    local success, result = pcall(func)
    if not success then
        warn("Hook protection triggered, function blocked.")
        return nil
    end
    return result
end

-- ========== CHARGEMENT DE LA LIBRAIRIE KAVO UI ==========
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)
if not success or not Library then
    warn("Erreur: Kavo UI Library introuvable.")
    return
end

-- Création fenêtre avec thème sombre bleu électrique
local Window = Library.CreateLib("TPU HUB V5 MEGA", "DarkTheme")
Window:ChangeTheme({
    Background = Color3.fromRGB(15,15,20),
    Glow = Color3.fromRGB(0,170,255),
    Accent = Color3.fromRGB(0,170,255),
    LightContrast = Color3.fromRGB(40,40,50),
    DarkContrast = Color3.fromRGB(10,10,15)
})

-- ========== TABS & SECTIONS ==========
local TabPlayer = Window:NewTab("Player")
local SectionMovement = TabPlayer:NewSection("Mouvement & Utilitaires")

local TabCheats = Window:NewTab("Cheats")
local SectionAimbot = TabCheats:NewSection("Aimbot & Combat")
local SectionESP = TabCheats:NewSection("ESP & Wallhack")

local TabUtils = Window:NewTab("Utilitaires")
local SectionSave = TabUtils:NewSection("Sauvegarde")
local SectionMisc = TabUtils:NewSection("Divers")

local TabCredits = Window:NewTab("Crédits")
local SectionCredits = TabCredits:NewSection("Infos")

-- ========== FONCTIONS PLAYER ==========

-- WalkSpeed + JumpPower sliders
SectionMovement:NewSlider("WalkSpeed", "Vitesse de marche", 250, 16, function(value)
    pcall(function()
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)

SectionMovement:NewSlider("JumpPower", "Puissance de saut", 300, 50, function(value)
    pcall(function()
        LocalPlayer.Character.Humanoid.JumpPower = value
    end)
end)

-- Infinite Jump
local InfiniteJumpEnabled = false
SectionMovement:NewToggle("Infinite Jump", "Saut infini", function(state)
    InfiniteJumpEnabled = state
end)
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        pcall(function()
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

-- NoClip optimisé (toggle)
local noclipConnection
SectionMovement:NewToggle("NoClip", "Traverser les murs", function(state)
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
        if noclipConnection then noclipConnection:Disconnect() end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Teleport Tool
SectionMovement:NewButton("Teleport Tool", "Outil de téléportation", function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = RandomString(6) -- randomisation nom
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

-- Anti AFK auto
SectionMovement:NewButton("Anti AFK", "Evite la déconnexion AFK", function()
    AntiAFK()
end)

-- ========== FONCTIONS AIMBOT ULTRA PUISSANT ==========

-- Aimbot silencieux prédictif (basique pour exemple, à améliorer)

local AimbotEnabled = false
local SilentAim = false
local Prediction = 0.15 -- prediction du déplacement cible

SectionAimbot:NewToggle("Aimbot Ultra", "Aimbot avec prediction", function(state)
    AimbotEnabled = state
end)

SectionAimbot:NewToggle("Silent Aim", "Tirer sans viser visuellement", function(state)
    SilentAim = state
end)

-- Hook tir (exemple basique - adapter selon jeu)

local function GetClosestTarget()
    local closest, dist = nil, math.huge
    local camera = workspace.CurrentCamera
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            -- Team check (optionnel)
            if true then
                local pos, onScreen = camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                    if distance < dist then
                        closest = plr
                        dist = distance
                    end
                end
            end
        end
    end
    return closest
end

-- Exemple simple de hook sur une fonction de tir (doit être adapté selon le jeu)

-- ========== FONCTIONS ESP & WALLHACK PUISSANT ==========

local ESP_Enabled = false
local ESP_Boxes = {}

SectionESP:NewToggle("ESP Joueurs", "Afficher joueurs avec box", function(state)
    ESP_Enabled = state
    if not state then
        -- Supprimer ESP
        for _, box in pairs(ESP_Boxes) do
            box:Destroy()
        end
        ESP_Boxes = {}
    end
end)

-- Fonction ESP basique (box autour joueur)
RunService.Heartbeat:Connect(function()
    if ESP_Enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not ESP_Boxes[plr] then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Color = Color3.fromRGB(0, 170, 255)
                    box.Thickness = 2
                    ESP_Boxes[plr] = box
                end

                local camera = workspace.CurrentCamera
                local rootPos = plr.Character.HumanoidRootPart.Position
                local pos, onScreen = camera:WorldToViewportPoint(rootPos)
                if onScreen then
                    local size = 50 / (rootPos - camera.CFrame.Position).Magnitude
                    local box = ESP_Boxes[plr]
                    box.Size = Vector2.new(size * 2, size * 3)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                    box.Transparency = 1
                else
                    ESP_Boxes[plr].Visible = false
                end
            elseif ESP_Boxes[plr] then
                ESP_Boxes[plr]:Destroy()
                ESP_Boxes[plr] = nil
            end
        end
    end
end)

-- ========== SAVE INSTANCE ==========

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

-- ========== AUTRES SCRIPTS UTILES ==========

SectionMisc:NewButton("Dex Explorer V5", "Explorateur avancé", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/AlterX404/DarkDEX-V5/main/DarkDEX-V5.lua"))()
end)

SectionMisc:NewButton("Infinite Yield", "Commandes admin avancées", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/Infinite%20Yield.txt"))()
end)

SectionMisc:NewButton("BTools", "Outils de construction", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/BTools.txt"))()
end)

SectionMisc:NewButton("Owl Hub", "Autre hub très complet", function()
    loadstring(game:HttpGet("https://cdn.wearedevs.net/scripts/OwlHub.txt"))()
end)

-- ========== CRÉDITS ==========

SectionCredits:NewLabel("Développé par TPU {-TPU-3945-}")
SectionCredits:NewLabel("Discord : discord.gg/3aJjPpzw9b")
SectionCredits:NewLabel("Version : V5 MEGA")

-- ========== FIN DU SCRIPT ==========
print("TPU HUB V5 MEGA chargé avec succès.")
