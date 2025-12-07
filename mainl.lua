local stage = script.Parent.Stage
local Buttons = script.Parent.Buttons
local PowerStatus = script.Parent.PowerStatus
local RestoreStatus = script.Parent.RestoreStatus
local SignalStatus = script.Parent.SignalStatus
local PinButtons = script.Parent.PinButtons
local Screen1 = script.Parent.ScreenPanel1.Model.Screen
local Screen2 = script.Parent.ScreenPanel2.Model.Screen
local Screen3 = script.Parent.ScreenPanel3.Model.Screen
local Screen4 = script.Parent.ScreenPanel4
local Screen5 = script.Parent.ScreenPanel5.SurfaceGui.ScrollingFrame
local Gui1 = Screen1.newGui
local Gui2 = Screen2.newGui
local Gui3 = Screen3.newGui
local ts = game.TweenService


local count = 0

function checkUSB()
	for i,v in pairs(Gui1.Saved.Project1:GetChildren()) do
		if v:FindFirstChild("USB") then
			v:Destroy()
		end
	end
	for i,v in pairs(Gui2.Saved.Project1:GetChildren()) do
		if v:FindFirstChild("USB") then
			v:Destroy()
		end
	end
	
	for i,v in pairs(script.Parent:GetChildren()) do
		if string.find(v.Name, "USB") then
			print("USB", v.Name, "detected!")
			if v:FindFirstChild("Script") then
				v.Script.Enabled = true
				local new = Screen5.new:Clone()
				new.Parent = Screen5
				new.Text = "USB-stick:<"..v.Name.."> detected and code ran!"
				new.Visible = true
			elseif v:FindFirstChild("data") then
				local new = Screen5.new:Clone()
				new.Parent = Screen5
				new.Text = "USB-stick:<"..v.Name.."> detected, implementing code!"
				new.Visible = true
				for i,r in pairs(v.data:GetChildren()) do
					if Gui1.Saved.Project1:FindFirstChild(r.Name) == nil then
						local newProject = Gui1.Saved.Project1.new:Clone()
						newProject.Parent = Gui1.Saved.Project1
						newProject.Name = r.Name
						newProject.Text = r.Name
						local newSave = r:Clone()
						newSave.Parent = newProject.Script
						newProject.UIStroke.Color = v.Colored.Color
						newProject.Frame.BackgroundColor3 = v.Colored.Color
						newProject.Visible = true
						local new = Instance.new("Configuration")
						new.Parent = newProject
						new.Name = "USB"
					end
					if Gui2.Saved.Project1:FindFirstChild(r.Name) == nil then
						local newProject = Gui2.Saved.Project1.new:Clone()
						newProject.Parent = Gui2.Saved.Project1
						newProject.Name = r.Name
						newProject.Text = r.Name
						local newSave = r:Clone()
						newSave.Parent = newProject.Script
						newProject.UIStroke.Color = v.Colored.Color
						newProject.Frame.BackgroundColor3 = v.Colored.Color
						newProject.Visible = true
						local new = Instance.new("Configuration")
						new.Parent = newProject
						new.Name = "USB"
					end
				end
			else
				local new = Screen5.new:Clone()
				new.Parent = Screen5
				new.TextColor3 = Color3.new(100, 0, 0)
				new.Text = "USB-stick:<"..v.Name.."> detected with failure: Defected code!"
				new.Visible = true
			end
		end
	end
end

function start()
	Gui1.Enabled = true
	Gui2.Enabled = true
	Gui3.Enabled = true
	local CustomSize = 0
	repeat
		CustomSize += math.floor(math.random(5, 20))
		Gui2.Present.Bar.Progress.Size = UDim2.new(CustomSize / 100, 0, 1, 0)
		wait(math.random(0.2, 1))
	until CustomSize >= 100
	for i,v in pairs(PinButtons:GetChildren()) do
		if v:IsA("Part") then
			spawn(function()
				v.Material = Enum.Material.Neon
			end)
		end
	end
	script.Parent.power.Value = true
	spawn(function()
		checkUSB()
	end)
	Gui1.Present.Visible = false
	Gui2.Present.Visible = false
	Gui3.Present.Visible = false
	Gui1.Saved.Visible = true
	Gui2.Saved.Visible = true
	Gui3.Control.Visible = true
	Screen4.SurfaceGui.Enabled = true
	Screen5.Parent.Enabled = true
	local new = Screen5.new:Clone()
	new.Parent = Screen5
	new.Text = "VFL25 OCT loaded!"
	new.Visible = true
end

function stop()
	for i,v in pairs(PinButtons:GetChildren()) do
		if v:IsA("Part") then
			spawn(function()
				v.Material = Enum.Material.SmoothPlastic
			end)
			wait(0.5)
			Gui1.Enabled = false
			Gui2.Enabled = false
			Gui3.Enabled = false
			Gui1.Present.Visible = true
			Gui2.Present.Visible = true
			Gui3.Present.Visible = true
			Screen4.SurfaceGui.Enabled = false 
		end
	end
	script.Parent.power.Value = false
end


Buttons.Power.ClickDetector.MouseClick:Connect(function()
	PowerStatus.led.Material = Enum.Material.Neon
	count = 4
	repeat
		RestoreStatus.led.Material = Enum.Material.Neon
		wait(0.6)
		RestoreStatus.led.Material = Enum.Material.Glass
		wait(0.6)
		count -= 1
	until count <= 0
	wait(math.random(1, 3))
	SignalStatus.led.Material = Enum.Material.Neon
	start()
end)

Buttons.Restart.ClickDetector.MouseClick:Connect(function()
	stop()
	wait(2)
	PowerStatus.led.Material = Enum.Material.Neon
	count = 4
	repeat
		RestoreStatus.led.Material = Enum.Material.Neon
		wait(0.6)
		RestoreStatus.led.Material = Enum.Material.Glass
		wait(0.6)
		count -= 1
	until count <= 0
	wait(math.random(1, 3))
	SignalStatus.led.Material = Enum.Material.Neon
	start()
end)

Buttons.Saved.ClickDetector.MouseClick:Connect(function()
	if Gui1 ~= nil then
		for i,v in pairs(Gui1:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		for i,v in pairs(Gui2:GetChildren()) do
			if v:IsA("Frame") then
				v.Visible = false
			end
		end
		Gui1.Saved.Visible = true
		Gui2.Saved.Visible = true
		Gui2.Pyro.Visible = false
	end
end)

Buttons.Control.ClickDetector.MouseClick:Connect(function()
	Gui1.Saved.Visible = false
	Gui1.ControlV2.Visible = true
end)

Buttons.Pyro.ClickDetector.MouseClick:Connect(function()
	Gui2.Pyro.Visible = not Gui2.Pyro.Visible
	Gui2.Saved.Visible = not Gui2.Pyro.Visible
end)

Buttons.Strobe.SurfaceGui.TextButton.MouseButton1Down:Connect(function()
	if workspace:FindFirstChild("Stage"..stage.Value.."Strobe") then
		spawn(function()
			repeat
				for i,v in pairs(workspace["Stage"..stage.Value.."Strobe"]:GetChildren()) do
					v.Transparency = 0
					v.SurfaceLight.Enabled = true
				end
				wait(0.03)
				for i,v in pairs(workspace["Stage"..stage.Value.."Strobe"]:GetChildren()) do
					v.Transparency = 1
					v.SurfaceLight.Enabled = false
				end
				wait(0.03)
			until Buttons.Strobe.SurfaceGui.TextButton.MouseButton1Up:Wait()
		end)
	end
end)


Buttons.Visuals.ClickDetector.MouseClick:Connect(function()
	Gui3.Visuals.Visible = true
	Gui3.Control.Visible = false
end)

Buttons.NoVisuals.ClickDetector.MouseClick:Connect(function()
	Gui3.Visuals.Visible = false
	Gui3.Control.Visible = true
end)
