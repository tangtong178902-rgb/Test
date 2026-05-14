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

-- [[ 3. NEW ULTRA MODERN UI ]] --
local function ShowKeyUI()
    local TweenService = game:GetService("TweenService")
    local CoreGui = game:GetService("CoreGui")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "Nexit_Ultra_Key"
    sg.Parent = (gethui and gethui()) or CoreGui
    
    -- Main Container
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 260)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    main.BorderSizePixel = 0
    main.Parent = sg
    
    local mainCorner = Instance.new("UICorner", main)
    mainCorner.CornerRadius = UDim.new(0, 15)
    
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Thickness = 1.5
    mainStroke.Color = Color3.fromRGB(60, 30, 150) -- ม่วงนีออน
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- Background Gradient
    local grad = Instance.new("UIGradient", main)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 12))
    })
    grad.Rotation = 45

    -- Title Section
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundTransparency = 1
    title.Text = "NEXIT HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.Font = Enum.Font.GothamBold
    title.Parent = main

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 45)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "SECURE VERIFICATION SYSTEM"
    subtitle.TextColor3 = Color3.fromRGB(100, 100, 120)
    subtitle.TextSize = 10
    subtitle.Font = Enum.Font.GothamBold
    subtitle.Parent = main

    -- Input Box
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0, 350, 0, 45)
    inputFrame.Position = UDim2.new(0.5, 0, 0.48, 0)
    inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    inputFrame.Parent = main
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 10)
    local inputStroke = Instance.new("UIStroke", inputFrame)
    inputStroke.Color = Color3.fromRGB(40, 40, 50)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.PlaceholderText = "Enter verification key..."
    input.PlaceholderColor3 = Color3.fromRGB(70, 70, 80)
    input.Text = ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = inputFrame

    -- Status Text
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0.62, 0)
    status.BackgroundTransparency = 1
    status.Text = "Status: Waiting for verification"
    status.TextColor3 = Color3.fromRGB(120, 120, 140)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = main

    -- Buttons
    local function createBtn(text, pos, color, icon)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 170, 0, 42)
        btn.Position = pos
        btn.BackgroundColor3 = color
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 13
        btn.AutoButtonColor = false
        btn.Parent = main
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = color:Lerp(Color3.new(1,1,1), 0.1)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = color}):Play()
        end)
        
        return btn
    end

    local getBtn = createBtn("GET KEY", UDim2.new(0.5, -175, 0.82, 0), Color3.fromRGB(30, 30, 35))
    local verifyBtn = createBtn("VERIFY", UDim2.new(0.5, 5, 0.82, 0), Color3.fromRGB(70, 40, 180))

    -- Logic
    getBtn.MouseButton1Click:Connect(function()
        local url = "https://new.pandadevelopment.net/getkey/" .. Client_ServiceID .. "?hwid=" .. getHardwareId()
        if setclipboard then setclipboard(url) end
        status.Text = "Link copied to clipboard!"
        status.TextColor3 = Color3.fromRGB(100, 200, 255)
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then return end
        
        -- ป้องกันการเอาคีย์ Premium มาใส่ใน UI
        if key:match("^NEXIT%-") then
            status.Text = "Error: Premium keys must use script!"
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
            input.Text = ""
            return
        end

        status.Text = "Checking key..."
        status.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        local res = Validate(key, false)
        if res.success then
            if writefile then writefile(FileName, key) end
            status.Text = "Access Granted! Loading..."
            status.TextColor3 = Color3.fromRGB(100, 255, 150)
            mainStroke.Color = Color3.fromRGB(100, 255, 150)
            task.wait(1)
            sg:Destroy()
            if res.isPremium then LoadPremiumHub() else LoadFreeHub() end
        else
            status.Text = "Failed: " .. res.message
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

-- [[ 4. MAIN INITIALIZE ]] --

local function Initialize()
    local inputKey = _G.Premium
    _G.Premium = nil -- ล้างทันที

    -- 1. ถ้าใส่ _G.Premium มา
    if inputKey and inputKey ~= "" then
        print("[NEXIT] Validating Premium Key from Script...")
        local res = Validate(inputKey, true)
        if res.success and res.isPremium then
            LoadPremiumHub()
            return -- จบการทำงาน (ไม่ขึ้น UI)
        else
            -- แจ้งเตือนใน Console ว่าคีย์ผิด แล้วหยุดเลย (ตามคำขอ: ไม่เปิด UI)
            warn("❌ [NEXIT PREMIUM FAIL]: " .. res.message)
            return 
        end
    end

    -- 2. ถ้าไม่มี _G ให้เช็คไฟล์เซฟ (สำหรับคีย์ฟรี/คีย์ทั่วไป)
    local savedKey = (isfile and isfile(FileName)) and readfile(FileName)
    if savedKey and savedKey ~= "" then
        -- ตรวจสอบว่าคีย์ในไฟล์เป็น Premium หรือไม่ (ถ้าเป็น ให้เช็คผ่าน แต่ถ้าไม่ใช่ให้เช็คปกติ)
        local res = Validate(savedKey, false)
        if res.success then
            if res.isPremium then LoadPremiumHub() else LoadFreeHub() end
            return -- จบการทำงาน
        end
    end

    -- 3. ถ้าไม่มีคีย์ไหนใช้ได้เลย ค่อยเปิด UI
    ShowKeyUI()
end

Initialize()