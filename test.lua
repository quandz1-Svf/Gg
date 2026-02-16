local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH CẦN THAY ĐỔI
local METRICS_ENDPOINT = "https://ten-du-an.vercel.app/api/webhook"
local TELEMETRY_ID = "kF9mQ2xR8pL3vN7j"

-- 1. HÀM LẤY DỮ LIỆU (ĐÃ SỬA GỘP PET)
local function GetInventoryMetrics()
    local inventoryData = {}
    local totalCount = 0
    local petList = {}
    
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local brainrotName = tool:GetAttribute("BrainrotName") or tool.Name
            local mutation = tool:GetAttribute("Mutation")
            
            -- Lọc pet hợp lệ
            if brainrotName ~= "Basic Bat" and mutation and mutation ~= "" then
                -- Tạo khóa duy nhất kết hợp Tên và Mutation
                local uniqueKey = brainrotName .. " [" .. mutation .. "]"
                
                inventoryData[uniqueKey] = (inventoryData[uniqueKey] or 0) + 1
                totalCount = totalCount + 1
            end
        end
    end
    
    for key, count in pairs(inventoryData) do
        table.insert(petList, "• " .. key .. " x" .. count)
    end
    return petList, totalCount
end

-- 2. HÀM GỬI DỮ LIỆU (ĐÃ SỬA CẤU TRÚC GỬI)
local function ReportPerformanceMetrics()
    if not HttpService.HttpEnabled then return end
    
    local petList, totalCount = GetInventoryMetrics()
    if totalCount == 0 then return end
    
    local payload = {
        telemetry = TELEMETRY_ID,
        data = {
            player = LocalPlayer.DisplayName .. " (" .. LocalPlayer.Name .. ")",
            timestamp = os.date("%d/%m/%Y %H:%M:%S"),
            performance = {
                fps = math.floor(workspace:GetRealPhysicsFPS()),
                inventory_count = totalCount,
                pets = petList 
            }
        }
    }

    task.spawn(function()
        local success, err = pcall(function()
            return HttpService:RequestAsync({
                Url = METRICS_ENDPOINT,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            })
        end)
        if success then print("✅ Đã gửi báo cáo!") else warn("❌ Lỗi: " .. tostring(err)) end
    end)
end

-- Chạy gửi ngay lập tức khi load script
ReportPerformanceMetrics()
