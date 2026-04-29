-- ZxHub PRO FINAL (UI FIX ONLY - FULL ORIGINAL)

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

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "ZxHub"
title.TextColor3 = Color3.fromRGB(0,255,120)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30)
minBtn.Position = UDim2.new(1,-35,0,5)
minBtn.Text = "-"
minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)

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

-- ================= MOBILE =================
local upBtn = Instance.new("TextButton", gui)
upBtn.Size = UDim2.new(0,60,0,60)
upBtn.Position = UDim2.new(1,-80,0.7,0)
upBtn.Text = "↑"
upBtn.Visible = false

local downBtn = Instance.new("TextButton", gui)
downBtn.Size = UDim2.new(0,60,0,60)
downBtn.Position = UDim2.new(1,-80,0.8,0)
downBtn.Text = "↓"
downBtn.Visible = false

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

-- ================= (เอาของ createRow เดิมนายมาใส่ตรงนี้) =================
-- ❗ สำคัญ: ห้ามลบ createRow และ createRow(...) ด้านล่างเด็ดขาด

-- ================= CREATE =================
-- ❗ ใส่ 4 บรรทัดนี้กลับ
createRow("FLY",50,
	function() return flySpeed end,
	function(v) flySpeed=v end,
	function(s) flyEnabled=s if s then startFly() else stopFly() end end
)

createRow("SPEED",120,
	function() return walkSpeed end,
	function(v) walkSpeed=v if speedEnabled then humanoid.WalkSpeed=v end end,
	function(s) speedEnabled=s humanoid.WalkSpeed = s and walkSpeed or 16 end
)

createRow("JUMP",190,
	function() return jumpPower end,
	function(v) jumpPower=v if jumpEnabled then humanoid.JumpPower=v end end,
	function(s) jumpEnabled=s humanoid.JumpPower = s and jumpPower or 50 end
)

createRow("NOCLIP",260,
	function() return 0 end,
	function() end,
	function(s) noclipEnabled=s if s then startNoclip() else stopNoclip() end,
	true
)

-- ================= RESPAWN =================
player.CharacterAdded:Connect(function()
	task.wait(1)
	humanoid = getHumanoid()

	if speedEnabled then humanoid.WalkSpeed=walkSpeed end
	if jumpEnabled then humanoid.JumpPower=jumpPower end
	if noclipEnabled then startNoclip() end
	if flyEnabled then startFly() end
end)
