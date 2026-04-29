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

local flySpeed = 8
local walkSpeed = 16
local jumpPower = 50

local up = false
local down = false

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

local credit = Instance.new("TextLabel", topBar)
credit.Size = UDim2.new(0,200,1,0)
credit.Position = UDim2.new(0,10,0,0)
credit.BackgroundTransparency = 1
credit.Text = "by : YouTube ZXzn9"
credit.TextColor3 = Color3.fromRGB(0,255,120)
credit.Font = Enum.Font.GothamBold
credit.TextSize = 14

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.Text = "-"
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,6)

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,70,0,70)
logo.Position = UDim2.new(0,20,0.5,-35)
logo.Text = "ZX"
logo.Visible = false
Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)

local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0,60,0,60)
upBtn.Position = UDim2.new(1,-80,0.7,0)
upBtn.Text = "↑"
upBtn.Visible = false
Instance.new("UICorner", upBtn).CornerRadius = UDim.new(0,10)

local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0,60,0,60)
downBtn.Position = UDim2.new(1,-80,0.8,0)
downBtn.Text = "↓"
downBtn.Visible = false
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0,10)

upBtn.InputBegan:Connect(function(i)
	if i.UserInputType ~= Enum.UserInputType.Keyboard then up = true end
end)
upBtn.InputEnded:Connect(function() up = false end)

downBtn.InputBegan:Connect(function(i)
	if i.UserInputType ~= Enum.UserInputType.Keyboard then down = true end
end)
downBtn.InputEnded:Connect(function() down = false end)

local flyConn, flyBV, flyBG
local noclipConn
local diedConn

local function stopFly()
	if flyConn then flyConn:Disconnect() flyConn = nil end
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end

	upBtn.Visible = false
	downBtn.Visible = false

	local char = player.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
		end
	end
end

local function stopNoclip()
	if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	local char = player.Character
	if char then
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				p.CanCollide = true
			end
		end
	end
end

local function cleanup()
	flyEnabled = false
	noclipEnabled = false
	up = false
	down = false

	stopFly()
	stopNoclip()

	if diedConn then diedConn:Disconnect() diedConn = nil end
	if gui then gui:Destroy() end
end

local function startFly()
	local char = getChar()
	local root = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")

	hum.PlatformStand = true

	flyBG = Instance.new("BodyGyro", root)
	flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)

	flyBV = Instance.new("BodyVelocity", root)
	flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)

	upBtn.Visible = true
	downBtn.Visible = true

	flyConn = RunService.Heartbeat:Connect(function()
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

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

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)

	humanoid = char:WaitForChild("Humanoid")

	if diedConn then diedConn:Disconnect() end

	diedConn = humanoid.Died:Connect(function()
		cleanup()
	end)

	-- 🔥 FIX สำคัญ: กันบินค้าง 100%
	stopFly()
	stopNoclip()

	if flyEnabled then task.wait(0.2) startFly() end
	if noclipEnabled then task.wait(0.2) startNoclip() end
end)
