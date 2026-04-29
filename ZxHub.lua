-- ZxHub FIXED VERSION

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

-- ✅ DEFAULT = OFF
local flyEnabled    = false
local speedEnabled  = false
local jumpEnabled   = false
local noclipEnabled = false

local flySpeed  = 8
local walkSpeed = 16
local jumpPower = 50

local flyConn, noclipConn
local bv, bg

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player.PlayerGui

-- ======================
-- MAIN FRAME (Responsive)
-- ======================
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0.4,0,0.5,0)
Frame.Position = UDim2.new(0.3,0,0.25,0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,10)

-- ======================
-- LOGO BUTTON (ย่อ)
-- ======================
local LogoBtn = Instance.new("TextButton")
LogoBtn.Size = UDim2.new(0,60,0,60)
LogoBtn.Position = UDim2.new(0,20,0.5,-30)
LogoBtn.Text = "ZX"
LogoBtn.Visible = false
LogoBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
LogoBtn.Parent = ScreenGui

Instance.new("UICorner", LogoBtn).CornerRadius = UDim.new(1,0)

-- ======================
-- TOGGLE FUNCTION
-- ======================
local function makeToggle(parent, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,80,0,30)
    btn.Position = UDim2.new(1,-90,0.5,-15)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = default and "ON" or "OFF"
    btn.Parent = parent

    local state = default

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0,255,100) or Color3.fromRGB(60,60,60)
        callback(state)
    end)
end

-- ======================
-- SLIDER FIX
-- ======================
local function makeSlider(parent, value, callback)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,60,0,30)
    box.Position = UDim2.new(0,150,0.5,-15)
    box.Text = tostring(value)
    box.ClearTextOnFocus = true
    box.Parent = parent

    box.FocusLost:Connect(function()
        local v = tonumber(box.Text)
        if v then
            callback(v)
        end
        box.Text = tostring(value)
    end)
end

-- ======================
-- ROW MAKER
-- ======================
local function makeRow(y, text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1,-20,0,60)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = Color3.fromRGB(40,40,40)
    row.Parent = Frame

    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0,120,1,0)
    lbl.Text = text
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(0,255,120)
    lbl.Parent = row

    return row
end

-- ======================
-- FLY
-- ======================
local rowFly = makeRow(20,"FLY")

makeSlider(rowFly, flySpeed, function(v)
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

-- ======================
-- SPEED
-- ======================
local rowSpeed = makeRow(100,"SPEED")

makeSlider(rowSpeed, walkSpeed, function(v)
    walkSpeed = v
    if speedEnabled then humanoid.WalkSpeed = v end
end)

makeToggle(rowSpeed, false, function(s)
    speedEnabled = s
    humanoid.WalkSpeed = s and walkSpeed or 16
end)

-- ======================
-- JUMP
-- ======================
local rowJump = makeRow(180,"JUMP")

makeSlider(rowJump, jumpPower, function(v)
    jumpPower = v
    if jumpEnabled then humanoid.JumpPower = v end
end)

makeToggle(rowJump, false, function(s)
    jumpEnabled = s
    humanoid.JumpPower = s and jumpPower or 50
end)

-- ======================
-- NOCLIP
-- ======================
local rowNoclip = makeRow(260,"NOCLIP")

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

-- ======================
-- MINIMIZE SYSTEM FIX
-- ======================
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,5)
minimize.Text = "-"
minimize.Parent = Frame

minimize.MouseButton1Click:Connect(function()
    Frame.Visible = false
    LogoBtn.Visible = true
end)

LogoBtn.MouseButton1Click:Connect(function()
    LogoBtn.Visible = false
    Frame.Visible = true
end)

-- ======================
-- CHARACTER RESPAWN FIX
-- ======================
player.CharacterAdded:Connect(function()
    humanoid = getHumanoid()

    if speedEnabled then humanoid.WalkSpeed = walkSpeed end
    if jumpEnabled then humanoid.JumpPower = jumpPower end
end)
