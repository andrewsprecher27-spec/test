-- Dusk & Shine AUTO FARM - Pet + Baby + Auto Spawn + Rejoin every 30min
-- Execute in Delta → Click START in the GUI

local Players = game:GetService("Players")
local TS = game:GetService("TeleportService")
local RS = game:GetService("RunService")
local player = Players.LocalPlayer
local placeId = game.PlaceId

local REJOIN_MIN = 30  -- minutes
local REJOIN_SEC = REJOIN_MIN * 60

-- Simple draggable status GUI
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "DuskAuto"
sg.ResetOnSpawn = false

local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0,320,0,140)
f.Position = UDim2.new(0,10,0,10)
f.BackgroundColor3 = Color3.fromRGB(30,30,40)
f.Active = true
f.Draggable = true

local c = Instance.new("UICorner", f); c.CornerRadius = UDim2.new(0,10,0,10)

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1,0,0,35)
t.BackgroundTransparency = 1
t.Text = "Dusk & Shine Auto-Farm"
t.TextColor3 = Color3.new(1,1,1)
t.TextScaled = true
t.Font = Enum.Font.GothamBold

local stat = Instance.new("TextLabel", f)
stat.Size = UDim2.new(1,-20,0,25)
stat.Position = UDim2.new(0,10,0,40)
stat.BackgroundTransparency = 1
stat.Text = "Ready - Click START"
stat.TextColor3 = Color3.fromRGB(200,200,200)
stat.TextScaled = true

local timerLbl = Instance.new("TextLabel", f)
timerLbl.Size = UDim2.new(1,-20,0,20)
timerLbl.Position = UDim2.new(0,10,0,70)
timerLbl.BackgroundTransparency = 1
timerLbl.Text = "Rejoin in: --:--"
timerLbl.TextColor3 = Color3.fromRGB(100,255,100)
timerLbl.TextScaled = true

local startB = Instance.new("TextButton", f)
startB.Size = UDim2.new(0.4,0,0,30)
startB.Position = UDim2.new(0.05,0,0.75,0)
startB.BackgroundColor3 = Color3.fromRGB(0,180,0)
startB.Text = "START"
startB.TextColor3 = Color3.new(1,1,1)
startB.TextScaled = true

local stopB = Instance.new("TextButton", f)
stopB.Size = UDim2.new(0.4,0,0,30)
stopB.Position = UDim2.new(0.55,0,0.75,0)
stopB.BackgroundColor3 = Color3.fromRGB(180,0,0)
stopB.Text = "STOP"
stopB.TextColor3 = Color3.new(1,1,1)
startB.TextScaled = true

local function addCorner(btn) local cc=Instance.new("UICorner",btn) cc.CornerRadius=UDim2.new(0,6,0,6) end
addCorner(startB) addCorner(stopB)

local running = false
local timeElapsed = 0
local conn

local function loadDusk()
    stat.Text = "Loading Dusk & Shine..."
    loadstring(game:HttpGet("https://raw.githubusercontent.com/fr3dope/DuskAndShine-ADM/main/Loader.lua", true))()
    task.wait(4)
end

local function clickSpawn()
    stat.Text = "Clicking green Spawn..."
    for i=1,30 do
        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (v.Text:lower():find("spawn") or v.BackgroundColor3.r > 0.9 and v.BackgroundColor3.g > 0.9 and v.BackgroundColor3.b < 0.1) then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + v.AbsoluteSize.X/2, v.AbsolutePosition.Y + v.AbsoluteSize.Y/2, 0, true, game, 0)
                task.wait(0.05)
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + v.AbsoluteSize.X/2, v.AbsolutePosition.Y + v.AbsoluteSize.Y/2, 0, false, game, 0)
            end
        end
        task.wait(0.6)
    end
end

local function toggleFarms(on)
    local vals = on and true or false
    for _,k in pairs({"AutoFarmPet","PetFarm","FarmPet","AutoPet","AutoFarmBaby","BabyFarm","FarmBaby","AutoBaby"}) do
        if _G[k] ~= nil then _G[k] = vals end
        if getgenv and getgenv()[k] then getgenv()[k] = vals end
    end
    stat.Text = on and "Farms toggled ON" or "Farms OFF"
end

local function cycle()
    loadDusk()
    clickSpawn()
    task.wait(3)
    toggleFarms(true)
end

startB.MouseButton1Click:Connect(function()
    if not running then
        running = true
        startB.Text = "RUNNING"
        startB.BackgroundColor3 = Color3.fromRGB(0,220,0)
        cycle()
    end
end)

stopB.MouseButton1Click:Connect(function()
    running = false
    startB.Text = "START"
    startB.BackgroundColor3 = Color3.fromRGB(0,180,0)
    toggleFarms(false)
    stat.Text = "Stopped"
end)

conn = RS.Heartbeat:Connect(function(dt)
    if running then
        timeElapsed = timeElapsed + dt
        local rem = REJOIN_SEC - math.floor(timeElapsed)
        local m = math.floor(rem / 60)
        local s = rem % 60
        timerLbl.Text = string.format("Rejoin in: %02d:%02d", m, s)
        if timeElapsed >= REJOIN_SEC then
            stat.Text = "Rejoining..."
            TS:Teleport(placeId, player)
        end
    end
end)

player.CharacterAdded:Connect(function()
    if running then task.wait(5) cycle() end
end)

print("Dusk Auto loaded - open GUI & START!")
