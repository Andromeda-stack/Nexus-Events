local db = exports[GetCurrentResourceName()]

AddEventHandler("playerDropped", function() 
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Leave:"..v.id,source)
	end
end)

db:OpenDB("users",function()
	print("^5[INFO]^7 Nexus-Events: DB connection estabilished!")
end)

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
	local source = source
	local identifier = Misc.GetPlayerLicense(source)
	deferrals.defer()
	deferrals.update("Doing a few checks...")
	db:GetUser(identifier, function(result)
		if not result then
			deferrals.update("Seems like you are a new user, creating new account...")
			db.InsertUser({id=identifier, money=5000, inventory = {}, banned = false, notes = ""}, function()
				print("^5[INFO]^7 Added new user to database: "..name)
			end)
			TriggerClientEvent("Nexus:UpdateMoney", source, 5000)
			deferrals.done()
		elseif result.banned == true then
			deferrals.done("You have been banned from this server.")
		else
			TriggerClientEvent("Nexus:UpdateMoney", source, result.money)
			deferrals.done()
		end
	end)
end)