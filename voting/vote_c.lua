local Visible = false

RegisterNetEvent("StartVoteScreen")
AddEventHandler("StartVoteScreen", function(SelectedGamemodes)
	Citizen.CreateThread(function()
		local Instructional = GUI.InstructionalButtons(176, "Vote")
		local Gamemodes = SelectedGamemodes
		local MenuIndex = 0
		local VotingS = Scaleform.Request("MP_NEXT_JOB_SELECTION")
		Scaleform.CallFunction(VotingS, false, "SET_TITLE", "Next Gamemode", 0)
		for i=1, #Gamemodes do
			Streaming.RequestTextureDict(Gamemodes[i].txd)
			Scaleform.CallFunction(VotingS, false, "SET_GRID_ITEM", i-1, Gamemodes[i].title, Gamemodes[i].txd, Gamemodes[i].txn, Gamemodes[i].textureLoadType or 0, Gamemodes[i].verifiedType or 0, Gamemodes[i].eIcon or -1, Gamemodes[i].bCheck or false, Gamemodes[i].rpMult or 0, Gamemodes[i].cashMult or 0, Gamemodes[i].bDisabled or false, Gamemodes[i].iconCol or 25)
		end
		Visible = true
		while true do
			Citizen.Wait(0)
			if Visible then
				Scaleform.Render2D(VotingS)
				Scaleform.Render2D(Instructional)
				HideHudAndRadarThisFrame()
				Scaleform.CallFunction(VotingS, false, "SET_SELECTION", MenuIndex, Gamemodes[MenuIndex+1].title, Gamemodes[MenuIndex+1].desc, false)
				if IsControlJustPressed(0, 172) then -- Up
					if MenuIndex - 3 >= 0 and MenuIndex - 3 <= 5 then
						MenuIndex = MenuIndex - 3
					end
				elseif IsControlJustPressed(0, 173) then -- Down
					if MenuIndex + 3 >= 0 and MenuIndex + 3 <= 5 then
						MenuIndex = MenuIndex + 3
					end
				elseif IsControlJustPressed(0, 174) then -- Left
					if MenuIndex - 1 >= 0 and MenuIndex - 1 <= 5 then
						MenuIndex = MenuIndex - 1
					end
				elseif IsControlJustPressed(0, 175) then -- Right
					if MenuIndex + 1 >= 0 and MenuIndex + 1 <= 5 then
						MenuIndex = MenuIndex + 1
					end
				elseif IsControlJustPressed(0, 176) then -- Enter
				end
			end
		end
	end)
end)
