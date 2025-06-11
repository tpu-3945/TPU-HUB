-- TPU HUB v1 [PREMIUM] - Inspired by BOAE HUB UI
-- Discord: https://discord.gg/3aJjPpzw9b
-- Développé par tueur_de_l€ak {-TPU-3945-}

if getgenv().TPU_HUB_LOADED then return end
getgenv().TPU_HUB_LOADED = true

-- Chargement de Rayfield
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

-- Fenêtre principale
local Window = Rayfield:CreateWindow({
    Name = "TPU Hub v1 [PREMIUM]",
    LoadingTitle = "Chargement TPU HUB...",
    LoadingSubtitle = "by tueur_de_l€ak {-TPU-3945-}",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "TPUHub",
        FileName = "TPU_Config"
    },
    Discord = {
        Enabled = true,
        Invite = "3aJjPpzw9b",
        RememberJoins = true
    },
    KeySystem = false
})

-- 🟢 UTILS
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- 🧩 TABS
local Tabs = {
    Player = Window:CreateTab("Player", 4483362458),
    Esp = Window:CreateTab("Esp", 4483362458),
    Hitbox = Window:CreateTab("Hitbox", 4483362458),
    Aimbot = Window:CreateTab("Aimbot", 4483362458),
    ACS175 = Window:CreateTab("ACS 1.7.5", 4483362458),
    ACS201 = Window:CreateTab("ACS 2.0.1", 4483362458),
    Fun = Window:CreateTab("Fun", 4483362458),
    Others = Window:CreateTab("Others", 4483362458)
}

-- 🧠 PLAYER TAB
local InfiniteJumpEnabled = false
Tabs.Player:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 200},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Callback = function(v)
        Humanoid.WalkSpeed = v
    end
})

Tabs.Player:CreateSlider({
    Name = "JumpPower",
    Range = {50, 300},
    Increment = 1,
    Suffix = "power",
    CurrentValue = 50,
    Callback = function(v)
        Humanoid.JumpPower = v
    end
})

Tabs.Player:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(value)
        InfiniteJumpEnabled = value
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local invisibleEnabled = false
local UIS = game:GetService("UserInputService")

UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.X then
        invisibleEnabled = not invisibleEnabled
        local root = Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Transparency = invisibleEnabled and 1 or 0
        end
    end
end)

Tabs.Player:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
    end
})

Tabs.Player:CreateButton({
    Name = "Anti-Fling",
    Callback = function()
        game:GetService("RunService").Stepped:Connect(function()
            for _,v in pairs(game.Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    v.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end
        end)
    end
})

Tabs.Player:CreateButton({
    Name = "Teleport Tool",
    Callback = function()
        local tool = Instance.new("Tool")
        tool.RequiresHandle = false
        tool.Name = "TP Tool"
        tool.Activated:Connect(function()
            local mouse = LocalPlayer:GetMouse()
            if mouse then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0,3,0))
                end
            end
        end)
        tool.Parent = LocalPlayer.Backpack
    end
})

local noclipConnection

Tabs.Player:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Callback = function(value)
        local runService = game:GetService("RunService")
        if value then
            noclipConnection = runService.Stepped:Connect(function()
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
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
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
})

-- 📄 CRÉDITS
local CreditsTab = Window:CreateTab("Crédits", 4483362458)
CreditsTab:CreateParagraph({
    Title = "Développé par",
    Content = "tueur_de_l€ak {-TPU-3945-}\nServeur TPU: discord.gg/3aJjPpzw9b"
})

-- ✅ Notification de chargement
Rayfield:Notify({
    Title = "TPU HUB Premium",
    Content = "Chargement complet. Bienvenue !",
    Duration = 6
})
