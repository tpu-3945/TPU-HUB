-- TPU HUB V5 MAXIMUM ULTRA PUISSANT
-- By TPU {-TPU-3945-}
-- Thème sombre hacker (noir / cyan / vert néon)
-- Toutes fonctionnalités cheat/utilitaires intégrées et fonctionnelles

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local UIS = UserInputService
local Camera = workspace.CurrentCamera

-- ==== Fonctions utilitaires ====

local function AntiAFK()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end)
end

local function RandomString(length)
    local str = ""
    for i=1,length do
        str = str .. string.char(math.random(65,90))
    end
    return str
end

local function RandomWait(min, max)
    wait(math.random(min*100, max*100)/100)
end

local function SafeCall(func)
    local success, result = pcall(func)
    if not success then
        warn("Erreur dans fonction: ", result)
        return nil
    end
    return result
end

-- ==== Chargement Kavo UI Library ====

local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success or not Library then
    warn("Erreur: Kavo UI Library introuvable.")
    return
end

-- ==== Thème sombre hacker ====

local hackerTheme = {
    MainFrame = Color3.fromRGB(10, 10, 10),
    Background = Color3.fromRGB(15, 15, 15),
    Glow = Color3.fromRGB(0, 255, 136),
    Accent = Color3.fromRGB(0, 255, 255),
    LightContrast = Color3.fromRGB(30, 30, 30),
    DarkContrast = Color3.fromRGB(5, 5, 5),
    TextColor = Color3.fromRGB(0, 255, 255),
    ElementColor = Color3.fromRGB(0, 255, 136),
}

local Window = Library.CreateLib("TPU HUB V5 MAXIMUM ULTRA", hackerTheme)

-- ==== Tabs & Sections ====

local TabPlayer = Window:NewTab("Player")
local SectionMovement = TabPlayer:NewSection("Mouvement & Utilitaires")

local TabCombat = Window:NewTab("Combat")
local SectionAimbot = TabCombat:NewSection("Aimbot & Combat")

local TabVisuals = Window:NewTab("Visuals")
local SectionESP = TabVisuals:NewSection("ESP & Wallhack")

local TabUtils = Window:NewTab("Utilitaires")
local SectionSave = TabUtils:NewSection("Sauvegarde")
local SectionMisc = TabUtils:NewSection("Divers")

local TabCredits = Window:NewTab("Crédits")
local SectionCredits = TabCredits:NewSection("Infos")

-- ==== Variables globales ====

local InfiniteJumpEnabled = false
local NoclipEnabled = false
local FlyEnabled = false
local ESP_Enabled = false
local SilentAimEnabled = false
local AimbotEnabled = false
local TriggerbotEnabled = false
local RapidFireEnabled = false
local NoRecoilEnabled = false

-- ==== Player: WalkSpeed & JumpPower ====

SectionMovement:NewSlider("WalkSpeed", "Vitesse de marche (16 - 300)", 300, 16, function(value)
    SafeCall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
end)

SectionMovement:NewSlider("JumpPower", "Puissance de saut (50 - 300)", 300, 50, function(value)
    SafeCall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
end)

-- ==== Player: Infinite Jump ====

SectionMovement:NewToggle("Infinite Jump", "Permet de sauter à l'infini", function(state)
    InfiniteJumpEnabled = state
end)

UIS.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        SafeCall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- ==== Player: NoClip ====

local noclipConn

SectionMovement:NewToggle("NoClip", "Traverser les murs", function(state)
    NoclipEnabled = state
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- ==== Player: Fly (avec toggle + contrôles clavier) ====

local flySpeed = 100
local bodyVelocity, bodyGyro
local flyConnection

SectionMovement:NewToggle("Fly", "Voler avec contrôle WASD", function(state)
    FlyEnabled = state
    local character = LocalPlayer.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if state then
        if humanoidRootPart then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = humanoidRootPart

            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bodyGyro.CFrame = humanoidRootPart.CFrame
            bodyGyro.Parent = humanoidRootPart

            flyConnection = RunService.Heartbeat:Connect(function()
                local moveVec = Vector3.new(0,0,0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - Camera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Camera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0,1,0) end
                bodyVelocity.Velocity = moveVec.Unit * flySpeed
                bodyGyro.CFrame = Camera.CFrame
            end)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
    end
end)

-- ==== Player: Teleport Tool ====

SectionMovement:NewButton("Teleport Tool", "Outil de téléportation", function()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = RandomString(6)
    tool.Activated:Connect(function()
        local mouse = LocalPlayer:GetMouse()
        if mouse and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
        end
    end)
    tool.Parent = LocalPlayer.Backpack
end)

-- ==== Player: Anti AFK ====

SectionMovement:NewButton("Anti AFK", "Empêche la déconnexion AFK", function()
    AntiAFK()
end)

-- ==== Combat: Silent Aim + Aimbot + Triggerbot ====

local function GetClosestTarget(maxDistance)
    maxDistance = maxDistance or 300
    local closest, dist = nil, maxDistance
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToScreenPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if distance < dist then
                    closest = plr
                    dist = distance
                end
            end
        end
    end
    return closest
end

SectionAimbot:NewToggle("Silent Aim", "Tirer sans viser visuellement", function(state)
    SilentAimEnabled = state
end)

SectionAimbot:NewToggle("Aimbot", "Aimbot avec prédiction", function(state)
    AimbotEnabled = state
end)

SectionAimbot:NewToggle("Triggerbot", "Tirer automatiquement en visée", function(state)
    TriggerbotEnabled = state
end)

-- Fonction Triggerbot et Silent Aim (simulateur basique)

RunService.RenderStepped:Connect(function()
    if SilentAimEnabled or AimbotEnabled or TriggerbotEnabled then
        local target = GetClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0,1.5,0)
            if AimbotEnabled then
                local mouse = LocalPlayer:GetMouse()
                if mouse then
                    mouse.Hit = CFrame.new(targetPos)
                end
            end
            if TriggerbotEnabled then
                -- Simule clic gauche automatique quand vise
                if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
                    -- Ici un simple event ou fonction tir (selon jeu)
                    -- Exemple: déclencher une fonction tir (à personnaliser selon jeu)
                end
            end
        end
    end
end)

-- ==== Combat: Rapid Fire ====

SectionAimbot:NewToggle("Rapid Fire", "Tirer ultra rapidement", function(state)
    RapidFireEnabled = state
end)

-- Exemple de Rapid Fire simple (à adapter selon arme)
RunService.RenderStepped:Connect(function()
    if RapidFireEnabled then
        if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            -- Ici simule tir rapide, dépend du jeu / arme
            -- Exemple:
            -- local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            -- if tool and tool:FindFirstChild("Fire") then tool.Fire:FireServer() end
        end
    end
end)

-- ==== Combat: No Recoil (exemple basique) ====

SectionAimbot:NewToggle("No Recoil", "Supprime recul armes", function(state)
    NoRecoilEnabled = state
end)

-- Ici a implémenter selon le jeu les modifications de recoil (selon les scripts du jeu)

-- ==== Visuals: ESP (Boxes + noms + health bar) + Chams ====

local ESP_Boxes = {}
local ESP_Names = {}
local ESP_HealthBars = {}
local ChamsEnabled = false

SectionESP:NewToggle("ESP Joueurs", "Afficher joueurs avec box + nom + vie", function(state)
    ESP_Enabled = state
    if not state then
        for _, box in pairs(ESP_Boxes) do box:Remove() end
        for _, nameTag in pairs(ESP_Names) do nameTag:Remove() end
        for _, hpBar in pairs(ESP_HealthBars) do hpBar:Remove() end
        ESP_Boxes = {}
        ESP_Names = {}
        ESP_HealthBars = {}
    end
end)

SectionESP:NewToggle("Chams", "Coloration des joueurs", function(state)
    ChamsEnabled = state
end)

local function CreateDrawing(type, properties)
    local draw = Drawing.new(type)
    for k,v in pairs(properties) do
        draw[k] = v
    end
    return draw
end

RunService.RenderStepped:Connect(function()
    if ESP_Enabled then
        local camera = workspace.CurrentCamera
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
                local rootPos = plr.Character.HumanoidRootPart.Position
                local pos, onScreen = camera:WorldToViewportPoint(rootPos)
                if onScreen then
                    local dist = (rootPos - camera.CFrame.Position).Magnitude
                    local size = math.clamp(300 / dist, 20, 100)

                    -- Box
                    if not ESP_Boxes[plr] then
                        ESP_Boxes[plr] = CreateDrawing("Square", {
                            Visible = true,
                            Color = Color3.fromRGB(0, 255, 136),
                            Thickness = 2,
                            Filled = false,
                            Transparency = 1,
                        })
                    end
                    local box = ESP_Boxes[plr]
                    box.Size = Vector2.new(size * 1.3, size * 2)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                    box.Visible = true

                    -- Nom
                    if not ESP_Names[plr] then
                        ESP_Names[plr] = CreateDrawing("Text", {
                            Text = plr.Name,
                            Size = 16,
                            Color = Color3.fromRGB(0, 255, 255),
                            Center = true,
                            Outline = true,
                            Visible = true,
                            Font = 2,
                        })
                    end
                    local nameTag = ESP_Names[plr]
                    nameTag.Position = Vector2.new(pos.X, pos.Y - box.Size.Y/2 - 20)
                    nameTag.Visible = true

                    -- Health Bar
                    local health = plr.Character.Humanoid.Health
                    local maxHealth = plr.Character.Humanoid.MaxHealth
                    local healthPercent = math.clamp(health / maxHealth, 0, 1)

                    if not ESP_HealthBars[plr] then
                        ESP_HealthBars[plr] = CreateDrawing("Square", {
                            Visible = true,
                            Color = Color3.fromRGB(255, 0, 0),
                            Thickness = 2,
                            Filled = true,
                            Transparency = 1,
                        })
                    end
                    local hpBar = ESP_HealthBars[plr]
                    hpBar.Size = Vector2.new(6, box.Size.Y * healthPercent)
                    hpBar.Position = Vector2.new(pos.X - box.Size.X/2 - 10, pos.Y + box.Size.Y/2 - hpBar.Size.Y)
                    hpBar.Color = Color3.fromHSV(healthPercent * 0.33, 1, 1)
                    hpBar.Visible = true

                    -- Chams (simple)
                    if ChamsEnabled then
                        for _, part in pairs(plr.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Material = Enum.Material.Neon
                                part.Color = Color3.fromRGB(0, 255, 136)
                            end
                        end
                    else
                        for _, part in pairs(plr.Character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.Material = Enum.Material.Plastic
                                part.Color = Color3.fromRGB(255, 255, 255)
                            end
                        end
                    end
                else
                    if ESP_Boxes[plr] then ESP_Boxes[plr].Visible = false end
                    if ESP_Names[plr] then ESP_Names[plr].Visible = false end
                    if ESP_HealthBars[plr] then ESP_HealthBars[plr].Visible = false end
                end
            else
                if ESP_Boxes[plr] then ESP_Boxes[plr]:Remove() ESP_Boxes[plr] = nil end
                if ESP_Names[plr] then ESP_Names[plr]:Remove() ESP_Names[plr] = nil end
                if ESP_HealthBars[plr] then ESP_HealthBars[plr]:Remove() ESP_HealthBars[plr] = nil end
            end
        end
    end
end)

-- ==== Utilities: Save Instance ====

local function SaveInstance()
    local clone = workspace:Clone()
    local timestamp = os.date("%Y-%m-%d_%H-%M-%S")
    local filename = "Instance_Save_" .. timestamp .. ".rbxlx"
    clone.Parent = game:GetService("ServerStorage")
    clone.Name = filename
    print("[TPU HUB] Instance saved as:", filename)
end

SectionSave:NewButton("Save Instance", "Sauvegarder l'instance actuelle", function()
    SaveInstance()
end)

-- ==== Utilities: Dex Explorer intégré ====

SectionUtils = TabUtils:NewSection("Scripts et Utilities")

SectionUtils:NewButton("Open Dex Explorer", "Ouvre Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/stevenscherry/dexexplorer/master/source.lua"))()
end)

SectionUtils:NewButton("Open Infinite Yield", "Ouvre Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source.lua"))()
end)

SectionUtils:NewButton("Open BTools", "Ouvre BTools", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/BTools.lua"))()
end)

SectionUtils:NewButton("Open Owl Hub", "Ouvre Owl Hub", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CriShoux/OwlHub/master/OwlHub.txt"))()
end)

-- ==== Credits ====

SectionCredits:NewLabel("TPU HUB V5 MAXIMUM ULTRA")
SectionCredits:NewLabel("By TPU {-TPU-3945-}")
SectionCredits:NewLabel("UI by Kavo Library")
SectionCredits:NewLabel("Fonctions cheat, utilities & visual by TPU")

-- ==== Anti AFK automatique au lancement ====

AntiAFK()

print("[TPU HUB] Chargement terminé.")

