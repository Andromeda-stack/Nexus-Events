AddEventHandler("playerDropped", function() 
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Leave:"..v.id,source)
	end
end)
CreateThread(function()
	local db = exports[GetCurrentResourceName()]
	db:OpenDB("users",function()
		db:InsertUser({id="lmao", ahahhahaha="lolololololololol"}, function()
			print("done!")
		end)
	end)
	print("lul")
end)
