-- ZxHub - Roblox LocalScript
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end
local function getHumanoid()
    return getChar():WaitForChild("Humanoid")
end
local humanoid = getHumanoid()

local flyEnabled    = true
local speedEnabled  = true
local jumpEnabled   = true
local noclipEnabled = false

local flySpeed  = 8
local walkSpeed = 15
local jumpPower = 22

local flyConn, noclipConn
local bv, bg

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

local C = {
    bg         = Color3.fromRGB(28, 32, 36),
    topbar     = Color3.fromRGB(20, 23, 26),
    row        = Color3.fromRGB(38, 44, 50),
    rowActive  = Color3.fromRGB(30, 60, 40),
    green      = Color3.fromRGB(50, 220, 80),
    greenDim   = Color3.fromRGB(30, 140, 50),
    text       = Color3.fromRGB(220, 255, 220),
    gray       = Color3.fromRGB(80, 90, 100),
    grayDark   = Color3.fromRGB(55, 62, 70),
    black      = Color3.fromRGB(10, 12, 14),
    white      = Color3.fromRGB(255, 255, 255),
}

-- =====================
-- LOGO BUTTON
-- =====================
local LogoBtn = Instance.new("ImageButton")
LogoBtn.Size = UDim2.new(0, 90, 0, 90)
LogoBtn.Position = UDim2.new(0, 20, 0.5, -45)
LogoBtn.BackgroundColor3 = Color3.fromRGB(22, 26, 24)
LogoBtn.BorderSizePixel = 0
LogoBtn.Visible = false
LogoBtn.ZIndex = 10
LogoBtn.Parent = ScreenGui

local logoCorner = Instance.new("UICorner", LogoBtn)
logoCorner.CornerRadius = UDim.new(1, 0)

local outerRing = Instance.new("Frame")
outerRing.Size = UDim2.new(1, 8, 1, 8)
outerRing.Position = UDim2.new(0, -4, 0, -4)
outerRing.BackgroundTransparency = 1
outerRing.BorderSizePixel = 0
outerRing.ZIndex = 9
outerRing.Parent = LogoBtn

local outerStroke = Instance.new("UIStroke", outerRing)
outerStroke.Color = Color3.fromRGB(45, 45, 45)
outerStroke.Thickness = 3

local outerCorner = Instance.new("UICorner", outerRing)
outerCorner.CornerRadius = UDim.new(1, 0)

local greenRing = Instance.new("Frame")
greenRing.Size = UDim2.new(1, -6, 1, -6)
greenRing.Position = UDim2.new(0, 3, 0, 3)
greenRing.BackgroundTransparency = 1
greenRing.BorderSizePixel = 0
greenRing.ZIndex = 10
greenRing.Parent = LogoBtn

local greenStroke = Instance.new("UIStroke", greenRing)
greenStroke.Color = C.green
greenStroke.Thickness = 2.5

local greenCorner = Instance.new("UICorner", greenRing)
greenCorner.CornerRadius = UDim.new(1, 0)

local ZLabel = Instance.new("TextLabel")
ZLabel.Size = UDim2.new(0, 44, 0, 50)
ZLabel.Position = UDim2.new(0, 6, 0, 18)
ZLabel.BackgroundTransparency = 1
ZLabel.Text = "Z"
ZLabel.TextColor3 = C.green
ZLabel.Font = Enum.Font.GothamBlack
ZLabel.TextSize = 40
ZLabel.TextXAlignment = Enum.TextXAlignment.Left
ZLabel.ZIndex = 11
ZLabel.Parent = LogoBtn

local XLabel = Instance.new("TextLabel")
XLabel.Size = UDim2.new(0, 44, 0, 50)
XLabel.Position = UDim2.new(0, 38, 0, 26)
XLabel.BackgroundTransparency = 1
XLabel.Text = "X"
XLabel.TextColor3 = Color3.fromRGB(100, 110, 115)
XLabel.Font = Enum.Font.GothamBlack
XLabel.TextSize = 36
XLabel.TextXAlignment = Enum.TextXAlignment.Left
XLabel.ZIndex = 11
XLabel.Parent = LogoBtn

-- Drag logo
local logoDragging = false
local logoDragStart, logoStartPos, logoMoved

LogoBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        logoDragging = true
        logoMoved    = false
        logoDragStart = inp.Position
        logoStartPos  = LogoBtn.Position
    end
end)

LogoBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        logoDragging = false
        if not logoMoved then
            LogoBtn.Visible = false
            Frame.Visible   = true
        end
    end
end)

UIS.InputChanged:Connect(function(inp)
    if logoDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - logoDragStart
        if math.abs(d.X) + math.abs(d.Y) > 5 then
            logoMoved = true
        end
        LogoBtn.Position = UDim2.new(
            logoStartPos.X.Scale, logoStartPos.X.Offset + d.X,
            logoStartPos.Y.Scale, logoStartPos.Y.Offset + d.Y
        )
    end
end)

-- Pulse animation
TweenService:Create(greenStroke, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Thickness = 4.5
}):Play()

-- =====================
-- MAIN FRAME
-- =====================
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 640, 0, 420)
Frame.Position = UDim2.new(0.5, -320, 0.5, -210)
Frame.BackgroundColor3 = C.bg
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local frameCorner = Instance.new("UICorner", Frame)
frameCorner.CornerRadius = UDim.new(0, 8)

local frameStroke = Instance.new("UIStroke", Frame)
frameStroke.Color = Color3.fromRGB(50, 80, 55)
frameStroke.Thickness = 1.5

-- =====================
-- TOP BAR
-- =====================
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = C.topbar
TopBar.BorderSizePixel = 0
TopBar.Parent = Frame

local topCorner = Instance.new("UICorner", TopBar)
topCorner.CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ZxHub"
TitleLabel.TextColor3 = C.green
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local function makeTopBtn(text, xOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 22)
    btn.Position = UDim2.new(1, xOffset, 0.5, -11)
    btn.BackgroundColor3 = C.grayDark
    btn.Text = text
    btn.TextColor3 = C.text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = TopBar
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 4)
    return btn
end

local MinBtn   = makeTopBtn("−", -62)
local CloseBtn = makeTopBtn("✕", -30)

MinBtn.MouseButton1Click:Connect(function()
    Frame.Visible   = false
    LogoBtn.Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Drag main frame
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = inp.Position
        startPos  = Frame.Position
    end
end)
TopBar.InputEnded:Connect(function() dragging = false end)
UIS.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- =====================
-- HELPERS
-- =====================
local ROW_H   = 70
local ROW_PAD = 12

local function makeRow(yOffset)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -24, 0, ROW_H - 4)
    row.Position = UDim2.new(0, 12, 0, yOffset)
    row.BackgroundColor3 = C.row
    row.BorderSizePixel = 0
    row.Parent = Frame
    local rc = Instance.new("UICorner", row)
    rc.CornerRadius = UDim.new(0, 8)
    return row
end

local function makeLabel(parent, text, isActive)
    local lbl = Instance.new("TextButton")
    lbl.Size = UDim2.new(0, 160, 0, 46)
    lbl.Position = UDim2.new(0, 14, 0.5, -23)
    lbl.BackgroundColor3 = isActive and C.rowActive or C.grayDark
    lbl.Text = "[ "..text.." ]"
    lbl.TextColor3 = isActive and C.green or C.gray
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    lbl.BorderSizePixel = 0
    lbl.AutoButtonColor = false
    lbl.Parent = parent
    local c = Instance.new("UICorner", lbl)
    c.CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", lbl)
    s.Color = isActive and C.green or C.gray
    s.Thickness = 1.2
    return lbl, s
end

local function makeSlider(parent, val, minV, maxV, onChange)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 220, 0, 6)
    track.Position = UDim2.new(0, 190, 0.5, 6)
    track.BackgroundColor3 = C.grayDark
    track.BorderSizePixel = 0
    track.Parent = parent
    local tc = Instance.new("UICorner", track)
    tc.CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((val - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = C.green
    fill.BorderSizePixel = 0
    fill.Parent = track
    local fc = Instance.new("UICorner", fill)
    fc.CornerRadius = UDim.new(1, 0)

    local thumb = Instance.new("Frame")
    thumb.Size = UDim2.new(0, 14, 0, 14)
    thumb.Position = UDim2.new((val - minV) / (maxV - minV), -7, 0.5, -7)
    thumb.BackgroundColor3 = C.green
    thumb.BorderSizePixel = 0
    thumb.Parent = track
    local thc = Instance.new("UICorner", thumb)
    thc.CornerRadius = UDim.new(1, 0)

    local numLbl = Instance.new("TextLabel")
    numLbl.Size = UDim2.new(0, 40, 0, 20)
    numLbl.Position = UDim2.new((val - minV) / (maxV - minV), -20, 0, -26)
    numLbl.BackgroundTransparency = 1
    numLbl.Text = tostring(val)
    numLbl.TextColor3 = C.green
    numLbl.Font = Enum.Font.GothamBold
    numLbl.TextSize = 13
    numLbl.Parent = track

    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 20, 0, 30)
    hitbox.Position = UDim2.new(0, -10, 0.5, -15)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.Parent = track

    local draggingSlider = false
    hitbox.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if draggingSlider and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local rel = math.clamp((inp.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local newVal = math.floor(minV + rel * (maxV - minV))
            fill.Size = UDim2.new(rel, 0, 1, 0)
            thumb.Position = UDim2.new(rel, -7, 0.5, -7)
            numLbl.Position = UDim2.new(rel, -20, 0, -26)
            numLbl.Text = tostring(newVal)
            onChange(newVal)
        end
    end)

    return fill, thumb, numLbl
end

local function makePlusMinus(parent, getVal, setVal, fill, thumb, numLbl, minV, maxV)
    local function refresh(v)
        local rel = (v - minV) / (maxV - minV)
        fill.Size = UDim2.new(rel, 0, 1, 0)
        thumb.Position = UDim2.new(rel, -7, 0.5, -7)
        numLbl.Position = UDim2.new(rel, -20, 0, -26)
        numLbl.Text = tostring(v)
    end
    local function makeBtn(txt, xOff)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 34, 0, 30)
        b.Position = UDim2.new(0, xOff, 0.5, -15)
        b.BackgroundColor3 = C.grayDark
        b.Text = txt
        b.TextColor3 = C.text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 16
        b.BorderSizePixel = 0
        b.Parent = parent
        local c = Instance.new("UICorner", b)
        c.CornerRadius = UDim.new(0, 5)
        return b
    end
    local plus  = makeBtn("+", 424)
    local minus = makeBtn("−", 460)
    plus.MouseButton1Click:Connect(function()
        local v = math.min(getVal() + 1, maxV)
        setVal(v); refresh(v)
    end)
    minus.MouseButton1Click:Connect(function()
        local v = math.max(getVal() - 1, minV)
        setVal(v); refresh(v)
    end)
end

local function makeValueBox(parent, getVal, setVal, fill, thumb, numLbl, minV, maxV)
    local box = Instance.new("TextButton")
    box.Size = UDim2.new(0, 80, 0, 36)
    box.Position = UDim2.new(0, 502, 0.5, -18)
    box.BackgroundTransparency = 1
    box.Text = ""
    box.BorderSizePixel = 0
    box.AutoButtonColor = false
    box.Parent = parent

    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel = 0
    border.Parent = box
    local bs = Instance.new("UIStroke", border)
    bs.Color = C.green
    bs.Thickness = 1.2
    local bc = Instance.new("UICorner", border)
    bc.CornerRadius = UDim.new(0, 5)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "[ "..tostring(getVal()).." ]"
    lbl.TextColor3 = C.green
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 14
    lbl.Parent = box

    local editBox = Instance.new("TextBox")
    editBox.Size = UDim2.new(1, 0, 1, 0)
    editBox.BackgroundTransparency = 1
    editBox.Text = ""
    editBox.PlaceholderText = tostring(getVal())
    editBox.TextColor3 = C.green
    editBox.Font = Enum.Font.GothamBold
    editBox.TextSize = 14
    editBox.Visible = false
    editBox.Parent = box

    box.MouseButton1Click:Connect(function()
        lbl.Visible = false
        editBox.Visible = true
        editBox:CaptureFocus()
    end)
    editBox.FocusLost:Connect(function()
        local v = tonumber(editBox.Text)
        if v then
            v = math.clamp(math.floor(v), minV, maxV)
            setVal(v)
            local rel = (v - minV) / (maxV - minV)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            thumb.Position = UDim2.new(rel, -7, 0.5, -7)
            numLbl.Position = UDim2.new(rel, -20, 0, -26)
            numLbl.Text = tostring(v)
            lbl.Text = "[ "..tostring(v).." ]"
        end
        editBox.Text = ""
        editBox.Visible = false
        lbl.Visible = true
    end)

    return lbl
end

local function makeToggle(parent, isOn, onToggle)
    local bg2 = Instance.new("Frame")
    bg2.Size = UDim2.new(0, 90, 0, 38)
    bg2.Position = UDim2.new(1, -104, 0.5, -19)
    bg2.BackgroundColor3 = isOn and C.green or C.gray
    bg2.BorderSizePixel = 0
    bg2.Parent = parent
    local c = Instance.new("UICorner", bg2)
    c.CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 30, 0, 30)
    knob.Position = isOn and UDim2.new(1, -34, 0.5, -15) or UDim2.new(0, 4, 0.5, -15)
    knob.BackgroundColor3 = C.white
    knob.BorderSizePixel = 0
    knob.Parent = bg2
    local kc = Instance.new("UICorner", knob)
    kc.CornerRadius = UDim.new(1, 0)

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = isOn and "ON" or "OFF"
    txt.TextColor3 = C.black
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 13
    txt.TextXAlignment = isOn and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
    local pad = Instance.new("UIPadding", txt)
    pad.PaddingLeft  = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    txt.Parent = bg2

    local state = isOn
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = bg2

    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(knob, TweenInfo.new(0.15), {
            Position = state and UDim2.new(1,-34,0.5,-15) or UDim2.new(0,4,0.5,-15)
        }):Play()
        TweenService:Create(bg2, TweenInfo.new(0.15), {
            BackgroundColor3 = state and C.green or C.gray
        }):Play()
        txt.Text = state and "ON" or "OFF"
        txt.TextXAlignment = state and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
        onToggle(state)
    end)
end

-- =====================
-- BUILD ROWS
-- =====================

-- FLY
local rowFly = makeRow(44)
makeLabel(rowFly, "FLY", flyEnabled)
local flyFill, flyThumb, flyNumLbl = makeSlider(rowFly, flySpeed, 1, 500, function(v)
    flySpeed = v
end)
makePlusMinus(rowFly,
    function() return flySpeed end,
    function(v) flySpeed = v end,
    flyFill, flyThumb, flyNumLbl, 1, 500)
makeValueBox(rowFly,
    function() return flySpeed end,
    function(v) flySpeed = v end,
    flyFill, flyThumb, flyNumLbl, 1, 500)

-- SPEED
local rowSpeed = makeRow(44 + ROW_H + ROW_PAD)
makeLabel(rowSpeed, "SPEED", speedEnabled)
local spFill, spThumb, spNumLbl = makeSlider(rowSpeed, walkSpeed, 1, 500, function(v)
    walkSpeed = v
    if speedEnabled then humanoid.WalkSpeed = walkSpeed end
end)
makePlusMinus(rowSpeed,
    function() return walkSpeed end,
    function(v) walkSpeed = v end,
    spFill, spThumb, spNumLbl, 1, 500)
makeValueBox(rowSpeed,
    function() return walkSpeed end,
    function(v) walkSpeed = v end,
    spFill, spThumb, spNumLbl, 1, 500)

-- JUMP
local rowJump = makeRow(44 + (ROW_H + ROW_PAD) * 2)
makeLabel(rowJump, "JUMP", jumpEnabled)
local jpFill, jpThumb, jpNumLbl = makeSlider(rowJump, jumpPower, 1, 500, function(v)
    jumpPower = v
    if jumpEnabled then humanoid.JumpPower = jumpPower end
end)
makePlusMinus(rowJump,
    function() return jumpPower end,
    function(v) jumpPower = v end,
    jpFill, jpThumb, jpNumLbl, 1, 500)
makeValueBox(rowJump,
    function() return jumpPower end,
    function(v) jumpPower = v end,
    jpFill, jpThumb, jpNumLbl, 1, 500)

-- NOCLIP
local rowNoclip = makeRow(44 + (ROW_H + ROW_PAD) * 3)
makeLabel(rowNoclip, "NOCLIP", noclipEnabled)

-- =====================
-- TOGGLE LOGIC
-- =====================
local function startFly()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    bv = Instance.new("BodyVelocity", hrp)
    bg = Instance.new("BodyGyro", hrp)
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    bg.P = 1e4
    if flyConn then flyConn:Disconnect() end
    flyConn = RunService.RenderStepped:Connect(function()
        if flyEnabled and bv and bv.Parent then
            local cam = workspace.CurrentCamera.CFrame
            local vel = Vector3.new(0, 0, 0)
            if UIS:IsKeyDown(Enum.KeyCode.W)         then vel = vel + cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S)         then vel = vel - cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A)         then vel = vel - cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D)         then vel = vel + cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then vel = vel + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then vel = vel - Vector3.new(0,1,0) end
            bv.Velocity = vel * flySpeed
            bg.CFrame = cam
        end
    end)
end

local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if bv then bv:Destroy(); bv = nil end
    if bg then bg:Destroy(); bg = nil end
end

local function startNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        local char = player.Character
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

makeToggle(rowFly, flyEnabled, function(s)
    flyEnabled = s
    if s then startFly() else stopFly() end
end)

makeToggle(rowSpeed, speedEnabled, function(s)
    speedEnabled = s
    humanoid.WalkSpeed = s and walkSpeed or 16
end)

makeToggle(rowJump, jumpEnabled, function(s)
    jumpEnabled = s
    humanoid.JumpPower = s and jumpPower or 50
end)

makeToggle(rowNoclip, noclipEnabled, function(s)
    noclipEnabled = s
    if s then startNoclip() else stopNoclip() end
end)

-- =====================
-- INIT
-- =====================
if flyEnabled then startFly() end
humanoid.WalkSpeed = walkSpeed
humanoid.JumpPower = jumpPower

player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()
    if flyEnabled  then task.wait(0.5); startFly() end
    if speedEnabled then humanoid.WalkSpeed = walkSpeed end
    if jumpEnabled  then humanoid.JumpPower  = jumpPower end
end)
