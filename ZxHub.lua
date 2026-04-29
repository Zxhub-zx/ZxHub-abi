-- ZxHub PRO FINAL (COMPLETE)

-- ================= SAFE LOAD =================
if not game:IsLoaded() then
	game.Loaded:Wait()
end

local player = game.Players.LocalPlayer
repeat task.wait() until player:FindFirstChild("PlayerGui")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ================= STATE =================
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false

local flySpeed = 8
local walkSpeed = 16
local jumpPower = 50

local up = false
local down = false

-- ================= CHARACTER =================
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- ================= GUI FIX =================
pcall(function()
	if player.PlayerGui:FindFirstChild("ZxHubGUI") then
		player.PlayerGui.ZxHubGUI:Destroy()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ZxHubGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ================= GUI =================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 520, 0, 360)
frame.Position = UDim2.new(0.5,-260,0.5,-180)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Visible = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local glow = Instance.new("UIStroke", frame)
glow.Color = Color3.fromRGB(0,255,120)
glow.Thickness = 2

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1,0,0,40)
topBar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "ZxHub"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Enum.TextXAlignment.Center

local credit = Instance.new("TextLabel", topBar)
credit.Size = UDim2.new(0, 200, 1, 0)
credit.Position = UDim2.new(0, 10, 0, 0)
credit.BackgroundTransparency = 1
credit.Text = "by : YouTube ZXzn9"
credit.TextColor3 = Color3.fromRGB(0,255,120)
credit.Font = Enum.Font.GothamBold
credit.TextSize = 14
credit.TextXAlignment = Enum.TextXAlignment.Left


local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
minBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,70,0,70)
logo.Position = UDim2.new(0,20,0.5,-35)
logo.Text = "ZX"
logo.Visible = false
logo.BackgroundColor3 = Color3.fromRGB(15,15,15)
logo.TextColor3 = Color3.fromRGB(0,255,120)
logo.Font = Enum.Font.GothamBold
logo.TextSize = 18
Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", logo)
stroke.Color = Color3.fromRGB(0,255,120)
stroke.Thickness = 2

-- ================= MOBILE BUTTONS =================
local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0,60,0,60)
upBtn.Position = UDim2.new(1,-80,0.7,0)
upBtn.Text = "↑"
upBtn.Visible = false
upBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
upBtn.TextColor3 = Color3.fromRGB(0,255,120)
upBtn.Font = Enum.Font.GothamBold
upBtn.TextSize = 24
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(0,10)

local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0,60,0,60)
downBtn.Position = UDim2.new(1,-80,0.8,0)
downBtn.Text = "↓"
downBtn.Visible = false
downBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
downBtn.TextColor3 = Color3.fromRGB(0,255,120)
downBtn.Font = Enum.Font.GothamBold
downBtn.TextSize = 24
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0,10)

upBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		up = true
	end
end)
upBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		up = false
	end
end)

downBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		down = true
	end
end)
downBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
		down = false
	end
end)

-- ================= KEYBOARD UP/DOWN =================
UIS.InputBegan:Connect(function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.Space then up = true end
	if i.KeyCode == Enum.KeyCode.LeftControl then down = true end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.Space then up = false end
	if i.KeyCode == Enum.KeyCode.LeftControl then down = false end
end)

-- ================= DRAG =================
local function dragify(obj)
	local drag = false
	local start, pos

	obj.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			start = i.Position
			pos = obj.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if drag then
			local d = i.Position - start
			obj.Position = UDim2.new(pos.X.Scale, pos.X.Offset+d.X, pos.Y.Scale, pos.Y.Offset+d.Y)
		end
	end)

	UIS.InputEnded:Connect(function()
		drag = false
	end)
end

dragify(frame)
dragify(logo)

minBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	logo.Visible = true
end)

logo.MouseButton1Click:Connect(function()
	frame.Visible = true
	logo.Visible = false
end)

-- ================= FLY =================
local flyConn
local flyBV, flyBG

local function startFly()
	local char = getChar()
	local root = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	hum.PlatformStand = true

	flyBG = Instance.new("BodyGyro", root)
	flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
	flyBG.D = 50

	flyBV = Instance.new("BodyVelocity", root)
	flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
	flyBV.Velocity = Vector3.zero

	upBtn.Visible = true
	downBtn.Visible = true

	flyConn = RunService.Heartbeat:Connect(function()
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		local moveVec = UIS:GetStringForKeyCode(Enum.KeyCode.Thumbstick1) ~= "" 
			and Vector3.zero or Vector3.zero

		local thumbstick = UIS:GetConnectedGamepads()
		local hum2 = char:FindFirstChildOfClass("Humanoid")
		if hum2 then
			local md = hum2.MoveDirection
			if md.Magnitude > 0.1 then
				dir += Vector3.new(md.X, 0, md.Z)
			end
		end

		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if up then dir += Vector3.new(0,1,0) end
		if down then dir -= Vector3.new(0,1,0) end

		if dir.Magnitude > 1 then dir = dir.Unit end

		flyBV.Velocity = dir * flySpeed
		flyBG.CFrame = cam.CFrame
	end)
end

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end

	upBtn.Visible = false
	downBtn.Visible = false

	pcall(function()
		getChar():WaitForChild("Humanoid").PlatformStand = false
	end)
end

-- ================= NOCLIP =================
local noclipConn

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
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	local char = player.Character
	if char then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

-- ================= CREATE ROW =================
local function createRow(name, yPos, getVal, setVal, toggle, noSlider)
	local row = Instance.new("Frame", frame)
	row.Size = UDim2.new(1,-20,0,50)
	row.Position = UDim2.new(0,10,0,yPos)
	row.BackgroundColor3 = Color3.fromRGB(30,30,30)
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0,80,1,0)
	label.Position = UDim2.new(0,10,0,0)
	label.BackgroundTransparency = 1
	label.Text = name
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local togBtn = Instance.new("TextButton", row)
	togBtn.Size = UDim2.new(0,54,0,28)
	togBtn.Position = UDim2.new(1,-64,0.5,-14)
	togBtn.Text = "OFF"
	togBtn.Font = Enum.Font.GothamBold
	togBtn.TextSize = 12
	togBtn.TextColor3 = Color3.fromRGB(255,255,255)
	togBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
	Instance.new("UICorner", togBtn).CornerRadius = UDim.new(0,6)

	local on = false
	togBtn.MouseButton1Click:Connect(function()
		on = not on
		togBtn.Text = on and "ON" or "OFF"
		togBtn.BackgroundColor3 = on and Color3.fromRGB(0,200,80) or Color3.fromRGB(80,80,80)
		toggle(on)
	end)

	if not noSlider then
		local maxVal = 500

		local sliderBg = Instance.new("Frame", row)
		sliderBg.Size = UDim2.new(0,140,0,10)
		sliderBg.Position = UDim2.new(0,90,0.5,-5)
		sliderBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

		local fill = Instance.new("Frame", sliderBg)
		fill.Size = UDim2.new(getVal()/maxVal, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0,255,120)
		fill.BorderSizePixel = 0
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

		local valBox = Instance.new("TextBox", row)
		valBox.Size = UDim2.new(0,45,0,26)
		valBox.Position = UDim2.new(0,235,0.5,-13)
		valBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
		valBox.TextColor3 = Color3.fromRGB(0,255,120)
		valBox.Font = Enum.Font.GothamBold
		valBox.TextSize = 13
		valBox.Text = tostring(getVal())
		valBox.ClearTextOnFocus = true
		Instance.new("UICorner", valBox).CornerRadius = UDim.new(0,4)

		local function applyVal(v)
			v = math.clamp(math.floor(v), 0, maxVal)
			fill.Size = UDim2.new(v/maxVal, 0, 1, 0)
			valBox.Text = tostring(v)
			setVal(v)
		end

		valBox.FocusLost:Connect(function(enterPressed)
			local num = tonumber(valBox.Text)
			if num then
				applyVal(num)
			else
				valBox.Text = tostring(getVal())
			end
		end)

		local dragging = false

		local function updateSlider(input)
			local rel = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
			rel = math.clamp(rel, 0, 1)
			applyVal(math.floor(rel * maxVal))
		end

		sliderBg.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				updateSlider(i)
			end
		end)

		UIS.InputChanged:Connect(function(i)
			if dragging then updateSlider(i) end
		end)

		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
end

-- ================= CREATE ROWS =================
createRow("FLY", 50,
	function() return flySpeed end,
	function(v) flySpeed = v end,
	function(s) flyEnabled = s if s then startFly() else stopFly() end end
)

createRow("SPEED", 120,
	function() return walkSpeed end,
	function(v) walkSpeed = v if speedEnabled then humanoid.WalkSpeed = v end end,
	function(s) speedEnabled = s humanoid.WalkSpeed = s and walkSpeed or 16 end
)

createRow("JUMP", 190,
	function() return jumpPower end,
	function(v) jumpPower = v if jumpEnabled then humanoid.JumpPower = v end end,
	function(s) jumpEnabled = s humanoid.JumpPower = s and jumpPower or 50 end
)

createRow("NOCLIP", 260,
	function() return 0 end,
	function() end,
	function(s) noclipEnabled = s if s then startNoclip() else stopNoclip() end end,
	true
)

-- ================= RESPAWN =================
player.CharacterAdded:Connect(function()
	task.wait(1)
	humanoid = getHumanoid()

	if speedEnabled then humanoid.WalkSpeed = walkSpeed end
	if jumpEnabled then humanoid.JumpPower = jumpPower end
	if noclipEnabled then startNoclip() end
	if flyEnabled then startFly() end
end)
