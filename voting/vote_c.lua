VotingVisible = false
local VotingS

local TotalVoted = {
	[0] = {votes = 0, id = 0},
	[1] = {votes = 0, id = 0},
	[2] = {votes = 0, id = 0},
	[3] = {votes = 0, id = 0},
	[4] = {votes = 0, id = 0},
	[5] = {votes = 0, id = 0},
}


RegisterNetEvent("UpdateDisplayVotes")
AddEventHandler("UpdateDisplayVotes", function(VotesTable)
	--SET_GRID_ITEM_VOTE(i, iNumVotes, voteBGColour, bShowCheckMark, bFlashBG)
	for i=0, 5 do
		if TotalVoted[i].votes ~= VotesTable[i].votes then
			Scaleform.CallFunction(VotingS, false, "SET_GRID_ITEM_VOTE", i, VotesTable[i].votes, 25, false, true)
		end
	end
	TotalVoted = VotesTable
end)

RegisterNetEvent("StartVoteScreen")
AddEventHandler("StartVoteScreen", function(SelectedGamemodes)
	Citizen.CreateThread(function()
		SwitchOutPlayer(PlayerPedId(),0,1)
		Wait(500)
		while Citizen.InvokeNative(0x470555300D10B2A5) ~= 5 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 3 do
			Citizen.Wait(0)
		end
		local Instructional = GUI.InstructionalButtons(176, "Vote")
		local Gamemodes = SelectedGamemodes
		local MenuIndex = 0
		VotingS = Scaleform.Request("MP_NEXT_JOB_SELECTION")
		local Voted = false
		Scaleform.CallFunction(VotingS, false, "SET_TITLE", "Next Gamemode", 0)
		for i=1, #Gamemodes do
			Streaming.RequestTextureDict(Gamemodes[i].txd)
			Scaleform.CallFunction(VotingS, false, "SET_GRID_ITEM", i-1, Gamemodes[i].title, Gamemodes[i].txd, Gamemodes[i].txn, Gamemodes[i].textureLoadType or 0, Gamemodes[i].verifiedType or 0, Gamemodes[i].eIcon or -1, Gamemodes[i].bCheck or false, Gamemodes[i].rpMult or 0, Gamemodes[i].cashMult or 0, Gamemodes[i].bDisabled or false, Gamemodes[i].iconCol or 25)
		end
		VotingVisible = true
		while true do
			Citizen.Wait(0)
			if VotingVisible then
				Scaleform.Render2D(VotingS)
				Scaleform.Render2D(Instructional)
				--HideHudAndRadarThisFrame()
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
				elseif IsControlJustPressed(0, 176) and not Voted then -- Enter
					TriggerServerEvent("AddVote", MenuIndex)
					Voted = true
				end
			end

			if not VotingVisible then
				break
			end
		end
	end)
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if Citizen.InvokeNative(0x470555300D10B2A5) == 3 or Citizen.InvokeNative(0x470555300D10B2A5) == 5 or Citizen.InvokeNative(0x470555300D10B2A5) == 8 or Citizen.InvokeNative(0x470555300D10B2A5) == 10 then
			HideHudAndRadarThisFrame()
		end
	end
end)


RegisterCommand("stopit", function(source)
    N_0xd8295af639fd9cb8(PlayerPedId())
end)