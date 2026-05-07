if not game:IsLoaded() then
	game.Loaded:Wait()
end

local player = game.Players.LocalPlayer
repeat task.wait() until player:FindFirstChild("PlayerGui")

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local noclipEnabled = false
local espEnabled = false
local freecamEnabled = false

local flySpeed = 8
local walkSpeed = 16
local jumpPower = 50
local freecamSpeed = 2

local up = false
local down = false
local moveForward = false
local moveBack = false
local moveLeft = false
local moveRight = false

local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

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
topBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
topBar.BackgroundTransparency = 0.5
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,14)

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

-- ================= TAB BUTTONS =================
local tab1Btn = Instance.new("TextButton", frame)
tab1Btn.Size = UDim2.new(0,100,0,28)
tab1Btn.Position = UDim2.new(0,10,0,42)
tab1Btn.Text = "หน้า 1"
tab1Btn.Font = Enum.Font.GothamBold
tab1Btn.TextSize = 13
tab1Btn.TextColor3 = Color3.fromRGB(0,0,0)
tab1Btn.BackgroundColor3 = Color3.fromRGB(0,255,120)
Instance.new("UICorner", tab1Btn).CornerRadius = UDim.new(0,6)

local tab2Btn = Instance.new("TextButton", frame)
tab2Btn.Size = UDim2.new(0,100,0,28)
tab2Btn.Position = UDim2.new(0,120,0,42)
tab2Btn.Text = "หน้า 2"
tab2Btn.Font = Enum.Font.GothamBold
tab2Btn.TextSize = 13
tab2Btn.TextColor3 = Color3.fromRGB(255,255,255)
tab2Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", tab2Btn).CornerRadius = UDim.new(0,6)

local tab3Btn = Instance.new("TextButton", frame)
tab3Btn.Size = UDim2.new(0,100,0,28)
tab3Btn.Position = UDim2.new(0,230,0,42)
tab3Btn.Text = "หน้า 3"
tab3Btn.Font = Enum.Font.GothamBold
tab3Btn.TextSize = 13
tab3Btn.TextColor3 = Color3.fromRGB(255,255,255)
tab3Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
Instance.new("UICorner", tab3Btn).CornerRadius = UDim.new(0,6)

-- ================= PAGE CONTAINERS =================
local page1 = Instance.new("ScrollingFrame", frame)
page1.Size = UDim2.new(1,0,1,-80)
page1.Position = UDim2.new(0,0,0,78)
page1.BackgroundTransparency = 1
page1.Visible = true
page1.ScrollBarThickness = 3
page1.CanvasSize = UDim2.new(0,0,0,450)

local page2 = Instance.new("ScrollingFrame", frame)
page2.Size = UDim2.new(1,0,1,-80)
page2.Position = UDim2.new(0,0,0,78)
page2.BackgroundTransparency = 1
page2.Visible = false
page2.ScrollBarThickness = 3
page2.CanvasSize = UDim2.new(0,0,0,600)

local page3 = Instance.new("ScrollingFrame", frame)
page3.Size = UDim2.new(1,0,1,-80)
page3.Position = UDim2.new(0,0,0,78)
page3.BackgroundTransparency = 1
page3.Visible = false
page3.ScrollBarThickness = 3
page3.CanvasSize = UDim2.new(0,0,0,600)

local function switchTab(pg)
	if pg == 1 then
		page1.Visible = true
		page2.Visible = false
		page3.Visible = false
		tab1Btn.BackgroundColor3 = Color3.fromRGB(0,255,120)
		tab1Btn.TextColor3 = Color3.fromRGB(0,0,0)
		tab2Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tab2Btn.TextColor3 = Color3.fromRGB(255,255,255)
		tab3Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tab3Btn.TextColor3 = Color3.fromRGB(255,255,255)
	elseif pg == 2 then
		page1.Visible = false
		page2.Visible = true
		page3.Visible = false
		tab2Btn.BackgroundColor3 = Color3.fromRGB(0,255,120)
		tab2Btn.TextColor3 = Color3.fromRGB(0,0,0)
		tab1Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tab1Btn.TextColor3 = Color3.fromRGB(255,255,255)
		tab3Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tab3Btn.TextColor3 = Color3.fromRGB(255,255,255)
	else
		page1.Visible = false
		page2.Visible = false
		page3.Visible = true
		tab3Btn.BackgroundColor3 = Color3.fromRGB(0,255,120)
		tab3Btn.TextColor3 = Color3.fromRGB(0,0,0)
		tab1Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tab1Btn.TextColor3 = Color3.fromRGB(255,255,255)
		tab2Btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
		tab2Btn.TextColor3 = Color3.fromRGB(255,255,255)
	end
end

tab1Btn.MouseButton1Click:Connect(function() switchTab(1) end)
tab2Btn.MouseButton1Click:Connect(function() switchTab(2) end)
tab3Btn.MouseButton1Click:Connect(function() switchTab(3) end)

-- ================= LOGO / DRAG =================
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

-- ================= MOVE BUTTONS (ซ้าย/ขวา/หน้า/หลัง) =================
local moveForwardBtn = Instance.new("TextButton", gui)
moveForwardBtn.Size = UDim2.new(0,60,0,60)
moveForwardBtn.Position = UDim2.new(0,80,0.7,0)
moveForwardBtn.Text = "▲"
moveForwardBtn.Visible = false
moveForwardBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
moveForwardBtn.TextColor3 = Color3.fromRGB(0,255,120)
moveForwardBtn.Font = Enum.Font.GothamBold
moveForwardBtn.TextSize = 24
Instance.new("UICorner", moveForwardBtn).CornerRadius = UDim.new(0,10)

local moveBackBtn = Instance.new("TextButton", gui)
moveBackBtn.Size = UDim2.new(0,60,0,60)
moveBackBtn.Position = UDim2.new(0,80,0.8,0)
moveBackBtn.Text = "▼"
moveBackBtn.Visible = false
moveBackBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
moveBackBtn.TextColor3 = Color3.fromRGB(0,255,120)
moveBackBtn.Font = Enum.Font.GothamBold
moveBackBtn.TextSize = 24
Instance.new("UICorner", moveBackBtn).CornerRadius = UDim.new(0,10)

local moveLeftBtn = Instance.new("TextButton", gui)
moveLeftBtn.Size = UDim2.new(0,60,0,60)
moveLeftBtn.Position = UDim2.new(0,15,0.75,0)
moveLeftBtn.Text = "◄"
moveLeftBtn.Visible = false
moveLeftBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
moveLeftBtn.TextColor3 = Color3.fromRGB(0,255,120)
moveLeftBtn.Font = Enum.Font.GothamBold
moveLeftBtn.TextSize = 24
Instance.new("UICorner", moveLeftBtn).CornerRadius = UDim.new(0,10)

local moveRightBtn = Instance.new("TextButton", gui)
moveRightBtn.Size = UDim2.new(0,60,0,60)
moveRightBtn.Position = UDim2.new(0,145,0.75,0)
moveRightBtn.Text = "►"
moveRightBtn.Visible = false
moveRightBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
moveRightBtn.TextColor3 = Color3.fromRGB(0,255,120)
moveRightBtn.Font = Enum.Font.GothamBold
moveRightBtn.TextSize = 24
Instance.new("UICorner", moveRightBtn).CornerRadius = UDim.new(0,10)

-- bind move buttons
moveForwardBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveForward = true end
end)
moveForwardBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveForward = false end
end)
moveBackBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveBack = true end
end)
moveBackBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveBack = false end
end)
moveLeftBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveLeft = true end
end)
moveLeftBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveLeft = false end
end)
moveRightBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveRight = true end
end)
moveRightBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then moveRight = false end
end)

upBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then up = true end
end)
upBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then up = false end
end)
downBtn.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then down = true end
end)
downBtn.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then down = false end
end)

local function dragify(target, handle)
	local drag = false
	local start, pos
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			start = i.Position
			pos = target.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag then
			local d = i.Position - start
			target.Position = UDim2.new(pos.X.Scale, pos.X.Offset+d.X, pos.Y.Scale, pos.Y.Offset+d.Y)
		end
	end)
	UIS.InputEnded:Connect(function() drag = false end)
end

dragify(frame, topBar)
dragify(logo, logo)

minBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	logo.Visible = true
end)
logo.MouseButton1Click:Connect(function()
	frame.Visible = true
	logo.Visible = false
end)

-- ================= FREECAM =================
local freecamPart
local freecamConn

local function setMoveButtonsVisible(val)
	moveForwardBtn.Visible = val
	moveBackBtn.Visible = val
	moveLeftBtn.Visible = val
	moveRightBtn.Visible = val
end

local function startFreecam()
	local char = getChar()
	local root = char:WaitForChild("HumanoidRootPart")
	local cam = workspace.CurrentCamera
	root.Anchored = true
	freecamPart = Instance.new("Part")
	freecamPart.Size = Vector3.new(1,1,1)
	freecamPart.Transparency = 1
	freecamPart.CanCollide = false
	freecamPart.Anchored = true
	freecamPart.CFrame = cam.CFrame
	freecamPart.Parent = workspace
	cam.CameraSubject = freecamPart
	upBtn.Visible = true
	downBtn.Visible = true
	setMoveButtonsVisible(true)
	freecamConn = RunService.RenderStepped:Connect(function()
		local moveDir = Vector3.new(0,0,0)
		local cf = cam.CFrame
		if UIS:IsKeyDown(Enum.KeyCode.W) or moveForward then moveDir += cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) or moveBack then moveDir -= cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) or moveLeft then moveDir -= cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) or moveRight then moveDir += cf.RightVector end
		if up then moveDir += Vector3.new(0,1,0) end
		if down then moveDir -= Vector3.new(0,1,0) end
		if moveDir.Magnitude > 0 then
			freecamPart.CFrame = freecamPart.CFrame + (moveDir.Unit * freecamSpeed)
		end
	end)
end

local function stopFreecam()
	if freecamConn then freecamConn:Disconnect() freecamConn = nil end
	if freecamPart then freecamPart:Destroy() freecamPart = nil end
	local char = getChar()
	char:WaitForChild("HumanoidRootPart").Anchored = false
	workspace.CurrentCamera.CameraSubject = char:WaitForChild("Humanoid")
	upBtn.Visible = false
	downBtn.Visible = false
	setMoveButtonsVisible(false)
end

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
	pcall(function() getChar():WaitForChild("Humanoid").PlatformStand = false end)
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
			if part:IsA("BasePart") then part.CanCollide = true end
		end
	end
end

-- ================= ESP =================
local espObjects = {}

local function addESP(target)
	if target == player then return end
	local char = target.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	local hl = Instance.new("SelectionBox")
	hl.Adornee = char
	hl.Color3 = Color3.fromRGB(255,255,255)
	hl.LineThickness = 0.05
	hl.SurfaceTransparency = 0.7
	hl.SurfaceColor3 = Color3.fromRGB(255,255,255)
	hl.Parent = gui
	local bb = Instance.new("BillboardGui")
	bb.Adornee = root
	bb.Size = UDim2.new(0,100,0,30)
	bb.StudsOffset = Vector3.new(0,3,0)
	bb.AlwaysOnTop = true
	bb.Parent = gui
	local nameLabel = Instance.new("TextLabel", bb)
	nameLabel.Size = UDim2.new(1,0,1,0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = target.Name
	nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.TextStrokeTransparency = 0
	espObjects[target] = {hl, bb}
end

local function removeESP(target)
	if espObjects[target] then
		for _, obj in ipairs(espObjects[target]) do obj:Destroy() end
		espObjects[target] = nil
	end
end

local function startESP()
	for _, p in ipairs(game.Players:GetPlayers()) do addESP(p) end
	game.Players.PlayerAdded:Connect(function(p)
		if espEnabled then
			p.CharacterAdded:Connect(function()
				task.wait(1)
				addESP(p)
			end)
		end
	end)
end

local function stopESP()
	for _, p in ipairs(game.Players:GetPlayers()) do removeESP(p) end
end

-- ================= CREATE ROW =================
local function createRow(parent, name, yPos, getVal, setVal, toggle, noSlider, maxOverride)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1,-20,0,50)
	row.Position = UDim2.new(0,10,0,yPos)
	row.BackgroundColor3 = Color3.fromRGB(30,30,30)
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0,120,1,0)
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
		local maxVal = maxOverride or 500
		local sliderBg = Instance.new("Frame", row)
		sliderBg.Size = UDim2.new(0,140,0,10)
		sliderBg.Position = UDim2.new(0,130,0.5,-5)
		sliderBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1,0)

		local fill = Instance.new("Frame", sliderBg)
		fill.Size = UDim2.new(getVal()/maxVal, 0, 1, 0)
		fill.BackgroundColor3 = Color3.fromRGB(0,255,120)
		fill.BorderSizePixel = 0
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

		local valBox = Instance.new("TextBox", row)
		valBox.Size = UDim2.new(0,45,0,26)
		valBox.Position = UDim2.new(0,275,0.5,-13)
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

		valBox.FocusLost:Connect(function()
			local num = tonumber(valBox.Text)
			if num then applyVal(num) else valBox.Text = tostring(getVal()) end
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
		UIS.InputChanged:Connect(function(i) if dragging then updateSlider(i) end end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end
end

-- ================= PAGE 1 ROWS =================
createRow(page1, "FLY", 5,
	function() return flySpeed end,
	function(v) flySpeed = v end,
	function(s) flyEnabled = s if s then startFly() else stopFly() end end
)
createRow(page1, "SPEED", 65,
	function() return walkSpeed end,
	function(v) walkSpeed = v if speedEnabled then humanoid.WalkSpeed = v end end,
	function(s) speedEnabled = s humanoid.WalkSpeed = s and walkSpeed or 16 end
)
createRow(page1, "JUMP", 125,
	function() return jumpPower end,
	function(v) jumpPower = v if jumpEnabled then humanoid.JumpPower = v end end,
	function(s) jumpEnabled = s humanoid.JumpPower = s and jumpPower or 50 end
)
createRow(page1, "NOCLIP", 185,
	function() return 0 end,
	function() end,
	function(s) noclipEnabled = s if s then startNoclip() else stopNoclip() end end,
	true
)

-- ================= PAGE 2 (ESP & FREECAM) =================
createRow(page2, "ESP", 5,
	function() return 0 end,
	function() end,
	function(s) espEnabled = s if s then startESP() else stopESP() end end,
	true
)
-- FREECAM slider max = 5
createRow(page2, "FREECAM", 65,
	function() return freecamSpeed end,
	function(v) freecamSpeed = v end,
	function(s) freecamEnabled = s if s then startFreecam() else stopFreecam() end end,
	false,
	5
)

-- ================= TELEPORT SYSTEM =================
local tpRow = Instance.new("Frame", page2)
tpRow.Size = UDim2.new(1,-20,0,50)
tpRow.Position = UDim2.new(0,10,0,125)
tpRow.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner", tpRow).CornerRadius = UDim.new(0,8)

local tpLabel = Instance.new("TextLabel", tpRow)
tpLabel.Size = UDim2.new(1,0,1,0)
tpLabel.BackgroundTransparency = 1
tpLabel.Text = "TELEPORT SYSTEM"
tpLabel.TextColor3 = Color3.new(1,1,1)
tpLabel.Font = Enum.Font.GothamBold
tpLabel.TextSize = 14

local tpList = Instance.new("Frame", page2)
tpList.Size = UDim2.new(1,-20,0,200)
tpList.Position = UDim2.new(0,10,0,180)
tpList.BackgroundColor3 = Color3.fromRGB(15,15,15)
tpList.Visible = false
Instance.new("UICorner", tpList).CornerRadius = UDim.new(0,8)

local listScroll = Instance.new("ScrollingFrame", tpList)
listScroll.Size = UDim2.new(1,-10,1,-10)
listScroll.Position = UDim2.new(0,5,0,5)
listScroll.BackgroundTransparency = 1
listScroll.ScrollBarThickness = 2

local listLayout = Instance.new("UIListLayout", listScroll)
listLayout.Padding = UDim.new(0,5)

local function updateTPList()
	for _,v in pairs(listScroll:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
	for _,p in pairs(game.Players:GetPlayers()) do
		if p ~= player then
			local btn = Instance.new("TextButton", listScroll)
			btn.Size = UDim2.new(1,0,0,30)
			btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
			btn.Text = p.Name
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
			btn.MouseButton1Click:Connect(function()
				if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					getChar():SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame)
				end
			end)
		end
	end
	listScroll.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
end

local tpMainBtn = Instance.new("TextButton", tpRow)
tpMainBtn.Size = UDim2.new(1,0,1,0)
tpMainBtn.BackgroundTransparency = 1
tpMainBtn.Text = ""
tpMainBtn.MouseButton1Click:Connect(function()
	tpList.Visible = not tpList.Visible
	if tpList.Visible then updateTPList() end
end)

-- ================= CHARACTER RELOAD =================
player.CharacterAdded:Connect(function()
	humanoid = getHumanoid()
	if flyEnabled then task.wait(0.5) startFly() end
	if speedEnabled then humanoid.WalkSpeed = walkSpeed end
	if jumpEnabled then humanoid.JumpPower = jumpPower end
	if noclipEnabled then startNoclip() end
end)
