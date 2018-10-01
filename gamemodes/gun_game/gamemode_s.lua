local GunLevels = {}

AddEventHandler("Gamemode:Start:4", function()
    for i=0, GetNumPlayerIndices()-1 do
        local player = GetPlayerFromIndex(i)
        GunLevels[player] = 1
    end
end)

AddEventHandler("baseevents:onPlayerKilled", function(killerid, data)
    GunLevels[killerid] = GunLevels[killerid] + 1
    TriggerClientEvent("gun_game:UpGunLevel", killerid, GunLevels[killerid])
    TriggerClientEvent("gun_game:UpdateLevels", -1, GunLevels)
end)