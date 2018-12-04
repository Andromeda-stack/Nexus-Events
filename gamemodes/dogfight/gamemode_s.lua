local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true
local AvailableCoords = {
    {

        "-2313.08, 437.1, 173.98",
        "-2343.12, 280.96, 168.98",
        "-2270.01, 201.15, 169.12",
        "-2334.46, 243.23, 169.12",
        "-2315.62, 261.93, 174.12",
        "-2299.49, 286.95, 184.12",
        "-2278.35, 286.57, 184.12",
        "-2249.55, 307.79, 184.12",
        "-2224.06, 233.01, 174.12",
        "-2262.93, 205.72, 174.12",
        "-2326.4, 379.96, 173.98",
        "-2212.23, 215.88, 174.12",
        "-2235.71, 265.97, 174.13",
        "-2259.48, 271.73, 174.6",
        "-2187.77, 287.58, 169.12"
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
        PlayerList[getDogfightPlayerIndex(s)] = nil
    end
end)

AddEventHandler("Gamemode:Join:8", function(s)
    TriggerClientEvent("PrepareGamemode", -1, g)
    Wait(1000)
    TriggerClientEvent("dogfight:UpdateKills", -1, 0, 600000 - (GetGameTimer() - timer))
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
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10))
                end)
            else
                local xp = v.kills * 50
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                TriggerClientEvent("Gamemode:End:8", v.serverId, winner, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10))
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

AddEventHandler("Gamemode:Kill:8", function()
    if SessionActive then
        PlayerList[tonumber(getDogfightPlayerIndex(source))].kills = PlayerList[tonumber(getDogfightPlayerIndex(source))].kills + 1
        TriggerClientEvent("dogfight:UpdateKills", source, PlayerList[tonumber(getDogfightPlayerIndex(source))].kills)
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