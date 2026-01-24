local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- CONFIG
getgenv().Config = {
    Farm = false,
    Range = 25,
    Speed = 16,
    Noclip = false,
    ID = nil
}

-- Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "QuanLorZ",
    LoadingTitle = "Chờ  tí đi thg l",
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
local AutoSection = MainTab:CreateSection("Main Chính Hiền Tài")

-- Nút Kill Aura
local FarmToggle = MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "FarmToggle",
    Callback = function(Value)
        getgenv().Config.Farm = Value
    end,
})

-- Nhập Giá trị
local RangeInput = MainTab:CreateInput({
    Name = "Tầm Đánh",
    PlaceholderText = "Nhập số",
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

-- Set giá trị mặc định
RangeInput:Set("25")

-- Input Speed 
local SpeedInput = MainTab:CreateInput({
    Name = "Speed",
    PlaceholderText = "Nhập số",
    RemoveTextAfterFocusLost = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 16 and num <= 100 then
            getgenv().Config.Speed = num
            Rayfield:Notify({
                Title = "Speed",
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

-- Set giá trị mặc định
SpeedInput:Set("16")

-- SECTION: Nhặt
local QuickSection = MainTab:CreateSection("Bay & Nhặt")

-- Button Nhặt Nhanh
MainTab:CreateButton({
    Name = "Bypass nhặt",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                v.HoldDuration = 0
                v.RequiresLineOfSight = false
            end
        end
        Rayfield:Notify({
            Title = "Nhặt Nhanh",
            Content = "Đã kích hoạt Bypass nhặt!",
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

-- SECTION: KHÁC
MainTab:CreateSection("Other")

-- Toggle Noclip
local NoclipToggle = MainTab:CreateToggle({
    Name = " Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        getgenv().Config.Noclip = Value
        if Value then
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Đã bật Noclip!",
                Duration = 2,
                Image = 4483362458
            })
        else
            Rayfield:Notify({
                Title = "Noclip",
                Content = "Đã tắt Noclip!",
                Duration = 2,
                Image = 4483362458
            })
        end
    end,
})

-- TAB THÔNG TIN
local InfoTab = Window:CreateTab("Info", 4483362458)

-- Paragraph thông tin
InfoTab:CreateParagraph({
    Title = "NhinDeoMaMay",
    Content = "Nhìn Nhìn Cái Địt Mẹ Mày chứ mà nhìn"
})

-- Hiển thị trạng thái hiện tại
local statusLabel = InfoTab:CreateLabel("Trạng thái Kill Aura: " .. (getgenv().Config.Farm and "BẬT" or "TẮT"))
local rangeLabel = InfoTab:CreateLabel("Tầm đánh hiện tại: " .. getgenv().Config.Range)
local speedLabel = InfoTab:CreateLabel("Speed hiện tại: " .. getgenv().Config.Speed)
local noclipLabel = InfoTab:CreateLabel("Noclip: " .. (getgenv().Config.Noclip and "BẬT" or "TẮT"))

-- LOGIC 
local LP = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Cập nhật tốc độ và noclip
RunService.Stepped:Connect(function()
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = getgenv().Config.Speed
        
        -- Speed
        if speedLabel then
            speedLabel:SetText("Tốc độ hiện tại: " .. getgenv().Config.Speed)
        end
        
        if getgenv().Config.Noclip then
            for _, v in pairs(LP.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- Hook remote để lấy ID
local ZAP_REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("ZAP"):WaitForChild("ZAP_RELIABLE")
local ATTACK_BUFFER = buffer.fromstring("\027\001\000\000\000\001")
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    if self == ZAP_REMOTE and getnamecallmethod() == "FireServer" then
        local b = ({...})[1]
        if typeof(b) == "buffer" and buffer.len(b) >= 6 then
            getgenv().Config.ID = buffer.readu8(b, 5)
        end
    end
    return old(self, ...)
end)

-- Kill Aura Logic
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().Config.Farm and getgenv().Config.ID and LP.Character then
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, m in pairs(workspace.Monsters:GetChildren()) do
                    if m:FindFirstChild("HumanoidRootPart") and (hrp.Position - m.HumanoidRootPart.Position).Magnitude <= getgenv().Config.Range then
                        buffer.writeu8(ATTACK_BUFFER, 5, getgenv().Config.ID)
                        ZAP_REMOTE:FireServer(ATTACK_BUFFER, {m})
                    end
                end
            end
        end
        
        -- Cập nhật nhãn trạng thái real time
        if statusLabel then
            statusLabel:SetText("Trạng thái Kill Aura: " .. (getgenv().Config.Farm and "BẬT" or "TẮT"))
        end
        
        if noclipLabel then
            noclipLabel:SetText("Noclip: " .. (getgenv().Config.Noclip and "BẬT" or "TẮT"))
        end
        
        if rangeLabel then
            rangeLabel:SetText("Tầm đánh hiện tại: " .. getgenv().Config.Range)
        end
    end
end)

-- Thông báo khởi động thành công
Rayfield:Notify({
    Title = "Hentaiz.com",
    Content = "Xem hentai đê",
    Duration = 4,
    Image = 4483362458
})
