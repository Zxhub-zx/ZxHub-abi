-- ZxHub PRO (Mobile + PC Ready)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- =====================
-- CHARACTER
-- =====================
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    return getChar():WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- =====================
-- STATE
-- =====================
local flyEnabled    = false
local speedEnabled  = false
local jumpEnabled   = false
local noclipEnabled = false

local flySpeed  = 8
local walkSpeed = 16
local jumpPower = 50

local flyConn, noclipConn
local bv, bg

-- =====================
-- GUI ROOT
-- =====================
local gui = Instance.new("ScreenGui")
gui.Name = "ZxHubPro"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- =====================
-- COLORS
-- =====================
local C = {
    bg = Color3.fromRGB(20,22,24),
    row = Color3.fromRGB(35,40,45),
    green = Color3.fromRGB(0,255,140),
    dark = Color3.fromRGB(60,60,60),
    white = Color3.fromRGB(255,255,255)
}

-- =====================
-- MAIN FRAME
-- =====================
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.35,0,0.5,0)
Frame.Position = UDim2.new(0.325,0,0.25,0)
Frame.BackgroundColor3 = C.bg
Frame.Parent = gui
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", Frame)
stroke.Color = C.green
stroke.Transparency = 0.6

-- =====================
-- LOGO (MINIMIZE)
-- =====================
local Logo = Instance.new("TextButton")
Logo.Size = UDim2.new(0,60,0,60)
Logo.Position = UDim2.new(0,20,0.5,-30)
Logo.Text = "ZX"
Logo.TextColor3 = C.green
Logo.BackgroundColor3 = C.bg
Logo.Visible = false
Logo.Parent = gui

Instance.new("UICorner", Logo).CornerRadius = UDim.new(1,0)

-- drag logo (มือถือ + pc)
local dragging = false
local dragStart, startPos

Logo.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = inp.Position
        startPos = Logo.Position
    end
end)

Logo.InputEnded:Connect(function()
    dragging = false
end)

UIS.InputChanged:Connect(function(inp)
    if dragging then
        local delta = inp.Position - dragStart
        Logo.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

Logo.MouseButton1Click:Connect(function()
    Logo.Visible = false
    Frame.Visible = true
end)

-- =====================
-- MINIMIZE BUTTON
-- =====================
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.Text = "-"
minBtn.Parent = Frame

minBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Logo.Visible = true
end)

-- =====================
-- ROW CREATOR
-- =====================
local function createRow(y,text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-20,0,60)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = C.row
    row.Parent = Frame
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,120,1,0)
    lbl.Text = text
    lbl.TextColor3 = C.green
    lbl.BackgroundTransparency = 1
    lbl.Parent = row

    return row
end

-- =====================
-- TOGGLE
-- =====================
local function makeToggle(parent, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,70,0,30)
    btn.Position = UDim2.new(1,-80,0.5,-15)
    btn.BackgroundColor3 = C.dark
    btn.Text = "OFF"
    btn.Parent = parent

    local state = default

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and C.green or C.dark
        callback(state)
    end)
end

-- =====================
-- INPUT BOX (FIXED)
-- =====================
local function makeInput(parent, value, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,60,0,30)
    box.Position = UDim2.new(0,140,0.5,-15)
    box.Text = tostring(value)
    box.ClearTextOnFocus = true
    box.TextColor3 = C.green
    box.BackgroundColor3 = C.bg
    box.Parent = parent

    Instance.new("UICorner", box)

    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then callback(v) end
        box.Text = tostring(value)
    end)
end

-- =====================
-- FLY
-- =====================
local rowFly = createRow(20,"FLY")

makeInput(rowFly, flySpeed, function(v)
    flySpeed = v
end)

makeToggle(rowFly, false, function(s)
    flyEnabled = s

    if s then
        local char = getChar()
        local hrp = char:WaitForChild("HumanoidRootPart")

        bv = Instance.new("BodyVelocity", hrp)
        bg = Instance.new("BodyGyro", hrp)

        bv.MaxForce = Vector3.new(1e6,1e6,1e6)
        bg.MaxTorque = Vector3.new(1e6,1e6,1e6)

        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local vel = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then vel += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then vel -= cam.CFrame.LookVector end

            bv.Velocity = vel * flySpeed
            bg.CFrame = cam.CFrame
        end)

    else
        if flyConn then flyConn:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- =====================
-- SPEED
-- =====================
local rowSpeed = createRow(100,"SPEED")

makeInput(rowSpeed, walkSpeed, function(v)
    walkSpeed = v
    if speedEnabled then humanoid.WalkSpeed = v end
end)

makeToggle(rowSpeed, false, function(s)
    speedEnabled = s
    humanoid.WalkSpeed = s and walkSpeed or 16
end)

-- =====================
-- JUMP
-- =====================
local rowJump = createRow(180,"JUMP")

makeInput(rowJump, jumpPower, function(v)
    jumpPower = v
    if jumpEnabled then humanoid.JumpPower = v end
end)

makeToggle(rowJump, false, function(s)
    jumpEnabled = s
    humanoid.JumpPower = s and jumpPower or 50
end)

-- =====================
-- NOCLIP
-- =====================
local rowNoclip = createRow(260,"NOCLIP")

makeToggle(rowNoclip, false, function(s)
    noclipEnabled = s

    if s then
        noclipConn = RunService.Stepped:Connect(function()
            for _,v in pairs(getChar():GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

-- =====================
-- RESPAWN FIX
-- =====================
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()

    if speedEnabled then humanoid.WalkSpeed = walkSpeed end
    if jumpEnabled then humanoid.JumpPower = jumpPower end
end)
