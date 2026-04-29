-- ZxHub PRO FINAL (UI FIX + MOBILE FLY FIX + ANTI BUG)

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
-- ลบ GUI เก่ากันซ้อน
pcall(function()
	if player.PlayerGui:FindFirstChild("ZxHubGUI") then
		player.PlayerGui.ZxHubGUI:Destroy()
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "ZxHubGUI"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ================= MAIN FRAME =================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 520, 0, 360)
frame.Position = UDim2.new(0.5,-260,0.5,-180)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true -- สำคัญ (กันบาง executor ไม่โชว์)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

local glow = Instance.new("UIStroke", frame)
glow.Color = Color3.fromRGB(0,255,120)
glow.Thickness = 2

-- ================= TITLE =================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ZxHub"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- ================= MINIMIZE =================
local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

-- ================= LOGO =================
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

-- ================= MOBILE FLY =================
local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0,60,0,60)
upBtn.Position = UDim2.new(1,-80,0.7,0)
upBtn.Text = "↑"
upBtn.Visible = false
upBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0,60,0,60)
downBtn.Position = UDim2.new(1,-80,0.8,0)
downBtn.Text = "↓"
downBtn.Visible = false
downBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)

-- ================= DRAG =================
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
		if drag then
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

-- ================= FLY =================
local flyConn, bv, bg

local function startFly()
	local hrp = getChar():WaitForChild("HumanoidRootPart")

	if bv then bv:Destroy() end
	if bg then bg:Destroy() end

	bv = Instance.new("BodyVelocity", hrp)
	bg = Instance.new("BodyGyro", hrp)

	bv.MaxForce = Vector3.new(1e6,1e6,1e6)
	bg.MaxTorque = Vector3.new(1e6,1e6,1e6)

	upBtn.Visible = true
	downBtn.Visible = true

	flyConn = RunService.RenderStepped:Connect(function()
		if not flyEnabled then return end

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

		if up then dir += Vector3.new(0,1,0) end
		if down then dir -= Vector3.new(0,1,0) end

		bv.Velocity = dir * flySpeed
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	if flyConn then flyConn:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	upBtn.Visible = false
	downBtn.Visible = false
end

upBtn.MouseButton1Down:Connect(function() up=true end)
upBtn.MouseButton1Up:Connect(function() up=false end)
downBtn.MouseButton1Down:Connect(function() down=true end)
downBtn.MouseButton1Up:Connect(function() down=false end)

-- ================= NOCLIP =================
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

-- ================= (ส่วน UI ROW ของนาย 그대로 ไม่แก้) =================
-- (ตัดไม่ออก แต่ใช้ของเดิมนายได้เลย)

-- ================= CREATE =================
-- ใช้ของเดิมนายได้เลย

-- ================= RESPAWN FIX =================
player.CharacterAdded:Connect(function()
	task.wait(1)
	humanoid = getHumanoid()

	if speedEnabled then humanoid.WalkSpeed=walkSpeed end
	if jumpEnabled then humanoid.JumpPower=jumpPower end
	if noclipEnabled then startNoclip() end
	if flyEnabled then startFly() end
end)
