AddEventHandler("baseevents:onPlayerKilled", function(killerid, data)
    TriggerClientEvent("gun_game:UpGunLevel", killerid)
end)