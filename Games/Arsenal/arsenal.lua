local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "Arsenal Script", HidePremium = false, SaveConfig = true, ConfigFolder = "ArsenalConfig"})

local MainTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local Section = MainTab:AddSection({Name = "Gun Mods"})

local SettingsInfinite = false
Section:AddToggle({
    Name = "Infinite Ammo",
    Default = false,
    Flag = "InfAmmo",
    Callback = function(Value)
        SettingsInfinite = Value
        if SettingsInfinite then
            game:GetService("RunService").Stepped:connect(function()
                pcall(function()
                    if SettingsInfinite then
                        local playerGui = game:GetService("Players").LocalPlayer.PlayerGui
                        playerGui.GUI.Client.Variables.ammocount.Value = 99
                        playerGui.GUI.Client.Variables.ammocount2.Value = 99
                    end
                end)
            end)
        end
    end    
})

Section:AddToggle({
    Name = "Fast Reload",
    Default = false,
    Flag = "FastReload",
    Callback = function(Value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
            if v:FindFirstChild("ReloadTime") then
                v.ReloadTime.Value = Value and 0.01 or 0.8
            end
            if v:FindFirstChild("EReloadTime") then
                v.EReloadTime.Value = Value and 0.01 or 0.8
            end
        end
    end    
})

Section:AddToggle({
    Name = "Fast Fire Rate",
    Default = false,
    Flag = "FastFire",
    Callback = function(Value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "FireRate" or v.Name == "BFireRate" then
                v.Value = Value and 0.02 or 0.8
            end
        end
    end    
})

Section:AddToggle({
    Name = "Always Auto",
    Default = false,
    Flag = "AlwaysAuto",
    Callback = function(Value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "Auto" or v.Name == "AutoFire" or v.Name == "Automatic" or v.Name == "AutoShoot" or v.Name == "AutoGun" then
                v.Value = Value
            end
        end
    end    
})

Section:AddToggle({
    Name = "No Spread",
    Default = false,
    Flag = "NoSpread",
    Callback = function(Value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "MaxSpread" or v.Name == "Spread" or v.Name == "SpreadControl" then
                v.Value = Value and 0 or 1
            end
        end
    end    
})

Section:AddToggle({
    Name = "No Recoil",
    Default = false,
    Flag = "NoRecoil",
    Callback = function(Value)
        for _, v in pairs(game.ReplicatedStorage.Weapons:GetDescendants()) do
            if v.Name == "RecoilControl" or v.Name == "Recoil" then
                v.Value = Value and 0 or 1
            end
        end
    end    
})

local rainbowEnabled = false
local c = 1
local function zigzag(X) return math.acos(math.cos(X * math.pi)) / math.pi end

Section:AddToggle({
    Name = "Rainbow Gun",
    Default = false,
    Flag = "RainbowGun",
    Callback = function(Value)
        rainbowEnabled = Value
    end    
})

game:GetService("RunService").RenderStepped:Connect(function() 
    if game.Workspace.Camera:FindFirstChild('Arms') and rainbowEnabled then 
        for _, v in pairs(game.Workspace.Camera.Arms:GetDescendants()) do 
            if v.ClassName == 'MeshPart' then 
                v.Color = Color3.fromHSV(zigzag(c), 1, 1)
                c = c + .0001
            end 
        end 
    end 
end)

local ChatTab = Window:MakeTab({Name = "Chat", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local ChatSection = ChatTab:AddSection({Name = "Chat Features"})

ChatSection:AddToggle({Name = "IsChad", Default = false, Flag = "IsChad", Callback = function(Value)
    if game.Players.LocalPlayer:FindFirstChild('IsChad') then game.Players.LocalPlayer.IsChad:Destroy() end
    if Value then Instance.new('IntValue', game.Players.LocalPlayer).Name = "IsChad" end
end})

ChatSection:AddToggle({Name = "VIP", Default = false, Flag = "VIP", Callback = function(Value)
    if game.Players.LocalPlayer:FindFirstChild('VIP') then game.Players.LocalPlayer.VIP:Destroy() end
    if Value then Instance.new('IntValue', game.Players.LocalPlayer).Name = "VIP" end
end})

ChatSection:AddToggle({Name = "OldVIP", Default = false, Flag = "OldVIP", Callback = function(Value)
    if game.Players.LocalPlayer:FindFirstChild('OldVIP') then game.Players.LocalPlayer.OldVIP:Destroy() end
    if Value then Instance.new('IntValue', game.Players.LocalPlayer).Name = "OldVIP" end
end})

ChatSection:AddToggle({Name = "Romin", Default = false, Flag = "Romin", Callback = function(Value)
    if game.Players.LocalPlayer:FindFirstChild('Romin') then game.Players.LocalPlayer.Romin:Destroy() end
    if Value then Instance.new('IntValue', game.Players.LocalPlayer).Name = "Romin" end
end})

ChatSection:AddToggle({Name = "IsAdmin", Default = false, Flag = "IsAdmin", Callback = function(Value)
    if game.Players.LocalPlayer:FindFirstChild('IsAdmin') then game.Players.LocalPlayer.IsAdmin:Destroy() end
    if Value then Instance.new('IntValue', game.Players.LocalPlayer).Name = "IsAdmin" end
end})

local MovementTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MovementSection = MovementTab:AddSection({Name = "Movement Mods"})

local bHopEnabled = false
local jumpDelay = 0
local velocityMultiplier = 1.2

local function GetMoveVector()
    local camera = workspace.CurrentCamera
    local character = game.Players.LocalPlayer.Character
    if not character then return Vector3.new() end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return Vector3.new() end
    
    local moveDirection = humanoid.MoveDirection
    if moveDirection.Magnitude == 0 then return Vector3.new() end
    
    local cameraLook = camera.CFrame.LookVector
    cameraLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
    local angle = math.atan2(cameraLook.Z, cameraLook.X)
    
    local moveVector = moveDirection * velocityMultiplier
    return moveVector
end

local function BunnyHop()
    while bHopEnabled do
        local character = game.Players.LocalPlayer.Character
        if not character then task.wait() continue end
        
        local humanoid = character:FindFirstChild("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart then
            local moveVector = GetMoveVector()
            
            if moveVector.Magnitude > 0 then
                if humanoid.FloorMaterial == Enum.Material.Air then
                    rootPart.CFrame = rootPart.CFrame + moveVector * 0.06
                    jumpDelay = 0
                else
                    if jumpDelay <= 0 then
                        humanoid.Jump = true
                        jumpDelay = 0.05
                    else
                        jumpDelay = jumpDelay - task.wait()
                    end
                end
            end
        end
        task.wait()
    end
end

MovementSection:AddToggle({
    Name = "Enhanced Bunny Hop",
    Default = false,
    Flag = "BHop",
    Callback = function(Value)
        bHopEnabled = Value
        if Value then
            coroutine.wrap(BunnyHop)()
        end
    end
})

OrionLib:Init()
