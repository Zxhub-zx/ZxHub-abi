local player = game.Players.LocalPlayer
local UIS, RunService = game:GetService("UserInputService"), game:GetService("RunService")
local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end

local flyEnabled, speedEnabled, jumpEnabled, noclipEnabled, espEnabled, freecamEnabled = false, false, false, false, false, false
local flySpeed, walkSpeed, jumpPower, freecamSpeed = 8, 16, 50, 2
local moveKeys = {fwd = false, bwd = false, lft = false, rgt = false, up = false, down = false}
local flyConn, noclipConn, espObjects, freecamConn, freecamPart = nil, nil, {}

-- GUI Setup
pcall(function() if player.PlayerGui:FindFirstChild("ZxHubGUI") then player.PlayerGui.ZxHubGUI:Destroy() end end)
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "ZxHubGUI"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 520, 0, 360); frame.Position = UDim2.new(0.5,-260,0.5,-180); frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(0,255,120)

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1,0,0,40); topBar.BackgroundColor3 = Color3.fromRGB(30,30,30); topBar.BackgroundTransparency = 0.5
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0,14)

local function createText(p, txt, sz, pos, align)
	local l = Instance.new("TextLabel", p); l.Size = sz; l.Position = pos; l.BackgroundTransparency = 1
	l.Text = txt; l.TextColor3 = Color3.fromRGB(0,255,120); l.Font = "GothamBold"; l.TextSize = 14; l.TextXAlignment = align; return l
end
createText(topBar, "ZxHub", UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), "Center").TextSize = 22
createText(topBar, "by : YouTube ZXzn9", UDim2.new(0,200,1,0), UDim2.new(0,10,0,0), "Left")

-- Dragging & Minimize
local function dragify(t, h)
	local drag, start, pos
	h.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then drag = true; start = i.Position; pos = t.Position end end)
	UIS.InputChanged:Connect(function(i) if drag then local d = i.Position - start; t.Position = UDim2.new(pos.X.Scale, pos.X.Offset+d.X, pos.Y.Scale, pos.Y.Offset+d.Y) end end)
	UIS.InputEnded:Connect(function() drag = false end)
end
dragify(frame, topBar)

local logo = Instance.new("TextButton", gui)
logo.Size = UDim2.new(0,70,0,70); logo.Position = UDim2.new(0,20,0.5,-35); logo.Visible = false; logo.Text = "ZX"; logo.BackgroundColor3 = Color3.fromRGB(15,15,15); logo.TextColor3 = Color3.fromRGB(0,255,120); logo.Font = "GothamBold"
Instance.new("UICorner", logo).CornerRadius = UDim.new(1,0); dragify(logo, logo)

local minBtn = Instance.new("TextButton", frame)
minBtn.Size = UDim2.new(0,30,0,30); minBtn.Position = UDim2.new(1,-35,0,5); minBtn.Text = "-"; minBtn.BackgroundColor3 = Color3.fromRGB(60,60,60); minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.MouseButton1Click:Connect(function() frame.Visible = false; logo.Visible = true end)
logo.MouseButton1Click:Connect(function() frame.Visible = true; logo.Visible = false end)

-- Controls Buttons (WASD Up Down)
local controls = {}
local btnData = {W = "fwd", S = "bwd", A = "lft", D = "rgt", ["↑"] = "up", ["↓"] = "down"}
local btnPos = {W = UDim2.new(1,-145,0.7,0), S = UDim2.new(1,-145,0.8,0), A = UDim2.new(1,-210,0.8,0), D = UDim2.new(1,-80,0.8,0), ["↑"] = UDim2.new(1,-80,0.7,0), ["↓"] = UDim2.new(1,-80,0.8,0)}

for txt, key in pairs(btnData) do
	local b = Instance.new("TextButton", gui); b.Size = UDim2.new(0,60,0,60); b.Position = btnPos[txt]; b.Text = txt; b.Visible = false; b.BackgroundColor3 = Color3.fromRGB(40,40,40); b.TextColor3 = Color3.fromRGB(0,255,120); b.Font = "GothamBold"; b.TextSize = 24
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	b.InputBegan:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then moveKeys[key] = true end end)
	b.InputEnded:Connect(function(i) if i.UserInputType.Name:find("Mouse") or i.UserInputType.Name:find("Touch") then moveKeys[key] = false end end)
	controls[key] = b
end

-- System Functions
local function toggleControls(v) for _, b in pairs(controls) do b.Visible = v end end

local function startFly()
	local c = getChar(); local r = c:WaitForChild("HumanoidRootPart"); getHum().PlatformStand = true
	local bg = Instance.new("BodyGyro", r); bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	local bv = Instance.new("BodyVelocity", r); bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	toggleControls(true); controls.lft.Visible, controls.rgt.Visible, controls.fwd.Visible, controls.bwd.Visible = false, false, false, false
	flyConn = RunService.Heartbeat:Connect(function()
		local cam = workspace.CurrentCamera; local dir = Vector3.zero
		local md = getHum().MoveDirection
		if md.Magnitude > 0.1 then dir += Vector3.new(md.X, 0, md.Z) end
		if UIS:IsKeyDown("W") then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown("S") then dir -= cam.CFrame.LookVector end
		if moveKeys.up then dir += Vector3.new(0,1,0) end
		if moveKeys.down then dir -= Vector3.new(0,1,0) end
		bv.Velocity = dir * flySpeed; bg.CFrame = cam.CFrame
	end)
end

local function stopFly() if flyConn then flyConn:Disconnect() end; pcall(function() getChar().HumanoidRootPart.BodyGyro:Destroy(); getChar().HumanoidRootPart.BodyVelocity:Destroy(); getHum().PlatformStand = false end); toggleControls(false) end

local function startNoclip() noclipConn = RunService.Stepped:Connect(function() for _, v in pairs(getChar():GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end) end

local function addESP(p)
	if p == player or not p.Character then return end
	local hl = Instance.new("SelectionBox", gui); hl.Adornee = p.Character; hl.Color3 = Color3.new(1,1,1); hl.SurfaceTransparency = 0.7
	local bb = Instance.new("BillboardGui", gui); bb.Adornee = p.Character:FindFirstChild("HumanoidRootPart"); bb.Size = UDim2.new(0,100,0,30); bb.AlwaysOnTop = true; bb.StudsOffset = Vector3.new(0,3,0)
	local n = createText(bb, p.Name, UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), "Center"); n.TextColor3 = Color3.new(1,1,1)
	espObjects[p] = {hl, bb}
end

local function startFreecam()
	local cam = workspace.CurrentCamera; getChar().HumanoidRootPart.Anchored = true
	freecamPart = Instance.new("Part", workspace); freecamPart.Size = Vector3.new(1,1,1); freecamPart.Transparency = 1; freecamPart.Anchored = true; freecamPart.CFrame = cam.CFrame
	cam.CameraSubject = freecamPart; toggleControls(true)
	freecamConn = RunService.RenderStepped:Connect(function()
		local dir = Vector3.zero; local cf = cam.CFrame
		if moveKeys.fwd or UIS:IsKeyDown("W") then dir += cf.LookVector end
		if moveKeys.bwd or UIS:IsKeyDown("S") then dir -= cf.LookVector end
		if moveKeys.lft or UIS:IsKeyDown("A") then dir -= cf.RightVector end
		if moveKeys.rgt or UIS:IsKeyDown("D") then dir += cf.RightVector end
		if moveKeys.up then dir += Vector3.new(0,1,0) end
		if moveKeys.down then dir -= Vector3.new(0,1,0) end
		if dir.Magnitude > 0 then freecamPart.CFrame += dir.Unit * freecamSpeed end
	end)
end

-- Tab Logic
local page1 = Instance.new("ScrollingFrame", frame); page1.Size = UDim2.new(1,0,1,-80); page1.Position = UDim2.new(0,0,0,78); page1.BackgroundTransparency = 1; page1.CanvasSize = UDim2.new(0,0,0,450)
local page2 = page1:Clone(); page2.Parent = frame; page2.Visible = false; page2.CanvasSize = UDim2.new(0,0,0,600)

local function createRow(p, name, y, getV, setV, toggle, noSlider)
	local r = Instance.new("Frame", p); r.Size = UDim2.new(1,-20,0,50); r.Position = UDim2.new(0,10,0,y); r.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner", r)
	local l = createText(r, name, UDim2.new(0,120,1,0), UDim2.new(0,10,0,0), "Left"); l.TextColor3 = Color3.new(1,1,1)
	local tb = Instance.new("TextButton", r); tb.Size = UDim2.new(0,54,0,28); tb.Position = UDim2.new(1,-64,0.5,-14); tb.Text = "OFF"; tb.BackgroundColor3 = Color3.fromRGB(80,80,80)
	Instance.new("UICorner", tb)
	local on = false; tb.MouseButton1Click:Connect(function() on = not on; tb.Text = on and "ON" or "OFF"; tb.BackgroundColor3 = on and Color3.fromRGB(0,200,80) or Color3.fromRGB(80,80,80); toggle(on) end)
end

-- Pages Content
createRow(page1, "FLY", 5, function() return flySpeed end, function(v) flySpeed = v end, function(s) flyEnabled = s; if s then startFly() else stopFly() end end)
createRow(page1, "SPEED", 65, function() return walkSpeed end, function(v) walkSpeed = v end, function(s) speedEnabled = s; getHum().WalkSpeed = s and walkSpeed or 16 end)
createRow(page1, "JUMP", 125, function() return jumpPower end, function(v) jumpPower = v end, function(s) jumpEnabled = s; getHum().JumpPower = s and jumpPower or 50 end)
createRow(page1, "NOCLIP", 185, nil, nil, function(s) noclipEnabled = s; if s then startNoclip() else if noclipConn then noclipConn:Disconnect() end end end, true)
createRow(page2, "ESP", 5, nil, nil, function(s) espEnabled = s; if s then for _,p in pairs(game.Players:GetPlayers()) do addESP(p) end else for _,v in pairs(espObjects) do v[1]:Destroy(); v[2]:Destroy() end espObjects = {} end end, true)
createRow(page2, "FREECAM", 65, function() return freecamSpeed end, function(v) freecamSpeed = v end, function(s) freecamEnabled = s; if s then startFreecam() else if freecamConn then freecamConn:Disconnect() end; workspace.CurrentCamera.CameraSubject = getHum(); getChar().HumanoidRootPart.Anchored = false; toggleControls(false); freecamPart:Destroy() end end)

-- Tab Switch
local function tabBtn(txt, x, p)
	local b = Instance.new("TextButton", frame); b.Size = UDim2.new(0,100,0,28); b.Position = UDim2.new(0,x,0,42); b.Text = txt; b.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Instance.new("UICorner", b); b.MouseButton1Click:Connect(function() page1.Visible = (p==1); page2.Visible = (p==2) end); return b
end
tabBtn("หน้า 1", 10, 1); tabBtn("หน้า 2", 120, 2)

-- TP System (Simplified)
local tpR = Instance.new("Frame", page2); tpR.Size = UDim2.new(1,-20,0,50); tpR.Position = UDim2.new(0,10,0,125); tpR.BackgroundColor3 = Color3.fromRGB(30,30,30)
local tpl = createText(tpR, "TELEPORT (Click)", UDim2.new(1,0,1,0), UDim2.new(0,0,0,0), "Center")
local tpBtn = Instance.new("TextButton", tpR); tpBtn.Size = UDim2.new(1,0,1,0); tpBtn.BackgroundTransparency = 1; tpBtn.Text = ""
tpBtn.MouseButton1Click:Connect(function() for _,p in pairs(game.Players:GetPlayers()) do if p ~= player and p.Character then getChar():SetPrimaryPartCFrame(p.Character.HumanoidRootPart.CFrame) break end end end)

-- Auto Update
player.CharacterAdded:Connect(function() 
	task.wait(1); if speedEnabled then getHum().WalkSpeed = walkSpeed end
	if flyEnabled then startFly() end; if noclipEnabled then startNoclip() end 
end)
