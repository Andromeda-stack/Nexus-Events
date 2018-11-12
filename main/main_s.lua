AddEventHandler("playerDropped", function() 
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Leave:"..v.id,source)
	end
end)
--[[ CreateThread(function()
	local db = exports[GetCurrentResourceName()]
	db:OpenDB("users",function()
		for i=1,5000 do
			local start = GetGameTimer()
			db:InsertUser({id=i,ahahhahaha="idk fuck you ok?"}, function()
				print("done",GetGameTimer()-start)
			end)
		end
		local start = GetGameTimer()
		db:GetUser(10000, function()
			print("done",GetGameTimer()-start)
		end)
	end)
	print("lul")
end) ]]
