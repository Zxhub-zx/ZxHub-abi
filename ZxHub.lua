-- ZxHub PRO FIX

local player = game.Players.LocalPlayer
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

-- ================= CHARACTER =================
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	return getChar():WaitForChild("Humanoid")
end

local humanoid = getHumanoid()

-- ================= GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

-- MAIN
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 520, 0, 360)
frame.Position = UDim2.new(0.5,-260,0.5,-180)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

-- GLOW
local glow = Instance.new("UIStroke", frame)
glow.Color = Color3.fromRGB(0,255,120)
glow.Thickness = 2

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ZxHub"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- MIN BUTTON
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- LOGO (วง + glow)
local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,70,0,70)
logo.Position = UDim2.new(0,20,0.5,-35)
logo.Text = "ZX"
logo.Visible = false
logo.BackgroundColor3 = Color3.fromRGB(15,15,15)
logo.TextColor3 = Color3.fromRGB(0,255,120)
Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0)

local stroke = Instance.new("UIStroke", logo)
stroke.Color = Color3.fromRGB(0,255,120)
stroke.Thickness = 2

-- DRAG
local function dragify(obj)
	local drag=false
	local start, pos

	obj.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			drag=true
			start=i.Position
			pos=obj.Position
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
			local d=i.Position-start
			obj.Position=UDim2.new(pos.X.Scale,pos.X.Offset+d.X,pos.Y.Scale,pos.Y.Offset+d.Y)
		end
	end)

	UIS.InputEnded:Connect(function()
		drag=false
	end)
end

dragify(frame)
dragify(logo)

minBtn.MouseButton1Click:Connect(function()
	frame.Visible=false
	logo.Visible=true
end)

logo.MouseButton1Click:Connect(function()
	frame.Visible=true
	logo.Visible=false
end)

-- ================= SYSTEM =================

-- FLY
local flyConn, bv, bg

local function startFly()
	local hrp = getChar():WaitForChild("HumanoidRootPart")

	bv = Instance.new("BodyVelocity", hrp)
	bg = Instance.new("BodyGyro", hrp)

	bv.MaxForce = Vector3.new(1e6,1e6,1e6)
	bg.MaxTorque = Vector3.new(1e6,1e6,1e6)

	flyConn = RunService.RenderStepped:Connect(function()
		if not flyEnabled then return end

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

		bv.Velocity = dir * flySpeed
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	if flyConn then flyConn:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

-- NOCLIP
local noclipConn
local function startNoclip()
	noclipConn = RunService.Stepped:Connect(function()
		for _,v in pairs(getChar():GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide=false
			end
		end
	end)
end

local function stopNoclip()
	if noclipConn then noclipConn:Disconnect() end
end

-- ================= UI ROW =================
local function createRow(name,y,get,set,toggleFunc)

	local row = Instance.new("Frame", frame)
	row.Size = UDim2.new(1,-20,0,60)
	row.Position = UDim2.new(0,10,0,y)
	row.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,12)

	-- label
	local lbl = Instance.new("TextLabel",row)
	lbl.Text = "[ "..name.." ]"
	lbl.TextColor3 = Color3.fromRGB(0,255,120)
	lbl.Font = Enum.Font.GothamBold
	lbl.Size = UDim2.new(0.3,0,1,0)
	lbl.BackgroundTransparency=1

	-- value box
	local box = Instance.new("TextBox",row)
	box.Size = UDim2.new(0,60,0,30)
	box.Position = UDim2.new(0.4,0,0.5,-15)
	box.Text = tostring(get())
	box.BackgroundColor3 = Color3.fromRGB(60,60,60)

	box.FocusLost:Connect(function()
		local v = tonumber(box.Text)
		if v then
			set(v)
		end
	end)

	-- toggle
	local toggle = Instance.new("TextButton",row)
	toggle.Size = UDim2.new(0,80,0,30)
	toggle.Position = UDim2.new(1,-90,0.5,-15)
	toggle.Text = "OFF"
	toggle.BackgroundColor3 = Color3.fromRGB(80,80,80)

	local state=false
	toggle.MouseButton1Click:Connect(function()
		state=not state
		toggle.Text = state and "ON" or "OFF"
		toggle.BackgroundColor3 = state and Color3.fromRGB(0,200,100) or Color3.fromRGB(80,80,80)
		toggleFunc(state)
	end)
end

-- ================= CREATE =================

createRow("FLY",50,
	function() return flySpeed end,
	function(v) flySpeed=v end,
	function(s)
		flyEnabled=s
		if s then startFly() else stopFly() end
	end
)

createRow("SPEED",120,
	function() return walkSpeed end,
	function(v) walkSpeed=v if speedEnabled then humanoid.WalkSpeed=v end end,
	function(s)
		speedEnabled=s
		humanoid.WalkSpeed = s and walkSpeed or 16
	end
)

createRow("JUMP",190,
	function() return jumpPower end,
	function(v) jumpPower=v if jumpEnabled then humanoid.JumpPower=v end end,
	function(s)
		jumpEnabled=s
		humanoid.JumpPower = s and jumpPower or 50
	end
)

createRow("NOCLIP",260,
	function() return 0 end,
	function() end,
	function(s)
		noclipEnabled=s
		if s then startNoclip() else stopNoclip() end
	end
)

-- RESPAWN FIX
player.CharacterAdded:Connect(function()
	humanoid = getHumanoid()

	if speedEnabled then humanoid.WalkSpeed=walkSpeed end
	if jumpEnabled then humanoid.JumpPower=jumpPower end
	if noclipEnabled then startNoclip() end
	if flyEnabled then startFly() end
end)
