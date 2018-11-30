local firstspawn = true
Money = 0

RegisterNetEvent("Nexus:UpdateMoney")

Citizen.CreateThread(function()
	Wait(100)
	SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
	SpawnManager.spawnPlayer(1,function()print("spawned")end)
	SpawnManager.setAutoSpawn(true)
	local Instructional = GUI.InstructionalButtons(47, "Commit die", 57, "Suck my ass")

	while true do
		Citizen.Wait(0)
		--GUI.DrawBar(0.13, "SHAYAN'S KILLED", "5", nil, 2)
		--GUI.DrawBar(0.13, "CHEESE EATEN", "200", nil, 3)
		--Scaleform.Render2D(Instructional)
	end
end)
AddEventHandler("playerSpawned", function()
	if firstspawn then
		for k,v in pairs(Gamemodes) do
			--needs a fix
			TriggerEvent("Gamemode:Join:"..v.id)
		end
		TriggerServerEvent("Freeroam:Join")
		TriggerServerEvent("Voting:Join")
		Citizen.CreateThread(function()
			local lastmoney
			TriggerServerEvent("PollMoney")
			while true do
				Wait(0)
				if IsControlJustPressed(0, 48) then
					ShowHudComponentThisFrame(4) 
					DisplayCash(false) --we don't need bank stuff
					Misc.DoCountdown(5190)
				end
				if Money ~= lastmoney then
					StatSetInt("MP0_WALLET_BALANCE", Money, -1)
					print(Money)
				end
				lastmoney = Money
			end
		end)
		firstspawn = false
	end
end)

AddEventHandler("Nexus:UpdateMoney", function(money) Money=money end)

AddEventHandler('gameEventTriggered', function (name, args)
	print('game event ' .. name .. ' (' .. json.encode(args) .. ')')
	if name == "CEventNetworkVehicleUndrivable" then
		print(GetDisplayNameFromVehicleModel(GetEntityModel(args[1])))
		print(NetToObj(args[2]))
		print(GetDisplayNameFromVehicleModel(args[3]))
		print(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))))
		print(GetVehiclePedIsIn(PlayerPedId(), false))
		print(NetworkGetDestroyerOfNetworkId(VehToNet(args[1])))

	end
end)