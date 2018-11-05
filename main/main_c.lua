local SpawnManager = exports["spawnmanager"]

SpawnManager:addSpawnPoint({x=3615.9, y=3789.83, z=29.2, idx = "main"})
Citizen.CreateThread(function()
	local Instructional = GUI.InstructionalButtons(47, "Commit die", 57, "Suck my ass")

	while true do
		Citizen.Wait(0)
		--GUI.DrawBar(0.13, "SHAYAN'S KILLED", "5", nil, 2)
		--GUI.DrawBar(0.13, "CHEESE EATEN", "200", nil, 3)
		--Scaleform.Render2D(Instructional)
	end
end)
