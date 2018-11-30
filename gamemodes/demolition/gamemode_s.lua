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

RegisterNetEvent("Gamemode:UpdatePlayers:7")
RegisterNetEvent("Gamemode:PollRandomCoords:7")
RegisterNetEvent("Gamemode:VehicleDestroyed:7")
RegisterNetEvent("Gamemode:Join:7")
--RegisterNetEvent("Gamemode:Join:7")

AddEventHandler("Gamemode:Leave:4", function(s)
    if SessionActive then
        PlayerList[getDemolitionPlayerIndex(s)] = nil
    end
end)

AddEventHandler("Gamemode:Join:7", function(s)
    TriggerClientEvent("PrepareGamemode", -1, g)
    Wait(1000)
    TriggerClientEvent("demolition:UpdateKills", -1, 0, 600000 - (GetGameTimer() - start))
end)

AddEventHandler("Gamemode:Start:7", function(g)
    Citizen.CreateThread(function()
        CurrentCoords = {}
        TriggerClientEvent("PrepareGamemode", -1, g)
        Wait(1000)
        TriggerClientEvent("demolition:UpdateKills", -1, 0)
        SessionActive = true
        timer = GetGameTimer()
        while GetGameTimer() - start < 600000 and SessionActive do
            Wait(0)
        end
        local winner = getDemolitionWinner()
        for i,v in ipairs(PlayerList) do
            if v.serverId == winner then
                TriggerClientEvent("Gamemode:End:7", winner, winner, math.floor(2 * v.kills * 50))
            else
                TriggerClientEvent("Gamemode:End:7", v.serverId, winner, math.floor(v.kills * 50))
            end
        end
        SessionActive = false
        PlayerList = {}
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
    PlayerList[getDemolitionPlayerIndex(source)].kills = PlayerList[getDemolitionPlayerIndex(source)].kills + 1
    TriggerClientEvent("demolition:UpdateKills", source, PlayerList[getDemolitionPlayerIndex(source)].kills)
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

function getDemolitionPlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            return i
        end
    end
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