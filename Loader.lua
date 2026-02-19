-- Dusk & Shine AUTO FARM - FIXED VISIBLE GUI + AUTO START
local Players = game:GetService("Players")
local TS = game:GetService("TeleportService")
local RS = game:GetService("RunService")
local player = Players.LocalPlayer
local placeId = game.PlaceId

local REJOIN_MIN = 30
local REJOIN_SEC = REJOIN_MIN * 60

-- BRIGHT CENTERED GUI
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "DuskAuto"
sg.ResetOnSpawn = false

local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0,400,0,200)
f.Position = UDim2.new(0.5,-200,0.5,-100)  -- CENTER SCREEN
f.BackgroundColor3 = Color3.fromRGB(0,255,0)  -- BRIGHT GREEN
f.Active = true
f.Draggable = true

local c = Instance.new("UICorner", f); c.CornerRadius = UDim2.new(0,15,0,15)

-- HUGE WHITE TITLE
local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1,0,0,50)
t.BackgroundTransparency = 1
t.Text = "🚀 DUSK & SHINE AUTO FARM LOADED!"
t.TextColor3 = Color3.new(1,1,1)
t.TextScaled = true
t.Font = Enum.Font.GothamBold

-- STATUS - HUGE
local stat = Instance.new("TextLabel", f)
stat.Size = UDim2.new(1,-20,0,40)
stat.Position = UDim2.new(0,10,0,60)
stat.BackgroundColor3 = Color3.fromRGB(255,255,255)
stat.Text = "STARTING FARMS..."
stat.TextColor3 = Color3.fromRGB(0,0,0)
stat.TextScaled = true
stat.Font = Enum.Font.GothamBold

-- TIMER - HUGE
local timerLbl = Instance.new("TextLabel", f)
timerLbl.Size = UDim2.new(1,-20,0,30)
timerLbl.Position = UDim2.new(0,10,0,110)
timerLbl.BackgroundColor3 = Color3.fromRGB(0,0,0)
timerLbl.Text = "Rejoin in: 30:00"
timerLbl.TextColor3 = Color3.fromRGB(255,255,255)
timerLbl.TextScaled = true
timerLbl.Font = Enum.Font.GothamBold

print("🟢 DUSK AUTO FARM - GUI LOADED! Starting farms...")

-- LOAD + START EVERYTHING AUTOMATICALLY
local function loadDusk()
    stat.Text = "Loading Dusk & Shine..."
    loadstring(game:HttpGet("https://raw.githubusercontent.com/fr3dope/DuskAndShine-ADM/main/Loader.lua", true))()
    task.wait(4)
end

local function clickSpawn()
    stat.Text = "🔍 Finding Green Spawn Button..."
    for i=1,30 do
        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("TextButton") and (v.Text:lower():find("spawn") or v.BackgroundColor3 == Color3.fromRGB(0,255,0)) then
                firesignal(v.MouseButton1Click)
                stat.Text = "✅ SPAWN CLICKED!"
                task.wait(0.1)
            end
        end
        task.wait(0.5)
    end
end

local function toggleFarms()
    stat.Text = "✅ TOGGLING PET + BABY FARM ON"
    local farms = {"AutoFarmPet","PetFarm","FarmPet","AutoFarmBaby","BabyFarm","FarmBaby"}
    for i=1,5 do
        for _,k in pairs(farms) do
            if _G[k] ~= nil then _G[k] = true end
            if getgenv and getgenv()[k] then getgenv()[k] = true end
        end
        task.wait(0.5)
    end
end

-- AUTO START SEQUENCE
spawn(function()
    loadDusk()
    task.wait(3)
    clickSpawn()
    task.wait(2)
    toggleFarms()
    stat.Text = "🚀 PET + BABY FARMING ACTIVE!"
end)

-- REJOIN TIMER
local timeElapsed = 0
RS
