-- [[ CONFIGURATION - PREMIUM VERSION ]] --
local Client_ServiceID = "nexithub"

local function LoadPremiumHub()
    print("💎 [NEXIT PREMIUM] Loading Premium Hub...")
    -- loadstring(game:HttpGet("URL_PREMIUM_HUB_HERE"))()
end

-- [[ API SECTION ]] --
local BaseURL = "https://new.pandadevelopment.net/api/v1"
local function getHardwareId()
    local success, hwid = pcall(gethwid)
    if success and hwid then return hwid end
    return tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-", "")
end

local function ValidatePremium(key)
    local HttpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return request({
            Url = BaseURL .. "/keys/validate",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                ServiceID = Client_ServiceID,
                HWID = getHardwareId(),
                Key = key
            })
        })
    end)
    if success and response.Body then
        local res = HttpService:JSONDecode(response.Body)
        -- ต้องผ่านการยืนยัน และ API ต้องยืนยันว่าเป็น Premium เท่านั้น
        if res.Authenticated_Status == "Success" and res.Key_Premium then
            return true
        end
    end
    return false
end

-- [[ PREMIUM LOGIC - NO UI / NO SAVE ]] --
local inputKey = _G.Key
_G.Key = nil -- Clear ทันทีเพื่อความปลอดภัย

if inputKey and inputKey ~= "" then
    print("[NEXIT] Validating Premium key...")
    if ValidatePremium(inputKey) then
        LoadPremiumHub()
    else
        warn("❌ [NEXIT] Premium Key is invalid or not a Premium type!")
    end
else
    warn("⚠️ [NEXIT] Please provide key: _G.Premium = 'your_key' before executing.")
end