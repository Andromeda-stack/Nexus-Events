local AlwaysBlacklisted = {
	"RHINO",
	"POLICE",
	"POLICE2",
	"OPPRESSOR",
	"CARGOPLANE",
	"KHANJALI"
}

local PoliceWhitelisted = {
	"POLICE",
	"POLICE2"
}

function NewBlacklist(tableName)
	local NewBlacklistTable = AlwaysBlacklisted
	for i=#NewBlacklistTable, 1, -1 do
		for x=#tableName, 1, -1 do
			if NewBlacklistTable[i] == tableName[x] then
				print("Removed "..NewBlacklistTable[i])
				table.remove(NewBlacklistTable, i)
			end
		end
	end
	print("Finished generating blacklisted vehicles")
	return NewBlacklistTable
end

RegisterNetEvent("GetVehBlacklist")
AddEventHandler("GetVehBlacklist", function()
	if IsPlayerAceAllowed(source, "admin.vehicles") then
		TriggerClientEvent("RecieveVehBlacklist", source, {}) -- send them an empty table = allow all vehicles
	elseif IsPlayerAceAllowed(source, "police.vehicles") then
		local Blacklist = NewBlacklist(PoliceWhitelisted)
		TriggerClientEvent("RecieveVehBlacklist", source, PoliceBlacklist)
	else
		TriggerClientEvent("RecieveVehBlacklist", source, AlwaysBlacklisted)
	end
end)
