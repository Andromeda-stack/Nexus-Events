local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true
local AvailableCoords = {
    {
        "-2259.422, 721.9238, 485.9566",
        "-1101.947, 1134.098, 486.0484",
        "532.4417, 1333.049, 439.3664",
        "487.2827, 5566.592, 832.9461",
        "3008.877, 5547.023, 477.517",
        "3301.795, 3191.196, 298.5136",
        "2108.882, 7.452843, 397.9909",
        "1912.356, -950.2598, 383.5872",
        "1805.029, -1788.137, 361.1957",
        "1191.367, -2561.947, 376.3322",
        "579.3691, -2790.286, 389.3622",
        "-18.84352, -2980.181, 427.0648",
        "-693.3309, -3028.971, 412.061",
        "-1315.261, -2777.871, 419.8076",
        "-1961.441, -2275.687, 442.3195",
        "-3158.529, -1558.504, 296.4935",
        "-3206.011, -811.1179, 453.3958",
        "-3298.01, 842.9553, 707.7516",
        "-3239.455, 2383.894, 822.6985",
        "-3058.0, 3331.139, 876.6508",
        "-2922.438, 3946.352, 933.5012",
        "-2442.659, 4529.723, 988.9813",
    }
}
local CurrentCoords = {}
local timer
local vehiclechosen = {}

RegisterNetEvent("Gamemode:UpdatePlayers:8")
RegisterNetEvent("Gamemode:PollRandomCoords:8")
RegisterNetEvent("Gamemode:VehicleDestroyed:8")
RegisterNetEvent("Gamemode:Join:8")
--RegisterNetEvent("Gamemode:Join:8")

AddEventHandler("Gamemode:Leave:8", function(s)
    if SessionActive then
        table.remove(PlayerList, getDogfightPlayerIndex(s))
    end
end)

AddEventHandler("Gamemode:Join:8", function(s)
    if SessionActive then
        -- spectator
    end
end)

AddEventHandler("Gamemode:Start:8", function(g)
    Citizen.CreateThread(function()
        CurrentCoords = {}
        TriggerClientEvent("PrepareGamemode", -1, g, false)
        Wait(2500)
        for i,v in ipairs(PlayerList) do
            local id = Misc.GetPlayerSteamId(v.serverId)
            db:GetUser(id, function(result)
                TriggerClientEvent("dogfight:ChooseVehicle", v.serverId, result.planes)
            end)
        end
        print("^5[INFO]^7 Waiting for players to select vehicle")
        while #vehiclechosen ~= #PlayerList do Wait(0) end
        print("^5[INFO]^7 Vehicle selection is over")
        TriggerClientEvent("Gamemode:Init:8", -1)
        Wait(1000)
        TriggerClientEvent("dogfight:UpdateKills", -1, 0)
        SessionActive = true
        timer = GetGameTimer()
        while GetGameTimer() - timer < 600000 and SessionActive do
            Wait(0)
        end
        local winner = getDogfightWinner()
        for i,v in ipairs(PlayerList) do
            if v.serverId == winner then
                local identifier = Misc.GetPlayerSteamId(winner)
                local xp = 2 * v.kills * 50
                TriggerClientEvent("Gamemode:End:8", winner, winner, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            else
                local xp = v.kills * 50
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                TriggerClientEvent("Gamemode:End:8", v.serverId, winner, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            end
        end
        print("^5[INFO]^7 Game ended. Winner: " .. GetPlayerName(winner))
        SessionActive = false
        PlayerList = {}
        Citizen.Wait(16000)
        print("Start Freeroam!")
        TriggerEvent("Freeroam:Start")
    end)
end)

AddEventHandler("Gamemode:PollRandomCoords:8", function()
    if not (#CurrentCoords == 0) then
        print("coords were available")
        TriggerClientEvent("Gamemode:FetchCoords:8", source, CurrentCoords)
    else
        print("coords were NOT available")
        local r = math.random(1,#AvailableCoords)
        CurrentCoords = AvailableCoords[tonumber(r)]
        TriggerClientEvent("Gamemode:FetchCoords:8", source, CurrentCoords)
    end
    print(json.encode(CurrentCoords))
end)

AddEventHandler("Gamemode:Kill:8", function(killerid)
    if SessionActive then
        PlayerList[tonumber(getDogfightPlayerIndex(killerid))].kills = PlayerList[tonumber(getDogfightPlayerIndex(killerid))].kills + 1
        TriggerClientEvent("dogfight:UpdateKills", killerid, PlayerList[tonumber(getDogfightPlayerIndex(killerid))].kills)
    end
end)

RegisterNetEvent("Gamemode:UpdatePlayers:8")
AddEventHandler("Gamemode:UpdatePlayers:8", function(Operation, Player)
    if Operation == "Append" then
        -- adding some checks to prevent cheating.
        for i,v in ipairs(PlayerList) do
            if v == Player then
                -- player is cheating.
                CancelEvent()
                return
            end
        end
        PlayerList[#PlayerList + 1] = Player
        print("added player")
    end
end)

RegisterNetEvent("dogfight:VehicleChosen")
AddEventHandler("dogfight:VehicleChosen", function()
    table.insert(vehiclechosen, source)
end)

function getDogfightPlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            return i
        end
    end
end

function getDogfightWinner()
    local winner
    for i,v in ipairs(PlayerList) do
        if not winner then
            winner = v.serverId
        elseif PlayerList[getDogfightPlayerIndex(winner)].kills < v.kills then
            winner = v.serverId
        end
    end
    return winner
end