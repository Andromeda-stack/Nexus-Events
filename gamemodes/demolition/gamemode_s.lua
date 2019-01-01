local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true
local AvailableCoords = {
    {

        "1840.46, 3657.068, 34.46449",
        "1949.688, 3719.922, 33.25567",
        "1698.678, 3509.775, 36.00295",
        "1943.43, 3651.598, 33.00674",
        "1926.478, 3765.501, 31.84245",
        "2010.664, 3814.629, 31.79579",
        "2079.615, 3688.317, 34.70277",
        "1982.803, 3629.456, 35.87537",
        "1763.871, 3283.095, 41.2939",
        "1749.509, 3260.083, 41.69972",
        "1719.903, 3262.63, 41.00512",
        "1705.306, 3244.667, 41.20205",
        "1729.381, 3450.709, 40.08134",

    },
    {
        "240.9271, 6487.748, 31.34886",
        "133.6739, 6491.309, 31.19117",
        "98.04523, 6399.752, 32.43448",
        "8.299707, 6341.88, 30.93265",
        "-49.61012, 6330.21, 31.62525",
        "-74.20989, 6336.813, 32.75876",
        "-129.2203, 6280.018, 31.74695",
        "-471.6316, 5991.15, 31.4561",
        "-465.2863, 6022.534, 31.34454",
        "-433.6382, 6046.705, 31.68485",
        "-449.5665, 6052.15, 31.76118",
        "-399.3266, 6133.394, 31.73845",
        "-361.0489, 6135.099, 31.37751",
        "-321.7047, 6244.097, 31.12827",
        "-343.1935, 6322.041, 30.01815",
        "-271.5316, 6361.391, 32.13716",
        "-222.3319, 6385.387, 31.96451",
        "-168.7829, 6452.022, 31.10709",
    },
    {
        "-420.9879, -774.1438, 38.00009",
        "-393.7271, -784.9438, 37.45234",
        "-382.495, -864.8829, 38.97315",
        "-383.4495, -1009.584, 37.50831",
        "-425.4866, -1018.399, 37.51418",
        "-477.5155, -835.7545, 38.65787",
        "-493.6224, -854.1066, 31.57392",
        "-278.666, -1201.484, 37.43635",
        "-257.5378, -1226.277, 38.35328",
        "-256.2492, -1244.142, 37.6095",
        "-429.8642, -1246.74, 48.67427",
        "-418.6163, -1207.587, 54.53278",
    }
}
local CurrentCoords = {}
local timer
local vehiclechosen = {}

RegisterNetEvent("Gamemode:UpdatePlayers:7")
RegisterNetEvent("Gamemode:PollRandomCoords:7")
RegisterNetEvent("Gamemode:VehicleDestroyed:7")
RegisterNetEvent("Gamemode:Join:7")
--RegisterNetEvent("Gamemode:Join:7")

AddEventHandler("Gamemode:Leave:7", function(s)
    if SessionActive then
        table.remove(PlayerList, getDemolitionPlayerIndex(s))
    end
end)

AddEventHandler("Gamemode:Join:7", function(s)
    if SessionActive then
        TriggerClientEvent("Gamemode:Join:7", source)
    end
end)

AddEventHandler("Gamemode:Start:7", function(g)
    Citizen.CreateThread(function()
        CurrentCoords = {}
        TriggerClientEvent("PrepareGamemode", -1, g, false)
        Wait(2500)
        for i,v in ipairs(PlayerList) do
            local id = Misc.GetPlayerSteamId(v.serverId)
            db:GetUser(id, function(result)
                TriggerClientEvent("demolition:ChooseVehicle", v.serverId, result.vehicles)
            end)
        end
        print("^5[INFO]^7 Waiting for players to select vehicle")
        while #vehiclechosen < #PlayerList do Wait(0) end
        print("^5[INFO]^7 Vehicle selection is over")
        TriggerClientEvent("Gamemode:Init:7", -1)
        Wait(1000)
        TriggerClientEvent("demolition:UpdateKills", -1, 0)
        SessionActive = true
        timer = GetGameTimer()
        while GetGameTimer() - timer < 600000 and SessionActive and GetNumPlayerIndices() ~= 0 do
            Wait(0)
        end
        local winner = getDemolitionWinner()
        for i,v in ipairs(PlayerList) do
            if v.serverId == winner then
                local identifier = Misc.GetPlayerSteamId(winner)
                local xp = 2 * v.kills * 50
                TriggerClientEvent("Gamemode:End:7", winner, winner, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            else
                local xp = v.kills * 50
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                TriggerClientEvent("Gamemode:End:7", v.serverId, winner, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            end
        end
        for i,v in ipairs(GetPlayers()) do
            TriggerClientEvent("Nexus:StopSpectate", v)
        end
        print("^5[INFO]^7 Game ended. Winner: " .. GetPlayerName(winner))
        SessionActive = false
        PlayerList = {}
        Citizen.Wait(16000)
        print("Start Freeroam!")
        TriggerEvent("Freeroam:Start")
    end)
end)

AddEventHandler("Gamemode:PollRandomCoords:7", function()
    if not (#CurrentCoords == 0) then
        print("coords were available")
        TriggerClientEvent("Gamemode:FetchCoords:7", source, CurrentCoords)
    else
        print("coords were NOT available")
        local r = math.random(1,#AvailableCoords)
        CurrentCoords = AvailableCoords[tonumber(r)]
        TriggerClientEvent("Gamemode:FetchCoords:7", source, CurrentCoords)
    end
    print(json.encode(CurrentCoords))
end)

AddEventHandler("Gamemode:VehicleDestroyed:7", function()
    if SessionActive then
        print(GetPlayerName(source).." destroyed a vehicle")
        PlayerList[tonumber(getDemolitionPlayerIndex(source))].kills = PlayerList[tonumber(getDemolitionPlayerIndex(source))].kills + 1
        TriggerClientEvent("demolition:UpdateKills", source, PlayerList[tonumber(getDemolitionPlayerIndex(source))].kills)
    end
end)

RegisterNetEvent("Gamemode:UpdatePlayers:7")
AddEventHandler("Gamemode:UpdatePlayers:7", function(Operation, Player)
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

RegisterNetEvent("demolition:VehicleChosen")
AddEventHandler("demolition:VehicleChosen", function()
    table.insert(vehiclechosen, source)
end)

function getDemolitionPlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            return i
        end
    end
    return 0
end

function getDemolitionWinner()
    local winner
    for i,v in ipairs(PlayerList) do
        if not winner then
            winner = v.serverId
        elseif PlayerList[getDemolitionPlayerIndex(winner)].kills < v.kills then
            winner = v.serverId
        end
    end
    return winner
end