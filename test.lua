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

-- [[ 3. UI CREATOR FUNCTION ]] --
local function ShowKeyUI(initialMessage, initialKey)
    local CoreGui = game:GetService("CoreGui")
    local sg = Instance.new("ScreenGui")
    sg.Name = "Nexit_Modern_Key"
    sg.Parent = (gethui and gethui()) or CoreGui
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 400, 0, 250)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
    main.BorderSizePixel = 0
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", main).Color = Color3.fromRGB(45, 45, 50)

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
    input.Text = initialKey or ""
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = inputBg

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 20)
    status.Position = UDim2.new(0, 0, 0.62, 0)
    status.BackgroundTransparency = 1
    status.Text = initialMessage or "Please verify your key"
    status.TextColor3 = (initialMessage and Color3.fromRGB(255, 100, 100)) or Color3.fromRGB(120, 120, 130)
    status.TextSize = 12
    status.Font = Enum.Font.Gotham
    status.Parent = main

    local btnContainer = Instance.new("Frame")
    btnContainer.Size = UDim2.new(0, 340, 0, 40)
    btnContainer.Position = UDim2.new(0.5, 0, 0.8, 0)
    btnContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    btnContainer.BackgroundTransparency = 1
    btnContainer.Parent = main
    Instance.new("UIListLayout", btnContainer).FillDirection = Enum.FillDirection.Horizontal
    btnContainer.UIListLayout.Padding = UDim.new(0, 10)
    btnContainer.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

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

    getLinkBtn.MouseButton1Click:Connect(function()
        local url = "https://new.pandadevelopment.net/getkey/" .. Client_ServiceID .. "?hwid=" .. getHardwareId()
        if setclipboard then setclipboard(url) end
        status.Text = "Link copied!"
        status.TextColor3 = Color3.fromRGB(100, 180, 255)
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        local key = input.Text
        if key == "" then return end
        status.Text = "Checking..."
        local res = Validate(key, false)
        if res.success then
            if writefile then writefile(FileName, key) end
            status.Text = "Success! Loading..."
            status.TextColor3 = Color3.fromRGB(100, 255, 150)
            task.wait(1)
            sg:Destroy()
            if res.isPremium then LoadPremiumHub() else LoadFreeHub() end
        else
            status.Text = res.message
            status.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end

-- [[ 4. MAIN LOGIC ]] --

local function Initialize()
    -- 1. ถ้ามีการระบุ _G.Premium (ให้เช็คอันนี้ก่อนและ "ห้าม" ข้ามไปเช็คไฟล์เก่า)
    if _G.Premium and _G.Premium ~= "" then
        print("[NEXIT] Validating provided Premium Key...")
        local res = Validate(_G.Premium, true)
        if res.success and res.isPremium then
            if writefile then writefile(FileName, _G.Premium) end
            LoadPremiumHub()
            return -- จบการทำงาน (สำเร็จ)
        else
            -- ถ้าคีย์ใน _G ผิด ให้เปิด UI ทันที และหยุดการเช็คไฟล์อัตโนมัติ
            warn("❌ [NEXIT] Key in _G.Premium is invalid: " .. res.message)
            local failMsg = "Premium Key Error: " .. res.message
            local currentKey = _G.Premium
            _G.Premium = nil -- ล้างค่าเพื่อไม่ให้ค้างในหน่วยความจำ
            ShowKeyUI(failMsg, currentKey) 
            return -- จบการทำงาน (เพื่อให้ผู้ใช้แก้ใน UI)
        end
    end

    -- 2. ถ้าไม่ได้ใส่ _G.Premium มา ให้เช็คคีย์ที่เซฟไว้ในไฟล์
    local savedKey = (isfile and isfile(FileName)) and readfile(FileName)
    if savedKey and savedKey ~= "" then
        print("[NEXIT] Checking saved key from device...")
        local res = Validate(savedKey, false)
        if res.success then
            if res.isPremium then LoadPremiumHub() else LoadFreeHub() end
            return -- จบการทำงาน (สำเร็จ)
        else
            print("[NEXIT] Saved key has expired.")
        end
    end

    -- 3. ถ้าไม่มีอะไรผ่านเลย เปิด UI ปกติ
    ShowKeyUI()
end

Initialize()