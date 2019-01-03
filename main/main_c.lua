local firstspawn = true
Money = 0
XP = 0
local Notifications = {
	{"Hey! looks like you got some money to spend... Come check out our guns!", "CHAR_AMMUNATION"},
	{"Ever wanted to get your ride pimped up a bit? Come check us out at Los Santos Customs!", "CHAR_LS_CUSTOMS"}
}

RegisterNetEvent("Nexus:UpdateMoney")

Citizen.CreateThread(function()
	Wait(100)
	SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
	SpawnManager.spawnPlayer(1,function()print("spawned")end)
	SpawnManager.setAutoSpawn(true)
end)
AddEventHandler("playerSpawned", function()
	if firstspawn then
		JayMenu.CreateMenu('ammunation', "Ammunation")
		for k,v in pairs(Gamemodes) do
			TriggerServerEvent("Gamemode:Join:"..v.id)
		end
		TriggerServerEvent("Freeroam:Join")
		TriggerServerEvent("Voting:Join")
		Citizen.CreateThread(function()
			local lastmoney = 0
			local lastxp = 0
			TriggerServerEvent("PollMoney")
			while true do
				Wait(0)
				if IsControlJustPressed(0, 48) then
					ShowHudComponentThisFrame(4) 
					DisplayCash(false) --we don't need bank stuff
					Scaleform.InitializeXP(XP, math.floor(XP/1000)*1000, math.floor((XP+1000)/1000)*1000, 0)
					Misc.DoCountdown(5190)
				end
				if Money ~= lastmoney then
					StatSetInt("MP0_WALLET_BALANCE", Money, -1)
					print(Money)
				end
				if XP ~= lastxp then
					Scaleform.InitializeXP(lastxp, math.floor(lastxp/1000)*1000, math.floor((lastxp+1000)/1000)*1000, XP-lastxp)
					print(XP)
				end
				lastxp = XP
				lastmoney = Money
			end
		end)

		SetMaxWantedLevel(0)

		firstspawn = false
	else
		TriggerEvent("Gamemode:Spawn:7")
		TriggerEvent("Gamemode:Spawn:8")
	end
end)

AddEventHandler("Nexus:UpdateMoney", function(money, xp) Money=money XP=xp end)

AddEventHandler('gameEventTriggered', function (name, args)
	print('game event ' .. name .. ' (' .. json.encode(args) .. ')')
	if name == "CEventNetworkVehicleUndrivable" then
		if HasEntityBeenDamagedByEntity(args[1], GetVehiclePedIsIn(PlayerPedId(),false), 1) or HasEntityBeenDamagedByEntity(args[1], PlayerPedId(), 1) then
			TriggerServerEvent("Gamemode:VehicleDestroyed:7")
		end
	end
end)