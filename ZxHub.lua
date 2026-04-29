-- ZxHub ULTRA UI

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- =====================
-- COLORS
-- =====================
local C = {
    bg = Color3.fromRGB(18,20,22),
    row = Color3.fromRGB(35,40,45),
    stroke = Color3.fromRGB(60,70,75),
    green = Color3.fromRGB(0,255,140),
    greenDim = Color3.fromRGB(0,140,80),
    gray = Color3.fromRGB(80,90,100),
    white = Color3.fromRGB(255,255,255)
}

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
-- STATE (OFF DEFAULT)
-- =====================
local flyEnabled, speedEnabled, jumpEnabled, noclipEnabled = false,false,false,false
local flySpeed, walkSpeed, jumpPower = 8,16,50

-- =====================
-- GUI ROOT
-- =====================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- =====================
-- MAIN FRAME
-- =====================
local Frame = Instance.new("Frame", gui)
Frame.Size = UDim2.new(0.38,0,0.5,0)
Frame.Position = UDim2.new(0.31,0,0.25,0)
Frame.BackgroundColor3 = C.bg
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner",Frame).CornerRadius = UDim.new(0,10)

local stroke = Instance.new("UIStroke",Frame)
stroke.Color = C.stroke

-- =====================
-- LOGO (เหมือนรูป 2)
-- =====================
local Logo = Instance.new("Frame",gui)
Logo.Size = UDim2.new(0,80,0,80)
Logo.Position = UDim2.new(0,20,0.5,-40)
Logo.BackgroundColor3 = C.bg
Logo.Visible = false
Instance.new("UICorner",Logo).CornerRadius = UDim.new(1,0)

local ring = Instance.new("UIStroke",Logo)
ring.Color = C.green
ring.Thickness = 2

local txt = Instance.new("TextLabel",Logo)
txt.Size = UDim2.new(1,0,1,0)
txt.Text = "ZX"
txt.TextColor3 = C.green
txt.Font = Enum.Font.GothamBlack
txt.TextScaled = true
txt.BackgroundTransparency = 1

-- =====================
-- MINIMIZE
-- =====================
local min = Instance.new("TextButton",Frame)
min.Size = UDim2.new(0,30,0,30)
min.Position = UDim2.new(1,-35,0,5)
min.Text = "-"
min.BackgroundColor3 = C.gray

min.MouseButton1Click:Connect(function()
    Frame.Visible = false
    Logo.Visible = true
end)

Logo.InputBegan:Connect(function()
    Logo.Visible = false
    Frame.Visible = true
end)

-- =====================
-- ROW BUILDER
-- =====================
local function createRow(y,text)
    local row = Instance.new("Frame",Frame)
    row.Size = UDim2.new(1,-20,0,70)
    row.Position = UDim2.new(0,10,0,y)
    row.BackgroundColor3 = C.row
    Instance.new("UICorner",row).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel",row)
    lbl.Size = UDim2.new(0,150,1,0)
    lbl.Text = "[ "..text.." ]"
    lbl.TextColor3 = C.green
    lbl.Font = Enum.Font.GothamBold
    lbl.BackgroundTransparency = 1

    return row
end

-- =====================
-- SLIDER
-- =====================
local function makeSlider(row, value, callback)
    local track = Instance.new("Frame",row)
    track.Size = UDim2.new(0,200,0,6)
    track.Position = UDim2.new(0,180,0.5,0)
    track.BackgroundColor3 = C.gray
    Instance.new("UICorner",track)

    local fill = Instance.new("Frame",track)
    fill.Size = UDim2.new(value/100,0,1,0)
    fill.BackgroundColor3 = C.green
    Instance.new("UICorner",fill)

    local knob = Instance.new("Frame",track)
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new(value/100,-7,0.5,-7)
    knob.BackgroundColor3 = C.green
    Instance.new("UICorner",knob)

    local dragging=false

    knob.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
        end
    end)

    UIS.InputEnded:Connect(function()
        dragging=false
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging then
            local rel = math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            local v = math.floor(rel*100)
            fill.Size = UDim2.new(rel,0,1,0)
            knob.Position = UDim2.new(rel,-7,0.5,-7)
            callback(v)
        end
    end)
end

-- =====================
-- TOGGLE (เหมือนรูป)
-- =====================
local function makeToggle(row,callback)
    local bg = Instance.new("Frame",row)
    bg.Size = UDim2.new(0,80,0,36)
    bg.Position = UDim2.new(1,-100,0.5,-18)
    bg.BackgroundColor3 = C.gray
    Instance.new("UICorner",bg).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame",bg)
    knob.Size = UDim2.new(0,30,0,30)
    knob.Position = UDim2.new(0,3,0.5,-15)
    knob.BackgroundColor3 = C.white
    Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

    local state=false

    bg.InputBegan:Connect(function()
        state = not state
        TweenService:Create(knob,TweenInfo.new(0.2),{
            Position = state and UDim2.new(1,-33,0.5,-15) or UDim2.new(0,3,0.5,-15)
        }):Play()

        bg.BackgroundColor3 = state and C.green or C.gray
        callback(state)
    end)
end

-- =====================
-- BUILD
-- =====================
local rowFly = createRow(30,"FLY")
makeSlider(rowFly,flySpeed,function(v) flySpeed=v end)
makeToggle(rowFly,function(s) flyEnabled=s end)

local rowSpeed = createRow(120,"SPEED")
makeSlider(rowSpeed,walkSpeed,function(v) walkSpeed=v humanoid.WalkSpeed=v end)
makeToggle(rowSpeed,function(s) speedEnabled=s end)

local rowJump = createRow(210,"JUMP")
makeSlider(rowJump,jumpPower,function(v) jumpPower=v humanoid.JumpPower=v end)
makeToggle(rowJump,function(s) jumpEnabled=s end)

local rowNoclip = createRow(300,"NOCLIP")
makeToggle(rowNoclip,function(s) noclipEnabled=s end)
