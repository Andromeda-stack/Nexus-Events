AddEventHandler("playerDropped", function() 
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Leave:"..v.id,source)
	end
end)
CreateThread(function()
	Wait(1000)
	local db = exports[GetCurrentResourceName()]
	db:OpenConnection(function()
		db:ExecuteNonQuery("CREATE TABLE highscores (name VARCHAR(20), score INT)", function(rows)
			print("done!")
		end)
	end)
end)
