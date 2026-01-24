local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- CONFIG
getgenv().Config = {
    Farm = false,
    Range = 25,
    Speed = 16,
    Noclip = false,
    SavedID = nil,
    AttackSpeed = 0.1,
    AutoHit = false, -- Thêm Kill Aura
    AutoHitInterval = 1 -- Thêm Interval cho Auto Hit
}

-- Khởi tạo Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "QUANLORZ",
    LoadingTitle = "đang khởi động...",
    LoadingSubtitle = "by Quan",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- TAB CHÍNH
local MainTab = Window:CreateTab("Main", 4483362458)

-- SECTION: TỰ ĐỘNG
local AutoSection = MainTab:CreateSection("Main")

-- Toggle Auto Attack
local FarmToggle = MainTab:CreateToggle({
    Name = "kill Aura",
    CurrentValue = false,
    Flag = "FarmToggle",
    Callback = function(Value)
        getgenv().Config.Farm = Value
        Rayfield:Notify({
            Title = "Auto Farm",
            Content = Value and "Đã bật Kill Aura" or "Đã tắt Kill Aura",
            Duration = 2,
            Image = 4483362458
        })
    end,
})

-- Toggle Auto Hit
local AutoHitToggle = MainTab:CreateToggle({
    Name = "Auto Sửa cửa",
    CurrentValue = false,
    Flag = "AutoHitToggle",
    Callback = function(Value)
        getgenv().Config.AutoHit = Value
        Rayfield:Notify({
            Title = "Auto Sửa Cửa",
            Content = Value and "Đã bật Auto Sửa Cuaqr" or "Đã tắt Auto Sửa Cửa",
            Duration = 2,
            Image = 4483362458
        })
    end,
})

-- Input Range
local RangeInput = MainTab:CreateInput({
    Name = "Tầm Đánh",
    PlaceholderText = "Nhập số...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 1 and num <= 100 then
            getgenv().Config.Range = num
            Rayfield:Notify({
                Title = "Tầm Đánh",
                Content = "Đã đặt tầm đánh: " .. num,
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Vui lòng nhập số từ 1 đến 100",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})
RangeInput:Set("25")

-- Input Speed
local SpeedInput = MainTab:CreateInput({
    Name = "Tốc Độ Di Chuyển",
    PlaceholderText = "Nhập số...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 16 and num <= 100 then
            getgenv().Config.Speed = num
            Rayfield:Notify({
                Title = "Tốc Độ",
                Content = "Đã đặt tốc độ: " .. num,
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Vui lòng nhập số từ 16 đến 100",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})
SpeedInput:Set("16")

-- Input Attack Speed
local AttackSpeedInput = MainTab:CreateInput({
    Name = "Tốc Độ Tấn Công",
    PlaceholderText = "0.1",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 and num <= 1 then
            getgenv().Config.AttackSpeed = num
            Rayfield:Notify({
                Title = "Tốc Độ Tấn Công",
                Content = "Đã đặt: " .. num .. " giây",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Vui lòng nhập số từ 0.01 đến 1",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})
AttackSpeedInput:Set("0.1")

-- Input Auto Hit Interval
local AutoHitIntervalInput = MainTab:CreateInput({
    Name = "Auto Hit Interval",
    PlaceholderText = "1",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num > 0 and num <= 5 then
            getgenv().Config.AutoHitInterval = num
            Rayfield:Notify({
                Title = "Tốc Độ Sửa cửa",
                Content = "Đã đặt: " .. num .. " giây",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Lỗi",
                Content = "Vui lòng nhập số từ 0.1 đến 5",
                Duration = 3,
                Image = 4483362458
            })
        end
    end,
})
AutoHitIntervalInput:Set("1")

-- SECTION: instan click
local QuickSection = MainTab:CreateSection("Ông Chồng Bất Lực :V")

-- Button Bỏ qua thời gian chờ
MainTab:CreateButton({
    Name = "Instant Click",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                v.RequiresLineOfSight = false
            end
        end
        Rayfield:Notify({
            Title = "Instant Click",
            Content = "Đã kích Instant Click!",
            Duration = 2,
            Image = 4483362458
        })
    end,
})

-- Button Mở FlyGuiV3
MainTab:CreateButton({
    Name = "Mở FlyGuiV3",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
        Rayfield:Notify({
            Title = "Fly Gui V3",
            Content = "Đang tải FlyGuiV3...",
            Duration = 3,
            Image = 4483362458
        })
    end,
})

-- SECTION: Other
MainTab:CreateSection("Other")

-- Toggle Noclip
local NoclipToggle = MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        getgenv().Config.Noclip = Value
        Rayfield:Notify({
            Title = "Noclip",
            Content = Value and "Noclip!" or "Đã tắt Noclip!",
            Duration = 2,
            Image = 4483362458
        })
    end,
})

-- TAB THÔNG TIN
local InfoTab = Window:CreateTab("Info", 4483362458)

InfoTab:CreateParagraph({
    Title = "MainChinhHentai",
    Content = "Đánh quái 1 cái để bật kill aura"
})

-- Hiển thị trạng thái hiện tại
local statusLabel = InfoTab:CreateLabel("Trạng thái Kill Aura: TẮT")
local autoHitLabel = InfoTab:CreateLabel("Auto Sửa Cửa: TẮT")
local rangeLabel = InfoTab:CreateLabel("Tầm đánh hiện tại: 25")
local speedLabel = InfoTab:CreateLabel("Tốc độ di chuyển: 16")
local attackSpeedLabel = InfoTab:CreateLabel("Tốc độ Kill Aura: 0.1s")
local noclipLabel = InfoTab:CreateLabel("Noclip: TẮT")
local intervalLabel = InfoTab:CreateLabel("Tốc Độ Sửa Cửa: 1s")

-- LOGIC HỆ THỐNG 
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local ZAP_REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("ZAP"):WaitForChild("ZAP_RELIABLE")
local MONSTERS = game.Workspace:WaitForChild("Monsters")
local Defenses = workspace:WaitForChild("Defenses")
local ATTACK_BUFFER = buffer.fromstring("\027\001\000\000\000\001")

-- Tốc độ và Noclip
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = getgenv().Config.Speed
        if getgenv().Config.Noclip then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

-- Lấy ID Vũ Khí
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    if self == ZAP_REMOTE and getnamecallmethod() == "FireServer" then
        local b = args[1]
        if typeof(b) == "buffer" and buffer.readu8(b, 0) == 27 then
            local weaponID = buffer.readu8(b, 5)
            if getgenv().Config.SavedID ~= weaponID then
                getgenv().Config.SavedID = weaponID
                buffer.writeu8(ATTACK_BUFFER, 5, weaponID)
            end
        end
    end
    return oldNamecall(self, ...)
end)

-- Vòng lặp Farm 
local lastAttack = 0
RunService.Heartbeat:Connect(function()
    if not getgenv().Config.Farm or not getgenv().Config.SavedID then return end
    if tick() - lastAttack < getgenv().Config.AttackSpeed then return end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targets = {}
    for _, monster in pairs(MONSTERS:GetChildren()) do
        if monster:IsA("Model") and monster:FindFirstChild("HumanoidRootPart") then
            local hum = monster:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (hrp.Position - monster.HumanoidRootPart.Position).Magnitude
                if dist <= getgenv().Config.Range then
                    table.insert(targets, monster)
                end
            end
        end
    end

    if #targets > 0 then
        lastAttack = tick()
        ZAP_REMOTE:FireServer(ATTACK_BUFFER, targets) -- Gửi 1 lần cho tất cả
    end
end)

-- LOGIC AUTO Sửa cửa
local ACTIVE_SLOT = 1
local lastAutoHit = 0

local function hit(target)
    ZAP_REMOTE:FireServer(
        buffer.fromstring("\031\001"),
        {{
            defenses = { target },
            activeSlot = ACTIVE_SLOT
        }}
    )
end

local function getAllTargets()
    local list = {}
    for _, v in ipairs(Defenses:GetDescendants()) do
        if v.Name == "Barrier" or v.Name == "Door" then
            table.insert(list, v)
        end
    end
    return list
end

RunService.Heartbeat:Connect(function()
    if not getgenv().Config.AutoHit then return end
    if tick() - lastAutoHit < getgenv().Config.AutoHitInterval then return end
    
    local targets = getAllTargets()
    if #targets > 0 then
        lastAutoHit = tick()
        for _, obj in ipairs(targets) do
            task.spawn(function()
                hit(obj)
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        statusLabel:SetText("Kill Aura: " .. (getgenv().Config.Farm and "BẬT" or "TẮT"))
        autoHitLabel:SetText("Auto Hit Barrier/Door: " .. (getgenv().Config.AutoHit and "BẬT" or "TẮT"))
        noclipLabel:SetText("Noclip: " .. (getgenv().Config.Noclip and "BẬT" or "TẮT"))
        rangeLabel:SetText("Tầm đánh hiện tại: " .. getgenv().Config.Range)
        speedLabel:SetText("Tốc độ di chuyển: " .. getgenv().Config.Speed)
        attackSpeedLabel:SetText("Tốc độ tấn công: " .. getgenv().Config.AttackSpeed .. "s")
        intervalLabel:SetText("Auto Hit Interval: " .. getgenv().Config.AutoHitInterval .. "s")
    end
end)

Rayfield:Notify({
    Title = "QuanLorZ",
    Content = ".",
    Duration = 4,
    Image = 4483362458
})