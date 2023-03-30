local HOME = script.Parent
local VALUES = script.Parent.Values
local DISPLAYS = script.Parent.Displays
local SOUNDS = script.Parent.SoundPart
local BALL_ACTION = script.Parent.SwingAction.Ball
local BAT_ACTION = script.Parent.SwingAction.Bat
local HIT_ZONES = script.Parent.HitZones
local BASES = script.Parent.Bases
local SWING_BUTTON = script.Parent.SwingButton
local CARD_SWIPE = script.Parent.CardSwipe
local AMOUNT
local GOAL
local HIT_AT
local PLAYER_NAME
local RUNNERS_TABLE
local LOCATION
local RANDOM_SELECTION
local FINAL_WAIT_SPEED
local OUTCOME 
local LOOPING
local ADD_TO_OUT_TABLE
local SET_OUT
local WAIT_SPEED
local SUB_AMOUNT
local SUB_GOAL
local EXISTS

VALUES.GameOn.Changed:Connect(function()
	if VALUES.GameOn.Value == true then
		-----
		-----
		-----
		-----
		-----
		
		wait(1)
		RANDOM_SELECTION = math.random(1,VALUES.RunsNeededIncrementDownChance.Value)
		if RANDOM_SELECTION == 3 then
			VALUES.RunsNeeded.Value = VALUES.RunsNeeded.Value - VALUES.RunsNeededIncrementDown.Value
		end
		DISPLAYS.RunsNeedDisplay.SurfaceGui.TextLabel.Text = VALUES.RunsNeeded.Value
		VALUES.HitsMade.Value = 0
		VALUES.Runs.Value = 0
		PLAYER_NAME = CARD_SWIPE.Player.Value
		RUNNERS_TABLE = {}
		WAIT_SPEED = VALUES.WaitSpeedReset.Value
		
		SOUNDS.Start:Play()
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Welcome to Home Run!"
		wait(3)
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Press swing to hit the ball!"
		wait(3)
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Advance runners to score points!"
		wait(3)
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Three outs, and the game is over!"
		wait(3)
		SOUNDS.Background:Play()
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Up to bat, it's "..PLAYER_NAME.."!"
		wait(3)
		
		VALUES.Outs.Value = 0
		while VALUES.Outs.Value < 3 do
			----
			----
			----
			----
			
			local CHANCES_TABLE = { 
			"1","1","1","1","1","1","1",
			"2","2","2","2","2","2",
			"3","3","3","3","3",
			"Home","Home"}
			AMOUNT = 1
			GOAL = 7
			while AMOUNT <= GOAL do
				HIT_ZONES["Zone"..AMOUNT].Screen.RunsDisplay.SurfaceGui.TextLabel.Text = CHANCES_TABLE[math.random(1,#CHANCES_TABLE)]
				if HIT_ZONES["Zone"..AMOUNT].Screen.RunsDisplay.SurfaceGui.TextLabel.Text == "Home" then
					HIT_ZONES["Zone"..AMOUNT].Screen.RunsDisplay.SurfaceGui.TextLabel.TextColor3 = Color3.new(255, 170, 0)
					HIT_ZONES["Zone"..AMOUNT].Screen.NeonLight.BrickColor = BrickColor.new("Neon orange")
				else
					HIT_ZONES["Zone"..AMOUNT].Screen.RunsDisplay.SurfaceGui.TextLabel.TextColor3 = Color3.new(0, 255, 0)
					HIT_ZONES["Zone"..AMOUNT].Screen.NeonLight.BrickColor = BrickColor.new("Lime green")
				end
				AMOUNT = AMOUNT + 1
			end
			AMOUNT = 0
			GOAL = math.floor(VALUES.HitsMade.Value/4)
			if GOAL > 6 then
				GOAL = 6
			end
			ADD_TO_OUT_TABLE = {1,2,3,4,5,6,7}
			while AMOUNT < GOAL do
				RANDOM_SELECTION = math.random(1,#ADD_TO_OUT_TABLE)
				SET_OUT = ADD_TO_OUT_TABLE[RANDOM_SELECTION]
				table.remove(ADD_TO_OUT_TABLE,RANDOM_SELECTION)
				HIT_ZONES["Zone"..SET_OUT].Screen.RunsDisplay.SurfaceGui.TextLabel.Text = "Out"
				HIT_ZONES["Zone"..SET_OUT].Screen.RunsDisplay.SurfaceGui.TextLabel.TextColor3 = Color3.new(255, 0, 0)
				HIT_ZONES["Zone"..SET_OUT].Screen.NeonLight.BrickColor = BrickColor.new("Really red")
				AMOUNT = AMOUNT + 1
			end
			SOUNDS.Countdown.TimePosition = 10.5
			SOUNDS.Countdown:Play()
			wait(1)
			SOUNDS.Countdown:Stop()
			DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "3"
			wait(0.5)
			DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "2"
			wait(0.5)
			DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "1"
			wait(0.5)
			DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = ""
			VALUES.Pressed.Value = false
			WAIT_SPEED = WAIT_SPEED*VALUES.SpeedMultiple.Value
			FINAL_WAIT_SPEED = WAIT_SPEED*(math.random(1000,1500)*0.001)
			AMOUNT = 1
			GOAL = 20
			while AMOUNT <= GOAL do
				---
				---
				---
				
				BALL_ACTION["Part"..AMOUNT].Transparency = 0
				if AMOUNT == 20 then
					HIT_AT = 20
					VALUES.Pressed.Value = true
					wait()
				end
				if VALUES.Pressed.Value == true then
					HIT_AT = AMOUNT
					AMOUNT = 21
				end
				wait(FINAL_WAIT_SPEED)
				if AMOUNT <= 20 then
					BALL_ACTION["Part"..AMOUNT].Transparency = 1
				end
				AMOUNT = AMOUNT + 1
				
				---
				---
				---
			end
			
			VALUES.HitsMade.Value = VALUES.HitsMade.Value + 1
			BALL_ACTION["Part"..HIT_AT].Transparency = 0
			LOCATION = BALL_ACTION["Part"..HIT_AT].Location.Value
			
			if LOCATION == -1 then --Player missed swing and earns a strike
				---
				---
				---
				
				SOUNDS.Strike:Play()
				DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Strike!"
				wait(2)
				DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = ""
				VALUES.Strikes.Value = VALUES.Strikes.Value + 1
				DISPLAYS.StrikesDisplay.SurfaceGui.TextLabel.Text = VALUES.Strikes.Value
				wait(1)
				if VALUES.Strikes.Value == 3 then --Player has three strikes and is out
					VALUES.Strikes.Value = 0
					DISPLAYS.StrikesDisplay.SurfaceGui.TextLabel.Text = VALUES.Strikes.Value
					DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Out!"
					SOUNDS.Out:Play()
					VALUES.Outs.Value = VALUES.Outs.Value + 1
					DISPLAYS.OutsDisplay.SurfaceGui.TextLabel.Text = VALUES.Outs.Value
					wait(2)
					DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = ""
				end
				BALL_ACTION["Part"..HIT_AT].Transparency = 1
				
				---
				---
				---
			else --Player had successful swing and game will see where they landed
				---
				---
				---
				
				VALUES.Strikes.Value = 0
				DISPLAYS.StrikesDisplay.SurfaceGui.TextLabel.Text = VALUES.Strikes.Value
				BAT_ACTION["Part"..LOCATION].Transparency = 0
				BAT_ACTION.PartHome.Transparency = 1
				BALL_ACTION["Part"..HIT_AT].Transparency = 1
				SOUNDS.Hit:Play()
				wait(1)
				BAT_ACTION["Part"..LOCATION].Transparency = 1
				BAT_ACTION.PartHome.Transparency = 0
				BALL_ACTION["Part"..LOCATION].Transparency = 1
				HIT_ZONES["Zone"..LOCATION].Sensor.MoveToPart.Transparency = 0
				OUTCOME = HIT_ZONES["Zone"..LOCATION].Screen.RunsDisplay.SurfaceGui.TextLabel.Text
				if OUTCOME == "Out" then --Player landed in out
					VALUES.Outs.Value = VALUES.Outs.Value + 1
					DISPLAYS.OutsDisplay.SurfaceGui.TextLabel.Text = VALUES.Outs.Value
					OUTCOME = 0
					DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Out!"
					SOUNDS.Out:Play()
					wait(2)
					DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = ""
				elseif OUTCOME == "Home" then --Player hit home run
					OUTCOME = 4
					SUB_AMOUNT = 1
					SUB_GOAL = 70
					SOUNDS.HomeRun:Play()
					while SUB_AMOUNT <= SUB_GOAL do
						HIT_ZONES.Zone1.Screen.NeonLight.BrickColor = BrickColor.Random()
						HIT_ZONES.Zone2.Screen.NeonLight.BrickColor = BrickColor.Random()
						HIT_ZONES.Zone3.Screen.NeonLight.BrickColor = BrickColor.Random()
						HIT_ZONES.Zone4.Screen.NeonLight.BrickColor = BrickColor.Random()
						HIT_ZONES.Zone5.Screen.NeonLight.BrickColor = BrickColor.Random()
						HIT_ZONES.Zone6.Screen.NeonLight.BrickColor = BrickColor.Random()
						HIT_ZONES.Zone7.Screen.NeonLight.BrickColor = BrickColor.Random()
						SUB_AMOUNT = SUB_AMOUNT + 1
						wait(0.1)
					end
				elseif OUTCOME == "1" or OUTCOME == "2" or OUTCOME == "3" then --Player hit a single, double, or triple
					OUTCOME = tonumber(HIT_ZONES["Zone"..LOCATION].Screen.RunsDisplay.SurfaceGui.TextLabel.Text)
					if OUTCOME == 1 then
						DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Single!"
						SOUNDS.Single:Play()
					end
					if OUTCOME == 2 then
						DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Double!"
						SOUNDS.Double:Play()
					end
					if OUTCOME == 3 then
						DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Triple!"
						SOUNDS.Triple:Play()
					end
					wait(2)
				end
				HIT_ZONES["Zone"..LOCATION].Sensor.MoveToPart.Transparency = 1
				BASES.Base1.Material = Enum.Material.SmoothPlastic
				BASES.Base2.Material = Enum.Material.SmoothPlastic
				BASES.Base3.Material = Enum.Material.SmoothPlastic
				BASES.Base4.Material = Enum.Material.SmoothPlastic
				if OUTCOME >= 1 and OUTCOME <= 4 then
					table.insert(RUNNERS_TABLE,0)
				end
				AMOUNT = 1
				GOAL = #RUNNERS_TABLE
				while AMOUNT <= GOAL do
					if RUNNERS_TABLE[AMOUNT] ~= "X" then
						RUNNERS_TABLE[AMOUNT] = RUNNERS_TABLE[AMOUNT] + OUTCOME
						if RUNNERS_TABLE[AMOUNT] >= 4 then
							RUNNERS_TABLE[AMOUNT] = 4
						end
						BASES["Base"..RUNNERS_TABLE[AMOUNT]].Material = Enum.Material.Neon
						if RUNNERS_TABLE[AMOUNT] == 4 then
							SOUNDS.Score:Play()
							DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Run Scored!"
							VALUES.Runs.Value = VALUES.Runs.Value + 1
							DISPLAYS.RunsInDisplay.SurfaceGui.TextLabel.Text = VALUES.Runs.Value
							SUB_AMOUNT = 1
							SUB_GOAL = 10
							while SUB_AMOUNT <= SUB_GOAL do
								wait(0.1)
								BASES["Base"..RUNNERS_TABLE[AMOUNT]].BrickColor = BrickColor.new("Lime green")
								wait(0.1)
								BASES["Base"..RUNNERS_TABLE[AMOUNT]].BrickColor = BrickColor.new("Institutional white")
								SUB_AMOUNT = SUB_AMOUNT + 1
							end
							DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = ""
							BASES["Base"..RUNNERS_TABLE[AMOUNT]].Material = Enum.Material.SmoothPlastic
							wait(1)
						end
					end
					AMOUNT = AMOUNT + 1
				end
				AMOUNT = 1
				GOAL = #RUNNERS_TABLE
				while AMOUNT <= GOAL do
					if RUNNERS_TABLE[AMOUNT] ~= "X" then
						if RUNNERS_TABLE[AMOUNT] >= 4 then
							RUNNERS_TABLE[AMOUNT] = "X"
						end
					end
					AMOUNT = AMOUNT + 1
				end
				wait(2)
				
				---
				---
				---
			end
			
			----
			----
			----
			----
		end
	
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "3 Outs!"
		SOUNDS.Background:Stop()
		SOUNDS.Results:Play()
		wait(math.random(4,6))
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "That's the game!"
		wait(math.random(4,6))
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Runs Scored: "..VALUES.Runs.Value
		wait(math.random(4,6))
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Hits: "..VALUES.HitsMade.Value
		wait(math.random(4,6))
		SOUNDS.Results:Stop()
		if VALUES.Runs.Value >= VALUES.RunsNeeded.Value then
			SOUNDS.Jackpot:Play()
			DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "YOU BEAT THE HIGH SCORE!"
			VALUES.RunsNeeded.Value = VALUES.Runs.Value + VALUES.RunsNeededIncrementUp.Value
			SUB_AMOUNT = 1
			SUB_GOAL = 60
			while SUB_AMOUNT <= SUB_GOAL do
				HIT_ZONES.Zone1.Screen.NeonLight.BrickColor = BrickColor.Random()
				HIT_ZONES.Zone2.Screen.NeonLight.BrickColor = BrickColor.Random()
				HIT_ZONES.Zone3.Screen.NeonLight.BrickColor = BrickColor.Random()
				HIT_ZONES.Zone4.Screen.NeonLight.BrickColor = BrickColor.Random()
				HIT_ZONES.Zone5.Screen.NeonLight.BrickColor = BrickColor.Random()
				HIT_ZONES.Zone6.Screen.NeonLight.BrickColor = BrickColor.Random()
				HIT_ZONES.Zone7.Screen.NeonLight.BrickColor = BrickColor.Random()
				SUB_AMOUNT = SUB_AMOUNT + 1
				wait(1)
			end
		else
			--Do nothing, entertainment edition
		end
		HIT_ZONES.Zone1.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone2.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone3.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone4.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone5.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone6.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone7.Screen.NeonLight.BrickColor = BrickColor.new("Institutional white")
		HIT_ZONES.Zone1.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		HIT_ZONES.Zone2.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		HIT_ZONES.Zone3.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		HIT_ZONES.Zone4.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		HIT_ZONES.Zone5.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		HIT_ZONES.Zone6.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		HIT_ZONES.Zone7.Screen.RunsDisplay.SurfaceGui.TextLabel.Text = ""
		BASES.Base1.Material = Enum.Material.SmoothPlastic
		BASES.Base2.Material = Enum.Material.SmoothPlastic
		BASES.Base3.Material = Enum.Material.SmoothPlastic
		BASES.Base4.Material = Enum.Material.SmoothPlastic
		wait(1)
		DISPLAYS.RunsNeedDisplay.SurfaceGui.TextLabel.Text = VALUES.RunsNeeded.Value
		DISPLAYS.StrikesDisplay.SurfaceGui.TextLabel.Text = "-"
		DISPLAYS.RunsInDisplay.SurfaceGui.TextLabel.Text = "-"
		DISPLAYS.OutsDisplay.SurfaceGui.TextLabel.Text = "-"
		DISPLAYS.NarratorDisplay.SurfaceGui.TextLabel.Text = "Play Home Run!"
		VALUES.GameOn.Value = false
		CARD_SWIPE.Screen.SurfaceGui.TextLabel.Text = "Click To Start"
		CARD_SWIPE.Screen.ClickDetector.MaxActivationDistance = 16
		
		-----
		-----
		-----
		-----
		-----
	end
end)