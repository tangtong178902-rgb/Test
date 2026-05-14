-- [[ CONFIGURATION ]] --
local FileName = "NexitHub_Key.txt"
local Client_ServiceID = "nexithub"

-- [[ 1. HUB LOADERS ]] --
local function LoadPremiumHub()
    print("💎 [NEXIT] Loading Premium Hub...")
    -- loadstring(game:HttpGet("URL_PREMIUM"))()
end

local function LoadFreeHub()
    print("✅ [NEXIT] Loading Free Hub...")
    -- loadstring(game:HttpGet("URL_FREE"))()
end

-- [[ 2. API SECTION ]] --
local BaseURL = "https://new.pandadevelopment.net/api/v1"

local function getHardwareId()
    local success, hwid = pcall(gethwid)
    if success and hwid then return hwid end
    return tostring(game:GetService("RbxAnalyticsService"):GetClientId()):gsub("-", "")
end

local function Validate(key, RequirePremium)
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
    
    if not success or not response.Body then return {success = false, message = "Connection Error"} end
    local result = HttpService:JSONDecode(response.Body)
    
    local isAuthenticated = (result.Authenticated_Status == "Success")
    local isPremium = result.Key_Premium or false
    
    if RequirePremium and isAuthenticated and not isPremium then
        return {success = false, message = "Not a Premium Key", isPremium = false}
    end
    
    return {
        success = isAuthenticated,
        isPremium = isPremium,
        message = result.Note or (isAuthenticated and "Success" or "Invalid Key")
    }
end

-- [[ 3. MODERN UI ]] --
local function ShowKeyUI()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "Nexit_Ultra_Key"
    sg.Parent = (gethui and gethui()) or CoreGui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 260)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    main.BorderSizePixel = 0
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Thickness = 1.5
    mainStroke.Color = Color3.fromRGB(80, 50, 220)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundTransparency = 1
    title.Text = "NEXIT HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = main

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 350, 0, 45)
    inputFrame.Position = UDim2.new(0.5, 0, 0.48, 0)
    inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    inputFrame.Parent = main
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 10)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.PlaceholderText = "Enter free key..."
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = inputFrame

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0.62, 0)
    status.BackgroundTransparency = 1
    status.Text = "Status: Awaiting verification"
    status.TextColor3 = Color3.fromRGB(120, 120, 140)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = main

    local function createBtn(text, pos, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 170, 0, 42)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.Parent = main
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        return btn
    end

    local getBtn = createBtn("GET KEY", UDim2.new(0.5, -175, 0.82, 0), Color3.fromRGB(30, 30, 35))
    local verifyBtn = createBtn("VERIFY", UDim2.new(0.5, 5, 0.82, 0), Color3.fromRGB(80, 50, 220))

    verifyBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then return end
        
        -- ป้องกันการเอาคีย์ Premium มาใส่ใน UI
        if key:find("NEXIT-") then
            status.Text = "Error: Use _G.Premium for this key!"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end

        status.Text = "Verifying..."
        local res = Validate(key, false)
        if res.success then
            if writefile then writefile(FileName, key) end
            status.Text = "Success!"
            task.wait(1)
            sg:Destroy()
            if res.isPremium then LoadPremiumHub() else LoadFreeHub() end
        else
            status.Text = "Failed: " .. res.message
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    getBtn.MouseButton1Click:Connect(function()
        local url = "https://new.pandadevelopment.net/getkey/" .. Client_ServiceID .. "?hwid=" .. getHardwareId()
        if setclipboard then setclipboard(url) end
        status.Text = "Link copied!"
    end)
end

-- [[ 4. MAIN INITIALIZE ]] --

local function Initialize()
    local inputKey = _G.Premium
    _G.Premium = nil -- ล้างค่าทันทีเพื่อป้องกันการ Execute ซ้ำแล้วบัค

    -- 1. เช็คจาก _G.Premium (ถ้าใส่มา)
    if inputKey and inputKey ~= "" then
        print("[NEXIT] Validating Premium Key...")
        local res = Validate(inputKey, true)
        if res.success and res.isPremium then
            -- สำคัญ: ต้องบันทึกลงไฟล์ด้วย เพื่อให้ครั้งหน้า Execute แค่ loadstring ได้
            if writefile then writefile(FileName, inputKey) end 
            LoadPremiumHub()
            return
        else
            -- ถ้าพรีเมียมผิด ให้ด่าใน Console และหยุดทำงาน (ไม่เปิด UI)
            warn("❌ [NEXIT PREMIUM FAIL]: " .. res.message)
            return 
        end
    end

    -- 2. เช็คจากไฟล์เซฟ (สำหรับ Auto-login)
    local savedKey = (isfile and isfile(FileName)) and readfile(FileName)
    if savedKey and savedKey ~= "" then
        print("[NEXIT] Checking saved key...")
        local res = Validate(savedKey, false)
        if res.success then
            if res.isPremium then LoadPremiumHub() else LoadFreeHub() end
            return
        end
    end

    -- 3. ถ้าไม่มีอะไรผ่านเลย ค่อยเปิด UI
    ShowKeyUI()
end

Initialize()