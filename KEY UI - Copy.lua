local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]"then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]"then break end;if as~=","then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}"then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":"then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}"then break end;if as~=","then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! platoboost library

--! configuration
local service = 24726;  -- your service id, this is used to identify your service.
local secret = "8944cc73-1740-4469-81f8-5f3a9c1cd725";  -- make sure to obfuscate this if you want to ensure security.
local useNonce = true;  -- use a nonce to prevent replay attacks and request tampering.

--! callbacks
local onMessage = function(message) end;

--! wait for game to load
repeat task.wait(1) until game:IsLoaded();

--! functions
local requestSending = false;
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return game:GetService("Players").LocalPlayer.UserId end
local cachedLink, cachedTime = "", 0;

--! pick host
local host = "https://api.platoboost.com";
local hostResponse = fRequest({
    Url = host .. "/public/connectivity",
    Method = "GET"
});
if hostResponse.StatusCode ~= 200 or hostResponse.StatusCode ~= 429 then
    host = "https://api.platoboost.net";
end

--!optimize 2
function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local response = fRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({
                service = service,
                identifier = lDigest(fGetHwid())
            }),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        });

        if response.StatusCode == 200 then
            local decoded = lDecode(response.Body);

            if decoded.success == true then
                cachedLink = decoded.data.url;
                cachedTime = fOsTime();
                return true, cachedLink;
            else
                onMessage(decoded.message);
                return false, decoded.message;
            end
        elseif response.StatusCode == 429 then
            local msg = "you are being rate limited, please wait 20 seconds and try again.";
            onMessage(msg);
            return false, msg;
        end

        local msg = "Failed to cache link.";
        onMessage(msg);
        return false, msg;
    else
        return true, cachedLink;
    end
end

cacheLink();

--!optimize 2
local generateNonce = function()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

--!optimize 1
for _ = 1, 5 do
    local oNonce = generateNonce();
    task.wait(0.2)
    if generateNonce() == oNonce then
        local msg = "platoboost nonce error.";
        onMessage(msg);
        error(msg);
    end
end

--!optimize 2
local copyLink = function()
    local success, link = cacheLink();
    
    if success then
        fSetClipboard(link);
    end
end

--!optimize 2
local redeemKey = function(key)
    local nonce = generateNonce();
    local endpoint = host .. "/public/redeem/" .. fToString(service);

    local body = {
        identifier = lDigest(fGetHwid()),
        key = key
    }

    if useNonce then
        body.nonce = nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "POST",
        Body = lEncode(body),
        Headers = {
            ["Content-Type"] = "application/json"
        }
    });

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                        return true;
                    else
                        onMessage("failed to verify integrity.");
                        return false;
                    end    
                else
                    return true;
                end
            else
                onMessage("key is invalid.");
                return false;
            end
        else
            if fStringSub(decoded.message, 1, 27) == "unique constraint violation" then
                onMessage("you already have an active key, please wait for it to expire before redeeming it.");
                return false;
            else
                onMessage(decoded.message);
                return false;
            end
        end
    elseif response.StatusCode == 429 then
        onMessage("you are being rate limited, please wait 20 seconds and try again.");
        return false;
    else
        onMessage("server returned an invalid status code, please try again later.");
        return false; 
    end
end

--!optimize 2
local verifyKey = function(key)
    if requestSending == true then
        onMessage("a request is already being sent, please slow down.");
        return false;
    else
        requestSending = true;
    end

    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(fGetHwid()) .. "&key=" .. key;

    if useNonce then
        endpoint = endpoint .. "&nonce=" .. nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "GET",
    });

    requestSending = false;

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true then
            if decoded.data.valid == true then
                if useNonce then
                    if decoded.data.hash == lDigest("true" .. "-" .. nonce .. "-" .. secret) then
                        return true;
                    else
                        onMessage("failed to verify integrity.");
                        return false;
                    end
                else
                    return true;
                end
            else
                if fStringSub(key, 1, 4) == "KEY_" then
                    return redeemKey(key);
                else
                    onMessage("key is invalid.");
                    return false;
                end
            end
        else
            onMessage(decoded.message);
            return false;
        end
    elseif response.StatusCode == 429 then
        onMessage("you are being rate limited, please wait 20 seconds and try again.");
        return false;
    else
        onMessage("server returned an invalid status code, please try again later.");
        return false;
    end
end

--!optimize 2
local getFlag = function(name)
    local nonce = generateNonce();
    local endpoint = host .. "/public/flag/" .. fToString(service) .. "?name=" .. name;

    if useNonce then
        endpoint = endpoint .. "&nonce=" .. nonce;
    end

    local response = fRequest({
        Url = endpoint,
        Method = "GET",
    });

    if response.StatusCode == 200 then
        local decoded = lDecode(response.Body);

        if decoded.success == true then
            if useNonce then
                if decoded.data.hash == lDigest(fToString(decoded.data.value) .. "-" .. nonce .. "-" .. secret) then
                    return decoded.data.value;
                else
                    onMessage("failed to verify integrity.");
                    return nil;
                end
            else
                return decoded.data.value;
            end
        else
            onMessage(decoded.message);
            return nil;
        end
    else
        return nil;
    end
end

-- 1. ตั้งค่าไฟล์
local fileName = "nexithub-key.txt"
local expireTime = 86400 -- 24 ชั่วโมง

-- 2. ฟังก์ชันเซฟและเช็คไฟล์ (ต้องอยู่บนสุด)
local function saveKey(key)
    local data = key .. ":" .. tostring(os.time())
    writefile(fileName, data)
end

local function getSavedKey()
    if isfile(fileName) then
        local content = readfile(fileName)
        local split = string.split(content, ":")
        if split[1] and split[2] then
            if os.time() - tonumber(split[2]) < expireTime then
                return split[1]
            end
        end
    end
    return nil
end

-- 3. ตรวจสอบ Key ทันที (Skip UI Logic)
local savedKey = getSavedKey()
if savedKey then
    -- เรียกฟังก์ชัน verifyKey ที่คุณมีอยู่แล้ว
    if verifyKey(savedKey) then 
	loadstring(game:HttpGet("https://raw.githubusercontent.com/tangtong178902-rgb/Test/refs/heads/main/kaiju%20alpha.lua"))()
        return -- จบการทำงาน ไม่สร้าง UI ด้านล่าง
    end
end

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")

local sg = Instance.new("ScreenGui")
sg.Name = "NexitKeyUI"
sg.ResetOnSpawn = false
sg.Parent = PlayerGui

-- ══════════════════════════════════════════════
--  MAIN FRAME
-- ══════════════════════════════════════════════
local main = Instance.new("Frame")
main.Name = "MainFrame"
main.Size = UDim2.new(0, 538, 0, 288)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(13, 13, 16)
main.BorderSizePixel = 0
main.ZIndex = 1
main.Parent = sg

-- ══════════════════════════════════════════════
--  MOBILE AUTO SCALE (ย่อขนาดอัตโนมัติสำหรับมือถือ)
-- ══════════════════════════════════════════════
local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local function updateScale()
    local screenSize = sg.AbsoluteSize
    -- ถ้าหน้าจอแคบกว่าขนาด UI (538px) หรือเป็น Mobile
    if screenSize.X < 600 or game:GetService("UserInputService").TouchEnabled then
        -- คำนวณอัตราส่วนการย่อ (ให้เหลือประมาณ 80-85% ของหน้าจอ)
        local scaleValue = math.min(screenSize.X / 600, screenSize.Y / 350)
        uiScale.Scale = scaleValue
    else
        uiScale.Scale = 1 -- ขนาดปกติสำหรับคอม
    end
end

-- อัปเดตขนาดตอนเริ่มและตอนหมุนหน้าจอ
updateScale()
sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(40, 40, 46)
mainStroke.Thickness = 1.2
mainStroke.Parent = main

-- ══════════════════════════════════════════════
--  LEFT PANEL
-- ══════════════════════════════════════════════
local left = Instance.new("Frame")
left.Size = UDim2.new(0, 185, 1, 0)
left.Position = UDim2.new(0, 0, 0, 0)
left.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
left.BorderSizePixel = 0
left.ZIndex = 2
left.Parent = main

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 16)
leftCorner.Parent = left

-- patch right corners of left panel
local leftPatch = Instance.new("Frame")
leftPatch.Size = UDim2.new(0, 16, 1, 0)
leftPatch.Position = UDim2.new(1, -16, 0, 0)
leftPatch.BackgroundColor3 = Color3.fromRGB(9, 9, 11)
leftPatch.BorderSizePixel = 0
leftPatch.ZIndex = 2
leftPatch.Parent = left

-- Vertical separator line
local sep = Instance.new("Frame")
sep.Size = UDim2.new(0, 1, 1, -32)
sep.Position = UDim2.new(0, 184, 0, 16)
sep.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
sep.BorderSizePixel = 0
sep.ZIndex = 3
sep.Parent = main

-- ── Logo Image ──
local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 74, 0, 74)
logoFrame.Position = UDim2.new(0.5, -37, 0, 34)
logoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
logoFrame.BorderSizePixel = 0
logoFrame.ZIndex = 3
logoFrame.Parent = left

local lfCorner = Instance.new("UICorner")
lfCorner.CornerRadius = UDim.new(0, 16)
lfCorner.Parent = logoFrame

local lfStroke = Instance.new("UIStroke")
lfStroke.Color = Color3.fromRGB(45, 45, 52)
lfStroke.Thickness = 1
lfStroke.Parent = logoFrame

local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 74, 0, 74)
logoFrame.Position = UDim2.new(0.5, -37, 0, 34)
logoFrame.BackgroundTransparency = 1
logoFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
logoFrame.BorderSizePixel = 0
logoFrame.ZIndex = 4
logoFrame.Parent = left

local lfCorner = Instance.new("UICorner")
lfCorner.CornerRadius = UDim.new(0, 16)
lfCorner.Parent = logoFrame

local lfStroke = Instance.new("UIStroke")
lfStroke.Color = Color3.fromRGB(45, 45, 52)
lfStroke.Thickness = 1
lfStroke.Parent = logoFrame

local logoImg = Instance.new("ImageLabel")
logoImg.Size = UDim2.new(0, 74, 0, 74)
logoImg.Position = UDim2.new(0.5, -37, 0.5, -37)
logoImg.BackgroundTransparency = 1
logoImg.Image = "rbxassetid://85631148686070"
logoImg.ZIndex = 3
logoImg.Parent = logoFrame

-- ── Hub Name ──
local hubName = Instance.new("TextLabel")
hubName.Size = UDim2.new(1, 0, 0, 24)
hubName.Position = UDim2.new(0, 0, 0, 122)
hubName.BackgroundTransparency = 1
hubName.Text = "NEXIT HUB"
hubName.TextColor3 = Color3.fromRGB(215, 215, 225)
hubName.TextSize = 21
hubName.Font = Enum.Font.GothamBold
hubName.ZIndex = 3
hubName.Parent = left

local hubVer = Instance.new("TextLabel")
hubVer.Size = UDim2.new(1, 0, 0, 16)
hubVer.Position = UDim2.new(0, 0, 0, 148)
hubVer.BackgroundTransparency = 1
hubVer.Text = "KEY SYSTEM"
hubVer.TextColor3 = Color3.fromRGB(65, 65, 75)
hubVer.TextSize = 15
hubVer.Font = Enum.Font.Gotham
hubVer.ZIndex = 3
hubVer.Parent = left

-- ── Thin divider ──
local lDiv = Instance.new("Frame")
lDiv.Size = UDim2.new(0, 110, 0, 1)
lDiv.Position = UDim2.new(0.5, -55, 0, 172)
lDiv.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
lDiv.BorderSizePixel = 0
lDiv.ZIndex = 3
lDiv.Parent = left

-- ── Info rows ──
local function infoRow(icon, text, y)
	local ic = Instance.new("TextLabel")
	ic.Size = UDim2.new(0, 22, 0, 22)
	ic.Position = UDim2.new(0, 20, 0, y)
	ic.BackgroundTransparency = 1
	ic.Text = icon
	ic.TextSize = 13
	ic.Font = Enum.Font.Gotham
	ic.AutoLocalize = false
	ic.ZIndex = 3
	ic.Parent = left

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -48, 0, 22)
	lbl.Position = UDim2.new(0, 44, 0, y)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(85, 85, 95)
	lbl.TextSize = 11
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 3
	lbl.Parent = left
end

-- ══════════════════════════════════════════════
--  RIGHT SIDE CONTENT
-- ══════════════════════════════════════════════
local RX = 205  -- right content X offset

-- Section header
local secHeader = Instance.new("TextLabel")
secHeader.Size = UDim2.new(0, 305, 0, 26)
secHeader.Position = UDim2.new(0, RX, 0, 26)
secHeader.BackgroundTransparency = 1
secHeader.Text = "ENTER YOUR KEY"
secHeader.TextColor3 = Color3.fromRGB(210, 210, 220)
secHeader.TextSize = 19
secHeader.Font = Enum.Font.GothamBold
secHeader.TextXAlignment = Enum.TextXAlignment.Left
secHeader.ZIndex = 2
secHeader.Parent = main

local secDesc = Instance.new("TextLabel")
secDesc.Size = UDim2.new(0, 305, 0, 18)
secDesc.Position = UDim2.new(0, RX, 0, 54)
secDesc.BackgroundTransparency = 1
secDesc.Text = "Paste your verification key to gain access"
secDesc.TextColor3 = Color3.fromRGB(68, 68, 78)
secDesc.TextSize = 15
secDesc.Font = Enum.Font.Gotham
secDesc.TextXAlignment = Enum.TextXAlignment.Left
secDesc.ZIndex = 2
secDesc.Parent = main

-- Thin line under header
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(0, 314, 0, 1)
hLine.Position = UDim2.new(0, RX, 0, 82)
hLine.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
hLine.BorderSizePixel = 0
hLine.ZIndex = 2
hLine.Parent = main

-- Input label
local iLabel = Instance.new("TextLabel")
iLabel.Size = UDim2.new(0, 200, 0, 15)
iLabel.Position = UDim2.new(0, RX, 0, 91)
iLabel.BackgroundTransparency = 1
iLabel.Text = "VERIFICATION KEY"
iLabel.TextColor3 = Color3.fromRGB(75, 75, 88)
iLabel.TextSize = 11
iLabel.Font = Enum.Font.GothamBold
iLabel.TextXAlignment = Enum.TextXAlignment.Left
iLabel.ZIndex = 2
iLabel.Parent = main

-- Input container
local inputBg = Instance.new("Frame")
inputBg.Size = UDim2.new(0, 314, 0, 47)
inputBg.Position = UDim2.new(0, RX, 0, 110)
inputBg.BackgroundColor3 = Color3.fromRGB(17, 17, 21)
inputBg.BorderSizePixel = 0
inputBg.ZIndex = 2
inputBg.Parent = main

local ibCorner = Instance.new("UICorner")
ibCorner.CornerRadius = UDim.new(0, 10)
ibCorner.Parent = inputBg

local ibStroke = Instance.new("UIStroke")
ibStroke.Color = Color3.fromRGB(38, 38, 45)
ibStroke.Thickness = 1
ibStroke.Parent = inputBg

local input = Instance.new("TextBox")
input.Size = UDim2.new(1, -52, 1, 0)
input.Position = UDim2.new(0, 16, 0, 0)
input.BackgroundTransparency = 1
input.PlaceholderText = "FREE_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
input.PlaceholderColor3 = Color3.fromRGB(45, 45, 54)
input.Text = ""
input.TextColor3 = Color3.fromRGB(200, 200, 212)
input.Font = Enum.Font.Gotham
input.TextSize = 18
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
input.MaxVisibleGraphemes = 37
input.TextTruncate = Enum.TextTruncate.AtEnd
input.ZIndex = 3
input.Parent = inputBg

-- จำกัดการพิมพ์ไม่เกิน 37 ตัวอักษร
input:GetPropertyChangedSignal("Text"):Connect(function()
	if #input.Text > 37 then
		input.Text = string.sub(input.Text, 1, 37)
	end
end)

-- Focus glow
input.Focused:Connect(function()
	TweenService:Create(ibStroke, TweenInfo.new(0.22), {
		Color = Color3.fromRGB(90, 90, 108),
		Thickness = 1.5
	}):Play()
	TweenService:Create(inputBg, TweenInfo.new(0.22), {
		BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	}):Play()
end)
input.FocusLost:Connect(function()
	TweenService:Create(ibStroke, TweenInfo.new(0.22), {
		Color = Color3.fromRGB(38, 38, 45),
		Thickness = 1
	}):Play()
	TweenService:Create(inputBg, TweenInfo.new(0.22), {
		BackgroundColor3 = Color3.fromRGB(17, 17, 21)
	}):Play()
end)

-- ══════════════════════════════════════════════
--  BUTTONS
-- ══════════════════════════════════════════════
local function buildBtn(lbl, xPos, w)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, w, 0, 41)
	btn.Position = UDim2.new(0, xPos, 0, 172)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	btn.ZIndex = 4
	btn.Parent = main

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 10)
	bc.Parent = btn

	local bs = Instance.new("UIStroke")
	bs.Color = Color3.fromRGB(48, 48, 58)
	bs.Thickness = 1
	bs.Parent = btn

	local bg = Instance.new("UIGradient")
	bg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 32, 40)),
	})
	bg.Rotation = 90
	bg.Parent = btn

	local btxt = Instance.new("TextLabel")
	btxt.Size = UDim2.new(1, 0, 1, 0)
	btxt.BackgroundTransparency = 1
	btxt.Text = lbl
	btxt.TextColor3 = Color3.fromRGB(170, 170, 185)
	btxt.Font = Enum.Font.GothamBold
	btxt.TextSize = 15
	btxt.ZIndex = 5
	btxt.AutoLocalize = false
	btxt.Parent = btn

	-- Hover
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(28, 28, 36)}):Play()
		TweenService:Create(bs, TweenInfo.new(0.18), {Color = Color3.fromRGB(72, 72, 88)}):Play()
		TweenService:Create(btxt, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(220, 220, 235)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(20, 20, 25)}):Play()
		TweenService:Create(bs, TweenInfo.new(0.18), {Color = Color3.fromRGB(48, 48, 58)}):Play()
		TweenService:Create(btxt, TweenInfo.new(0.18), {TextColor3 = Color3.fromRGB(170, 170, 185)}):Play()
	end)
	btn.MouseButton1Down:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.08), {Size = UDim2.new(0, w-3, 0, 39)}):Play()
	end)
	btn.MouseButton1Up:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {Size = UDim2.new(0, w, 0, 41)}):Play()
	end)

	return btn
end

local getLink = buildBtn("🔗   GET LINK", RX, 150)
getLink.Name = "GetLink"

local verify = buildBtn("✔️   VERIFY KEY", RX + 163, 150)
verify.Name = "Verify"

-- ══════════════════════════════════════════════
--  STATUS BAR
-- ══════════════════════════════════════════════
local statBg = Instance.new("Frame")
statBg.Size = UDim2.new(0, 314, 0, 28)
statBg.Position = UDim2.new(0, RX, 0, 228)
statBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
statBg.BorderSizePixel = 0
statBg.ZIndex = 2
statBg.Parent = main

local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 7)
sbCorner.Parent = statBg

local sbStroke = Instance.new("UIStroke")
sbStroke.Color = Color3.fromRGB(26, 26, 32)
sbStroke.Thickness = 1
sbStroke.Parent = statBg

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 7, 0, 7)
dot.Position = UDim2.new(0, 13, 0.5, -3)
dot.BackgroundColor3 = Color3.fromRGB(65, 65, 78)
dot.BorderSizePixel = 0
dot.ZIndex = 3
dot.Parent = statBg

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = dot

local statTxt = Instance.new("TextLabel")
statTxt.Size = UDim2.new(1, -32, 1, 0)
statTxt.Position = UDim2.new(0, 28, 0, 0)
statTxt.BackgroundTransparency = 1
statTxt.Text = "Awaiting input..."
statTxt.TextColor3 = Color3.fromRGB(65, 65, 78)
statTxt.TextSize = 13
statTxt.Font = Enum.Font.Gotham
statTxt.TextXAlignment = Enum.TextXAlignment.Left
statTxt.ZIndex = 3
statTxt.Parent = statBg

-- ══════════════════════════════════════════════
--  CLOSE BUTTON
-- ══════════════════════════════════════════════
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -40, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
closeBtn.Text = "❌"
closeBtn.TextColor3 = Color3.fromRGB(88, 88, 100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.AutoLocalize = false
closeBtn.ZIndex = 10
closeBtn.Parent = main

local cbCorner = Instance.new("UICorner")
cbCorner.CornerRadius = UDim.new(0, 7)
cbCorner.Parent = closeBtn

local cbStroke = Instance.new("UIStroke")
cbStroke.Color = Color3.fromRGB(38, 38, 46)
cbStroke.Thickness = 1
cbStroke.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(52, 22, 22),
		TextColor3 = Color3.fromRGB(210, 90, 80)
	}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(20, 20, 24),
		TextColor3 = Color3.fromRGB(88, 88, 100)
	}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	sg.Enabled = false
end)

local function setStatus(text, color, dotColor)
    statTxt.Text = text
    statTxt.TextColor3 = color
    dot.BackgroundColor3 = dotColor or color
end

onMessage = function(message)
    setStatus(message, Color3.fromRGB(185, 80, 70), Color3.fromRGB(170, 65, 58))
end

-- 6. Events ปุ่มกดต่างๆ
getLink.MouseButton1Click:Connect(function()
    setStatus("Generating link...", Color3.fromRGB(150, 150, 168), Color3.fromRGB(130, 130, 150))
    local success, link = cacheLink()
    if success then
        if setclipboard or toclipboard then
            (setclipboard or toclipboard)(link)
            setStatus("Link copied to clipboard.", Color3.fromRGB(100, 195, 125), Color3.fromRGB(85, 185, 110))
        else
            setStatus("Clipboard not supported.", Color3.fromRGB(185, 80, 70), Color3.fromRGB(170, 65, 58))
        end
    end
end)

verify.MouseButton1Click:Connect(function()
    local userKey = input.Text
    if userKey == "" then
        setStatus("Please enter your key.", Color3.fromRGB(185, 80, 70), Color3.fromRGB(170, 65, 58))
        return
    end

    setStatus("Verifying key...", Color3.fromRGB(140, 140, 158), Color3.fromRGB(110, 110, 130))
    verify.Active = false
    
    task.spawn(function()
        local success = verifyKey(userKey)
        if success then
            -- เซฟลงไฟล์เมื่อผ่าน
            saveKey(userKey) 
            
            setStatus("Access granted", Color3.fromRGB(100, 195, 125), Color3.fromRGB(85, 185, 110))
            task.wait(1)
            sg:Destroy() 
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tangtong178902-rgb/Test/refs/heads/main/kaiju%20alpha.lua"))()
        else
            setStatus("Invalid Key", Color3.fromRGB(185, 80, 70), Color3.fromRGB(170, 65, 58))
            verify.Active = true
        end
    end)
end)