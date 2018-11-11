local firstspawn = true
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
			TriggerEvent("Gamemode:Join:"..v.id)
		end
		firstspawn = false
	end
end)