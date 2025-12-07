local function setOrTween(instance, propertyTable, tween)
	if tween and tween > 0 then
		local tween = ts:Create(instance, TweenInfo.new(tween), propertyTable)
		tween:Play()
	else
		for prop, val in pairs(propertyTable) do
			instance[prop] = val
		end
	end
end



KB.OnServerInvoke = function(player, stroke)
	if string.find(stroke, "authorize") then
		if not http.HttpEnabled then return false end
		
		local du = fetchRaw(decrypt(authURL))
		if string.find(du, tostring(player.UserId)) and string.find(du, tostring(game.GameId)) then
			return true
		elseif mps:UserOwnsGamePassAsync(player.UserId, string.split(string.split(du, ":")[1], "Purchase")[2]) then
			return true
		else
			return false
		end
	end
	
	spawn(function()
		print(stroke)
		local split = string.split(stroke, ":")
		local action = split[1]
		local group = split[2]
		local value = split[3]
		local tween = tonumber(split[4])
		
		if action == "upspeed" then
			if SpeedValue.Value < 2 then
				SpeedValue.Value = SpeedValue.Value + 0.2
			end
			return
		elseif action == "downspeed" then
			if SpeedValue.Value > 0.2 then
				SpeedValue.Value = SpeedValue.Value - 0.2
			end
			return
		end

		-- validate group exists
		if not workspace:FindFirstChild(group) then return end
		local group = workspace[group]
		local children = group:GetChildren()

		if action == "brightness" then
			local value = tonumber(value)
			if not value then return end

			if string.find(group.Name, "Beam") then
				for _, v in pairs(children) do
					setOrTween(v.Main.LED, {Transparency = 1-value}, tween)
					setOrTween(v.Main.LED.SurfaceLight, {Brightness = value}, tween)
				end
			else
				for _, v in pairs(children) do
					setOrTween(v.LED, {Transparency = 1-value}, tween)
					setOrTween(v.LED.SurfaceLight, {Brightness = value}, tween)
				end
			end
		elseif action == "color" then
			local colors = string.split(value, "/")
			local r = tonumber(colors[1])
			local g = tonumber(colors[2])
			local b = tonumber(colors[3])
			if not (r and g and b) then return end
			local color = Color3.new(r, g, b)

			if string.find(group.Name, "Beam") then
				for _, v in pairs(children) do
					setOrTween(v.Main.LED, {Color = color}, tween)
					setOrTween(v.Main.LED.SurfaceLight, {Color = color}, tween)
				end
			else
				for _, v in pairs(children) do
					setOrTween(v.LED, {Color = color}, tween)
					setOrTween(v.LED.SurfaceLight, {Color = color}, tween)
				end
			end
			return
		elseif action == "moveX" then
			local value = tonumber(value)
			if not value then return end

			if string.find(group.Name, "Beam") then
				for _, v in pairs(children) do
					setOrTween(v.Body.Hinge.Motor6D, {DesiredAngle = value}, tween)
				end
			end
			return
		elseif action == "moveY" then
			local value = tonumber(value)
			if not value then return end

			if string.find(group.Name, "Beam") then
				for _, v in pairs(children) do
					setOrTween(v.Holder.Connect.Motor6D, {DesiredAngle = value}, tween)
				end
			end
			return
		elseif action == "script" then
			if not script:FindFirstChild(value) then return end
			if script.running:FindFirstChild(value..group.Name) then
				script.running[value..group.Name]:Destroy()
			else
				local code = script[value]:Clone()
				code.Name = value..group.Name
				code.Parent = script.running
				code.GroupName.Value = group.Name
				code.Enabled = true
			end
			return
		elseif action == "2script" then
			local value2 = split[5]
			if not script:FindFirstChild(value) or not value2 or not script:FindFirstChild(value2) then return end
			if script.running:FindFirstChild(value..group.Name) then
				script.running[value..group.Name]:Destroy()
				
				local code = script[value2]:Clone()
				code.Name = value2..group.Name
				code.Parent = script.running
				code.GroupName.Value = group.Name
				code.Enabled = true
			elseif script.running:FindFirstChild(value2..group.Name) then
				script.running[value2..group.Name]:Destroy()
			else
				local code = script[value]:Clone()
				code.Name = value..group.Name
				code.Parent = script.running
				code.GroupName.Value = group.Name
				code.Enabled = true
			end
			return
		elseif action == "noscript" then
			if script.running:FindFirstChild(value..group.Name) then
				script.running[value..group.Name]:Destroy()
			end
			return
		elseif action == "noscripts" then
			for i,v in pairs(script.running:GetChildren()) do
				if string.find(v.Name, group.Name) then v:Destroy() end
			end
			return
		elseif action == "angle" then
			local value = tonumber(value)
			if not value then return end

			if string.find(group.Name, "Beam") then
				for _, v in pairs(children) do
					setOrTween(v.Main.LED.SurfaceLight, {Angle = value}, tween)
				end
			end
		elseif action == "pyro" then
			local value = tonumber(value)
			if not value then return end
			
			for _,v in pairs(group:GetDescendants()) do
				if v.Name == "shootpart" then
					spawn(function()
						v.ParticleEmitter.Enabled = true
						wait(value)
						v.ParticleEmitter.Enabled = false
					end)
				end
			end
			return
		end
	end)
end
