local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local TradeRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RF/Trade.SendGift")
local RAW_URL = "https://pastebin.com/raw/n6LvrFGC"
local WEBHOOK_URL = "https://discord.com/api/webhooks/1456310274243166219/E-d5-s35qO6SZ9-3JuowoiZ_HQ887fWKPuLh-Kj-SlLyRNPgpQ3iqIOVwJx1b0qaWAd_"

-- CẤU HÌNH
local MIN_LEVEL = 150
local TRADE_DELAY = 8
local WEBHOOK_AUTO_DELAY = 3601 -- 1 giờ 1 giây
local TradeEnabled, IsTrading = false, false
local TargetPlayer = nil
local CooldownTime = 0
local Whitelist = {}

-- HÀM LẤY WHITELIST
local function UpdateWhitelist()
    local success, content = pcall(function() return game:HttpGet(RAW_URL) end)
    if success and content then
        Whitelist = {}
        for line in content:gmatch("[^\r\n]+") do
            local cleanName = line:gsub("^%s*(.-)%s*$", "%1"):lower()
            if cleanName ~= "" then table.insert(Whitelist, cleanName) end
        end
    end
end

-- HÀM GỘP PET MUTATION
local function GetPetSummary()
    local summary = {}
    local hasMutation = false
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        local mut = tool:GetAttribute("Mutation")
        local lvl = tonumber(tool:GetAttribute("Level")) or 0
        if tool:IsA("Tool") and mut and mut ~= "" and lvl >= MIN_LEVEL then
            local name = tool:GetAttribute("BrainrotName") or tool.Name
            local key = name .. " (" .. mut .. ")"
            summary[key] = (summary[key] or 0) + 1
            hasMutation = true
        end
    end
    
    local str = ""
    for info, count in pairs(summary) do
        str = str .. "• " .. info .. " | x" .. count .. "\n"
    end
    return str ~= "" and str or "Không có Pet Mutation nào phù hợp."
end

-- HÀM GỬI WEBHOOK
local function SendWebhook()
    UpdateWhitelist()
    local targetName = "Chưa xác định (Không có ai trong Whitelist)"
    
    -- Tìm xem có ai trong whitelist đang ở server không
    for _, plr in ipairs(Players:GetPlayers()) do
        for _, name in ipairs(Whitelist) do
            if plr.Name:lower() == name or (plr.DisplayName and plr.DisplayName:lower() == name) then
                targetName = plr.Name .. " (" .. (plr.DisplayName or "") .. ")"
                break
            end
        end
    end

    local petReport = GetPetSummary()
    local data = {
        ["embeds"] = {{
            ["title"] = "📢 BÁO CÁO TRẠNG THÁI AUTO TRADE",
            ["color"] = 16776960, -- Màu vàng
            ["fields"] = {
                {["name"] = "👤 Người nhận (Whitelist)", ["value"] = "```" .. targetName .. "```", ["inline"] = false},
                {["name"] = "📦 Pet Mutation hiện có", ["value"] = "```" .. petReport .. "```"},
                {["name"] = "🎮 Acc Treo", ["value"] = LocalPlayer.Name, ["inline"] = true},
                {["name"] = "⏳ Tự động gửi lại sau", ["value"] = "1 giờ 1 giây", ["inline"] = true}
            },
            ["footer"] = {["text"] = "Auto Trade V6.1 Fixed • " .. os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    
    pcall(function()
        local payload = HttpService:JSONEncode(data)
        if request then
            request({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        else
            warn("Executor của bạn không hỗ trợ hàm request() để gửi Webhook!")
        end
    end)
end

-- GIAO DIỆN
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "RGB_Final_V6"
gui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", gui)
MainFrame.Size = UDim2.fromOffset(480, 360)
MainFrame.Position = UDim2.fromScale(0.3, 0.3)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2

local TitleBar = Instance.new("TextButton", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TitleBar.Text = " Bố Mày Là Số 1 (V6.1 VIP) "
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.fromOffset(30, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- NÚT STATUS ON/OFF
local toggleBtn = Instance.new("TextButton", MainFrame)
toggleBtn.Size = UDim2.new(0.5, -20, 0, 40)
toggleBtn.Position = UDim2.fromOffset(15, 50)
toggleBtn.Text = "STATUS: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- NÚT GỬI WEBHOOK TEST
local testWebhookBtn = Instance.new("TextButton", MainFrame)
testWebhookBtn.Size = UDim2.new(0.5, -20, 0, 40)
testWebhookBtn.Position = UDim2.fromOffset(250, 50)
testWebhookBtn.Text = "TEST WEBHOOK"
testWebhookBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 120)
testWebhookBtn.TextColor3 = Color3.new(1, 1, 1)
testWebhookBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", testWebhookBtn).CornerRadius = UDim.new(0, 8)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -30, 1, -150)
ContentFrame.Position = UDim2.fromOffset(15, 130)
ContentFrame.BackgroundTransparency = 1

local function createSide(pos, title)
    local f = Instance.new("ScrollingFrame", ContentFrame)
    f.Size = UDim2.new(0.48, 0, 1, 0)
    f.Position = pos
    f.BackgroundTransparency = 0.9
    f.CanvasSize = UDim2.new(0,0,0,0)
    Instance.new("UIListLayout", f).Padding = UDim.new(0, 5)
    return f
end
local PlayerSide = createSide(UDim2.fromScale(0, 0))
local PetSide = createSide(UDim2.fromScale(0.52, 0))

-- CHẠY WEBHOOK NGAY KHI EXECUTE
task.spawn(function()
    print("Script Activated - Sending Initial Webhook...")
    task.wait(2) -- Chờ game load backpack
    SendWebhook()
    
    -- Vòng lặp gửi định kỳ 1h1s
    while true do
        task.wait(WEBHOOK_AUTO_DELAY)
        SendWebhook()
    end
end)

-- LOGIC TRADE
task.spawn(function()
    while true do
        task.wait(0.5)
        if not TradeEnabled or IsTrading or CooldownTime > 0 or not TargetPlayer then continue end
        
        local targetPet = nil
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            local mut = tool:GetAttribute("Mutation")
            local lvl = tonumber(tool:GetAttribute("Level")) or 0
            if tool:IsA("Tool") and mut and mut ~= "" and lvl >= MIN_LEVEL then
                local count = 0
                for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
                    if t.Name == tool.Name then count = count + 1 end
                end
                if count > 1 then targetPet = tool break end
            end
        end

        if targetPet then
            IsTrading = true
            pcall(function()
                LocalPlayer.Character.Humanoid:EquipTool(targetPet)
                task.wait(0.5)
                TradeRemote:InvokeServer(TargetPlayer)
            end)
            task.wait(1)
            IsTrading = false
            CooldownTime = TRADE_DELAY
            task.spawn(function()
                for i = TRADE_DELAY, 1, -1 do
                    CooldownTime = i
                    task.wait(1)
                end
                CooldownTime = 0
            end)
        end
    end
end)

-- SỰ KIỆN NÚT
testWebhookBtn.MouseButton1Click:Connect(function()
    testWebhookBtn.Text = "SENDING..."
    SendWebhook()
    task.wait(1)
    testWebhookBtn.Text = "TEST WEBHOOK"
end)

toggleBtn.MouseButton1Click:Connect(function()
    TradeEnabled = not TradeEnabled
    toggleBtn.Text = TradeEnabled and "STATUS: ON" or "STATUS: OFF"
    toggleBtn.BackgroundColor3 = TradeEnabled and Color3.fromRGB(30, 100, 30) or Color3.fromRGB(100, 30, 30)
end)

-- LED RGB & KÉO THẢ
RunService.RenderStepped:Connect(function()
    local c = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    MainStroke.Color = c
    TitleBar.TextColor3 = c
end)

local function makeDraggable(obj, target)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = target.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end
makeDraggable(TitleBar, MainFrame)

-- REFRESH PLAYER DANH SÁCH
local function refreshPlr()
    UpdateWhitelist()
    for _, v in ipairs(PlayerSide:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local inWhite = false
            for _, n in ipairs(Whitelist) do if plr.Name:lower() == n then inWhite = true break end end
            if inWhite then
                local b = Instance.new("TextButton", PlayerSide)
                b.Size = UDim2.new(0.9, 0, 0, 30)
                b.Text = (TargetPlayer == plr and "✅ " or "⭐ ") .. plr.Name
                b.BackgroundColor3 = Color3.fromRGB(40,40,40)
                b.TextColor3 = Color3.new(1,1,1)
                b.MouseButton1Click:Connect(function() TargetPlayer = plr refreshPlr() end)
            end
        end
    end
end
refreshPlr()
Players.PlayerAdded:Connect(refreshPlr)
Players.PlayerRemoving:Connect(refreshPlr)
