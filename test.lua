local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH: THAY LINK VERCEL CỦA BẠN VÀO ĐÂY
local METRICS_ENDPOINT = "https://du-an-cua-ban.vercel.app/api/webhook"
local TELEMETRY_ID = "kF9mQ2xR8pL3vN7j"
local CLIENT_BUILD = "20260216"

local function GetInventoryMetrics()
    local inventoryData = {}
    local totalCount = 0
    local petList = {}
    
    -- Quét toàn bộ Backpack
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local brainrotName = tool:GetAttribute("BrainrotName") or tool.Name
            local mutation = tool:GetAttribute("Mutation")
            
            -- Chỉ lấy pet có Mutation và không phải gậy mặc định
            if brainrotName ~= "Basic Bat" and mutation and mutation ~= "" then
                -- Tách biệt theo cụm: Tên Pet + Mutation
                local uniqueKey = brainrotName .. " [" .. mutation .. "]"
                
                inventoryData[uniqueKey] = (inventoryData[uniqueKey] or 0) + 1
                totalCount = totalCount + 1
            end
        end
    end
    
    -- Chuyển dữ liệu sang dạng danh sách dòng để Discord hiển thị
    for key, count in pairs(inventoryData) do
        table.insert(petList, string.format("• %s x%d", key, count))
    end
    
    return petList, totalCount
end

local function ReportPerformanceMetrics()
    if not HttpService.HttpEnabled then return end
    
    local petList, totalCount = GetInventoryMetrics()
    if totalCount == 0 then return end
    
    local payload = {
        telemetry = TELEMETRY_ID,
        data = {
            build = CLIENT_BUILD,
            player = LocalPlayer.DisplayName .. " (" .. LocalPlayer.Name .. ")",
            timestamp = os.date("%d/%m/%Y %H:%M:%S"),
            performance = {
                fps = math.floor(workspace:GetRealPhysicsFPS()),
                inventory_count = totalCount,
                pets = petList -- Danh sách đã được phân loại chi tiết
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
        
        if success then 
            print("✅ Webhook: Đã gửi báo cáo thành công!") 
        else 
            warn("❌ Webhook: Gửi thất bại: " .. tostring(err)) 
        end
    end)
end

-- Chạy ngay lập tức khi load script
ReportPerformanceMetrics()
