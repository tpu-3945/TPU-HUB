-- LKR HUB V12 - TPU-3945 POWER RP EDITION --

repeat task.wait() until game:IsLoaded()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
    end)
end)

-- Anti-kick / anti-ban
pcall(function()
    hookfunction(getfenv().pcall, function(...) return true end)
    hookfunction(getfenv().xpcall, function(...) return true end)
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

-- UI Kavo
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)
if not success then
    warn("Erreur chargement Kavo UI")
    return
end

local Window = Library.CreateLib("LKR HUB V12 | TPU-3945 RP POWER", "DarkTheme")

-- Onglets
local TabMain = Window:NewTab("Principal")
local TabMove = Window:NewTab("Déplacement")
local TabCombat = Window:NewTab("Combat")
local TabVision = Window:NewTab("Vision")
local TabMoney = Window:NewTab("Argent")
local TabUtil = Window:NewTab("Utilitaires")
local TabTeam = Window:NewTab("Team")
local TabRP = Window:NewTab("RP Tools")
local TabAbout = Window:NewTab("À propos")

-- Sections
local SecMain = TabMain:NewSection("Fonctions Principales")
local SecMove = TabMove:NewSection("Mouvement Avancé")
local SecCombat = TabCombat:NewSection("Combat & Défense")
local SecVision = TabVision:NewSection("ESP & Vision")
local SecMoney = TabMoney:NewSection("Argent & Stuff")
local SecUtil = TabUtil:NewSection("Outils & Exploits")
local SecTeam = TabTeam:NewSection("Changement de Team")
local SecRP = TabRP:NewSection("Outils RP")
local SecAbout = TabAbout:NewSection("Infos & Crédits")

-- VARIABLES vol et noclip
local flying = false
local flySpeed = 75
local bg, bv
local noclip = false
local noclipConnection

-- UTILITIES
local function getHumanoid(plr)
    if plr.Character then
        return plr.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function getHRP(plr)
    if plr.Character then
        return plr.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Give all tools
SecMain:NewButton("Give All Tools", "Récupère tous les outils du ReplicatedStorage", function()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    for _, item in pairs(ReplicatedStorage:GetDescendants()) do
        if item:IsA("Tool") or item:IsA("HopperBin") then
            pcall(function()
                item:Clone().Parent = backpack
            end)
        end
    end
end)

-- WalkSpeed slider
local walkSpeedVal = 16
SecMove:NewSlider("WalkSpeed", "Modifie la vitesse de déplacement", 500, 16, function(v)
    walkSpeedVal = v
    local humanoid = getHumanoid(LocalPlayer)
    if humanoid then humanoid.WalkSpeed = v end
end)

-- JumpPower slider
local jumpPowerVal = 50
SecMove:NewSlider("JumpPower", "Modifie la hauteur du saut", 300, 50, function(v)
    jumpPowerVal = v
    local humanoid = getHumanoid(LocalPlayer)
    if humanoid then humanoid.JumpPower = v end
end)

-- Fly toggle
SecMove:NewToggle("Fly", "Vol puissant", function(state)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flying = state

    if flying then
        bg = Instance.new("BodyGyro", hrp)
        bv = Instance.new("BodyVelocity", hrp)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = hrp.CFrame
        bv.velocity = Vector3.new(0, 0, 0)

        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not flying then
                bg:Destroy()
                bv:Destroy()
                conn:Disconnect()
                return
            end
            bg.cframe = workspace.CurrentCamera.CFrame
            local direction = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction += workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction -= workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction -= workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction += workspace.CurrentCamera.CFrame.RightVector
            end
            bv.velocity = direction.Unit * flySpeed
        end)
    else
        if bg then bg:Destroy() end
        if bv then bv:Destroy() end
    end
end)

-- NoClip toggle
SecMove:NewToggle("NoClip", "Traverse les murs", function(state)
    noclip = state
    if noclip then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Godmode
SecCombat:NewButton("GodMode", "Invincibilité quasi-infinie", function()
    local h = getHumanoid(LocalPlayer)
    if h then
        h.MaxHealth = math.huge
        h.Health = math.huge
        h:GetPropertyChangedSignal("Health"):Connect(function()
            if h.Health < h.MaxHealth then h.Health = h.MaxHealth end
        end)
    end
end)

-- Invisible toggle (toggle with revert)
local invisible = false
SecCombat:NewToggle("Invisible", "Toggle invisibilité", function(state)
    invisible = state
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Transparency = state and 1 or 0
            if part:IsA("Decal") then
                part.Transparency = state and 1 or 0
            end
        end
    end
end)

-- Anti stun / freeze (déplace le perso en cas de freeze)
SecCombat:NewToggle("Anti Freeze", "Empêche freeze / stun", function(state)
    if state then
        RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0,0,0.01)
            end
        end)
    else
        -- Rien, s'arrête au déconnexion du toggle
    end
end)

-- Kill Aura toggle (auto hit autour)
local killAura = false
SecCombat:NewToggle("Kill Aura", "Frappe auto les joueurs proches", function(state)
    killAura = state
    spawn(function()
        while killAura do
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 10 then
                        -- Example: frappe la cible, peut varier selon le jeu
                        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            hum.Health = 0
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- ESP classiques
SecVision:NewButton("ESP Classique", "Affiche les joueurs", function()
    loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
end)

-- ESP avancé
SecVision:NewButton("ESP Avancé", "ESP couleurs & équipes", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"))()
end)

-- Give argent
SecMoney:NewButton("Give Argent (999999)", "Donne beaucoup d'argent", function()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("money") or n:find("cash") or n:find("coins") then
                pcall(function()
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer(999999)
                    else
                        obj:InvokeServer(999999)
                    end
                end)
            end
        end
    end
end)

-- AutoFarm simple
SecUtil:NewButton("AutoFarm Basique", "Fait sauter le perso toutes les 3s", function()
    spawn(function()
        while true do
            if LocalPlayer.Character and getHumanoid(LocalPlayer) then
                getHumanoid(LocalPlayer):ChangeState(Enum.HumanoidStateType.Jumping)
            end
            task.wait(3)
        end
    end)
end)

-- Auto Quest simple
SecUtil:NewButton("Auto Quête Basique", "Accepte les quêtes automatiquement", function()
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local n = obj.Name:lower()
            if n:find("quest") then
                pcall(function()
                    if obj:IsA("RemoteEvent") then
                        obj:FireServer("accept")
                    else
                        obj:InvokeServer("accept")
                    end
                end)
            end
        end
    end
end)

-- Team switcher UI
SecTeam:NewButton("Ouvrir UI Team Switcher", "Change ta team facilement", function()
    if game.CoreGui:FindFirstChild("LKRTeamHub") then
        game.CoreGui.LKRTeamHub:Destroy()
        return
    end

    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "LKRTeamHub"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 260, 0, 310)
    frame.Position = UDim2.new(0, 20, 0.5, -155)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 4)

    local title = Instance.new("TextLabel", frame)
    title.Text = "LKR Team HUB V5 - WHITELIST BYPASS"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.TextColor3 = Color3.fromRGB(0, 255, 200)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 17

    local function hardcoreTeamSwitch(team)
        LocalPlayer.Team = team
        LocalPlayer.TeamColor = team.TeamColor or BrickColor.Random()
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                pcall(function()
                    if v:IsA("RemoteEvent") then
                        v:FireServer(team)
                        v:FireServer(team.Name)
                        v:FireServer({Team = team})
                        v:FireServer("Team", team)
                    else
                        v:InvokeServer(team)
                        v:InvokeServer(team.Name)
                        v:InvokeServer({Team = team})
                        v:InvokeServer("Team", team)
                    end
                end)
            end
        end
        wait(0.5)
        pcall(function()
            if LocalPlayer.Character then
                LocalPlayer.Character:Destroy()
            end
        end)
        wait(0.4)
        pcall(function()
            LocalPlayer:LoadCharacter()
        end)
    end

    for _, team in ipairs(Teams:GetChildren()) do
        local btn = Instance.new("TextButton", frame)
        btn.Text = "⚡ Forcer team : " .. team.Name
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 15
        btn.MouseButton1Click:Connect(function()
            hardcoreTeamSwitch(team)
        end)
    end
end)

-- TP Player
SecRP:NewTextBox("TP vers joueur", "Entre le pseudo exact", function(text)
    local target = Players:FindFirstChild(text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        end
    else
        warn("Joueur introuvable ou pas chargé")
    end
end)

-- Freeze player
SecRP:NewTextBox("Freeze joueur", "Freeze un joueur", function(text)
    local target = Players:FindFirstChild(text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        if hrp then
            hrp.Anchored = true
        end
    else
        warn("Joueur introuvable ou pas chargé")
    end
end)

-- Unfreeze player
SecRP:NewTextBox("Défreeze joueur", "Défreeze un joueur", function(text)
    local target = Players:FindFirstChild(text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        if hrp then
            hrp.Anchored = false
        end
    else
        warn("Joueur introuvable ou pas chargé")
    end
end)

-- Super punch (faut adapter selon le jeu)
SecRP:NewButton("Super Punch (Kill)", "Frappe instant", function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist < 10 then
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    hum.Health = 0
                end
            end
        end
    end
end)

-- Auto Heal (regen santé)
SecRP:NewToggle("Auto Heal", "Régénère automatiquement ta santé", function(state)
    spawn(function()
        while state do
            local h = getHumanoid(LocalPlayer)
            if h and h.Health < h.MaxHealth then
                h.Health = h.MaxHealth
            end
            task.wait(1)
        end
    end)
end)

-- Night Vision toggle
local nightVision = false
SecVision:NewToggle("Night Vision", "Active la vision nocturne", function(state)
    nightVision = state
    if nightVision then
        Lighting.Brightness = 3
        Lighting.Ambient = Color3.fromRGB(100,255,100)
        Lighting.FogEnd = 1000
    else
        Lighting.Brightness = 1
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
    end
end)

-- Teleport to waypoint (si existe un Marker dans Workspace)
SecRP:NewButton("TP to Waypoint", "Téléporte au waypoint", function()
    local waypoint = Workspace:FindFirstChild("Waypoint") or Workspace:FindFirstChild("Marker") or Workspace:FindFirstChild("MapMarker")
    local hrp = getHRP(LocalPlayer)
    if waypoint and hrp then
        hrp.CFrame = waypoint.CFrame + Vector3.new(0,3,0)
    else
        warn("Waypoint introuvable")
    end
end)

-- Unlock doors (exemple basique, dépend du jeu)
SecRP:NewButton("Unlock Doors", "Déverrouille les portes admin (exemple)", function()
    for _, door in pairs(Workspace:GetDescendants()) do
        if door.Name:lower():find("door") and door:IsA("BasePart") then
            door.CanCollide = false
            door.Transparency = 0.5
        end
    end
end)

-- Kill All (dans un rayon)
SecCombat:NewButton("Kill All (10m)", "Tue tous les joueurs proches", function()
    local hrp = getHRP(LocalPlayer)
    if not hrp then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
            if dist <= 10 then
                plr.Character.Humanoid.Health = 0
            end
        end
    end
end)

-- Crédits
SecAbout:NewLabel("LKR HUB V12 - TPU-3945 RP Edition")
SecAbout:NewLabel("Powered by TPU-3945")
SecAbout:NewLabel("Made with ❤️ and passion")

