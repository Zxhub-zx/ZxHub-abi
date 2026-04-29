-- ZxHub (Fixed + Clean UI)

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ================= CONFIG =================
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false

local flySpeed = 8
local walkSpeed = 16
local jumpPower = 50

-- ================= CHARACTER =================
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 300)
frame.Position = UDim2.new(0.5, -210, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "ZxHub"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = frame

-- MIN BUTTON
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-30,0,0)
minBtn.Text = "-"
minBtn.Parent = frame

-- LOGO (ตอนย่อ)
local logo = Instance.new("TextButton")
logo.Size = UDim2.new(0,60,0,60)
logo.Position = UDim2.new(0,20,0.5,-30)
logo.Text = "ZX"
logo.Visible = false
logo.BackgroundColor3 = Color3.fromRGB(30,30,30)
logo.TextColor3 = Color3.fromRGB(0,255,120)
logo.Parent = gui
Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)

-- DRAG FUNCTION (มือถือ+คอม)
local function makeDraggable(obj)
	local dragging, dragInput, startPos, startInput

	obj.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
		or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			startInput = input.Position
			startPos = obj.Position
		end
	end)

	obj.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
		or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - startInput
			obj.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	obj.InputEnded:Connect(function()
		dragging = false
	end)
end

makeDraggable(frame)
makeDraggable(logo)

-- MINIMIZE
minBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	logo.Visible = true
end)

logo.MouseButton1Click:Connect(function()
	frame.Visible = true
	logo.Visible = false
end)

-- ================= FUNCTIONS =================

-- FLY
local flyConn
local function startFly()
	local hrp = getChar():WaitForChild("HumanoidRootPart")

	local bv = Instance.new("BodyVelocity", hrp)
	local bg = Instance.new("BodyGyro", hrp)

	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

	flyConn = RunService.RenderStepped:Connect(function()
		if not flyEnabled then return end

		local cam = workspace.CurrentCamera
		local move = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end

		bv.Velocity = move * flySpeed
		bg.CFrame = cam.CFrame
	end)
end

-- NOCLIP
local noclipConn
local function startNoclip()
	noclipConn = RunService.Stepped:Connect(function()
		for _,v in pairs(getChar():GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end)
end

local function stopNoclip()
	if noclipConn then noclipConn:Disconnect() end
end

-- ================= UI ROW =================
local function createRow(text, y, callback)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1,-20,0,50)
	row.Position = UDim2.new(0,10,0,y)
	row.BackgroundColor3 = Color3.fromRGB(35,35,35)
	row.Parent = frame
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel")
	label.Text = "[ "..text.." ]"
	label.TextColor3 = Color3.fromRGB(0,255,120)
	label.Font = Enum.Font.GothamBold
	label.Size = UDim2.new(0.4,0,1,0)
	label.BackgroundTransparency = 1
	label.Parent = row

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0,80,0,30)
	toggle.Position = UDim2.new(1,-90,0.5,-15)
	toggle.Text = "OFF"
	toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)
	toggle.Parent = row
	Instance.new("UICorner", toggle)

	local state = false

	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = state and "ON" or "OFF"
		toggle.BackgroundColor3 = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(80,80,80)
		callback(state)
	end)
end

-- ================= CREATE ROWS =================

createRow("FLY",40,function(v)
	flyEnabled = v
	if v then startFly() end
end)

createRow("SPEED",100,function(v)
	speedEnabled = v
	humanoid.WalkSpeed = v and walkSpeed or 16
end)

createRow("JUMP",160,function(v)
	jumpEnabled = v
	humanoid.JumpPower = v and jumpPower or 50
end)

createRow("NOCLIP",220,function(v)
	noclipEnabled = v
	if v then startNoclip() else stopNoclip() end
end)

-- ================= RESET ON RESPAWN =================
player.CharacterAdded:Connect(function()
	humanoid = getHumanoid()

	if speedEnabled then humanoid.WalkSpeed = walkSpeed end
	if jumpEnabled then humanoid.JumpPower = jumpPower end
	if noclipEnabled then startNoclip() end
	if flyEnabled then startFly() end
end)
