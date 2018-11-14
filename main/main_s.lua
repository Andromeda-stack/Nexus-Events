db = exports[GetCurrentResourceName()]

AddEventHandler("playerDropped", function() 
	for k,v in pairs(Gamemodes) do
		TriggerEvent("Gamemode:Leave:"..v.id,source)
	end
end)

db:OpenDB("users",function()
	print("^5[INFO]^7 Nexus-Events: DB connection estabilished!")
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
	print("i got triggered")
	local source = source
	local identifier = Misc.GetPlayerSteamId(source)
	deferrals.defer()
	deferrals.update("Performing some checks...")
	print(identifier)
	if identifier then
		db:GetUser(identifier, function(result)
			print(result)
			if not result then
				db:InsertUser({id=identifier, money=5000, inventory = {}, banned = false, notes = ""}, function()
					print("^5[INFO]^7 Added new user to database: "..name)
				end)
				TriggerClientEvent("Nexus:UpdateMoney", source, 5000)
			elseif result.banned == true then
				deferrals.done("You have been banned from this server.")
			else
				TriggerClientEvent("Nexus:UpdateMoney", source, result.money)
				deferrals.done()
			end
		end)
	else
		deferrals.done("Steam needs to be running to join this server.")
	end
end)