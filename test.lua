--[[ 
    วิธีใช้งานสำหรับ Premium:
    _G.Premium = "คีย์_พรีเมียม_ของคุณ"
    loadstring(game:HttpGet("ลิงก์สคริปต์นี้"))()
]]

-- [[ CONFIGURATION ]] --
local FileName = "NexitHub_Key.txt"
local Client_ServiceID = "nexithub"

-- ใส่ลิงก์สคริปต์ Hub ของคุณที่นี่
local function LoadPremiumHub()
    print("💎 Loading Premium Hub...")
    -- loadstring(game:HttpGet("URL_SCRIPT_PREMIUM_HERE"))() -- เอาคอมเมนต์ออกแล้วใส่ลิงก์จริง
end

local function LoadFreeHub()
    print("✅ Loading Free Hub...")
    -- loadstring(game:HttpGet("URL_SCRIPT_FREE_HERE"))() -- เอาคอมเมนต์ออกแล้วใส่ลิงก์จริง
end

-- [[ 1. API SECTION ]] --
local BaseURL = "https://new.pandadevelopment.net/api/v1"

local function getHardwareId()
    local success, hwid = pcall(gethwid)
    if success and hwid then return hwid end
    return tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-", "")
end

local function makeRequest(endpoint, body)
    local HttpService = game:GetService("HttpService")
    local success, response = pcall(function()
        return request({
            Url = BaseURL .. endpoint,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(body)
        })
    end)
    if success and response and response.Body then
        return HttpService:JSONDecode(response.Body)
    end
    return nil
end

-- ปรับปรุงฟังก์ชัน Validate ให้รองรับการเช็คพรีเมียม
function Validate(key, RequirePremium)
    local result = makeRequest("/keys/validate", {
        ServiceID = Client_ServiceID,
        HWID = getHardwareId(),
        Key = key
    })
    
    if not result then return {success = false, message = "Connection Error"} end
    
    local isAuthenticated = (result.Authenticated_Status == "Success")
    local isPremium = result.Key_Premium or false
    
    -- ถ้าต้องการเช็คพรีเมียม แต่คีย์ไม่ใช่พรีเมียม ให้ถือว่าไม่ผ่าน
    if RequirePremium and isAuthenticated and not isPremium then
        return {success = false, message = "This key is not Premium", isPremium = false}
    end
    
    return {
        success = isAuthenticated,
        isPremium = isPremium,
        message = result.Note or (isAuthenticated and "Success" or "Invalid Key")
    }
end

-- [[ 2. SAVE/LOAD SYSTEM ]] --
local function SaveKeyLocal(key)
    if writefile then writefile(FileName, key) end
end

local function LoadKeyLocal()
    if isfile and isfile(FileName) then return readfile(FileName) end
    return nil
end

-- [[ 3. AUTOMATIC CHECK (PREMIUM _G & SAVED KEY) ]] --

-- ตรวจสอบจาก _G.Premium เป็นอันดับแรก
if _G.Premium and _G.Premium ~= "" then
    print("Checking Premium Key from _G...")
    local res = Validate(_G.Premium, true) -- true คือบังคับเช็คพรีเมียม
    if res.success and res.isPremium then
        LoadPremiumHub()
        return -- จบการทำงานทันที ไม่เปิด UI
    else
        warn("Premium Key from _G is invalid or not premium: " .. res.message)
    end
end

-- ถ้าไม่มี _G หรือ _G ใช้ไม่ได้ ให้เช็คคีย์ที่เซฟไว้ในเครื่อง (LoadKeyLocal)
local savedKey = LoadKeyLocal()
if savedKey then
    local res = Validate(savedKey, false) -- เช็คแบบปกติ (ได้ทั้งฟรีและพรีเมียม)
    if res.success then
        if res.isPremium then
            LoadPremiumHub()
        else
            LoadFreeHub()
        end
        return -- จบการทำงาน ไม่เปิด UI
    end
end

-- [[ 4. UI SECTION (จะทำงานเมื่อไม่มีคีย์ที่ใช้ได้เลย) ]] --
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local sg = Instance.new("ScreenGui")
sg.Name = "Nexit_Modern_Key"
sg.Parent = (gethui and gethui()) or CoreGui
sg.Enabled = true -- เปิด UI เพราะคีย์ออโต้ไม่ผ่าน

-- สร้าง UI (เหมือนเดิมที่เคยทำไว้)
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 400, 0, 250)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
main.BorderSizePixel = 0
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1
header.Text = "  NEXIT HUB | KEY SYSTEM"
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextSize = 18
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = main

local inputBg = Instance.new("Frame")
inputBg.Size = UDim2.new(0, 340, 0, 45)
inputBg.Position = UDim2.new(0.5, 0, 0.45, 0)
inputBg.AnchorPoint = Vector2.new(0.5, 0.5)
inputBg.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
inputBg.Parent = main
Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0, 8)

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -20, 1, 0)
input.Position = UDim2.new(0, 10, 0, 0)
input.BackgroundTransparency = 1
input.PlaceholderText = "Enter key here..."
input.TextColor3 = Color3.fromRGB(255, 255, 255)
input.Text = ""
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.Parent = inputBg

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0.62, 0)
status.BackgroundTransparency = 1
status.Text = "No valid key found. Please verify."
status.TextColor3 = Color3.fromRGB(120, 120, 130)
status.TextSize = 12
status.Font = Enum.Font.Gotham
status.Parent = main

local btnContainer = Instance.new("Frame")
btnContainer.Size = UDim2.new(0, 340, 0, 40)
btnContainer.Position = UDim2.new(0.5, 0, 0.8, 0)
btnContainer.AnchorPoint = Vector2.new(0.5, 0.5)
btnContainer.BackgroundTransparency = 1
btnContainer.Parent = main
local uiList = Instance.new("UIListLayout")
uiList.FillDirection = Enum.FillDirection.Horizontal
uiList.Padding = UDim.new(0, 10)
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.Parent = btnContainer

local function createBtn(text, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 165, 1, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = btnContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local getLinkBtn = createBtn("Get Key", Color3.fromRGB(40, 40, 45))
local verifyBtn = createBtn("Verify Key", Color3.fromRGB(80, 50, 200))

-- [[ 5. UI BUTTON LOGIC ]] --

getLinkBtn.MouseButton1Click:Connect(function()
    local url = "https://new.pandadevelopment.net/getkey/" .. Client_ServiceID .. "?hwid=" .. getHardwareId()
    if setclipboard then setclipboard(url) end
    status.Text = "Link copied!"
    status.TextColor3 = Color3.fromRGB(100, 180, 255)
end)

verifyBtn.MouseButton1Click:Connect(function()
    local key = input.Text
    if key == "" then return end
    
    status.Text = "Verifying..."
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    local res = Validate(key, false)
    if res.success then
        SaveKeyLocal(key)
        status.Text = "Success! Loading..."
        status.TextColor3 = Color3.fromRGB(100, 255, 150)
        task.wait(1)
        sg:Destroy()
        
        if res.isPremium then
            LoadPremiumHub()
        else
            LoadFreeHub()
        end
    else
        status.Text = res.message
        status.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)