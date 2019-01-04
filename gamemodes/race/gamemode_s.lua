local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true
local AvailableCoords = {
    {
        '-462.45803833008, 5984.732421875, 31.209409713746', 
        '-467.68585205078, 5989.716796875, 31.214052200318', 
        '-472.8892211914, 5994.6904296875, 31.222661972046', 
        '-478.09313964844, 5999.6640625, 31.223669052124', 
        '-482.61288452148, 6005.2817382812, 31.183181762696', 
        '-490.39685058594, 5997.8090820312, 31.137208938598', 
        '-485.19192504882, 5992.83203125, 31.230556488038', 
        '-477.3860168457, 5985.3671875, 31.22727394104', 
        '-471.9694519043, 5980.6220703125, 31.227611541748', 
        '-466.35076904296, 5976.1171875, 31.198091506958', 
        '-473.68618774414, 5969.7255859375, 31.197603225708', 
        '-478.821563720, 5974.771484375, 31.194599151612',
    }
}
local CurrentCoords = {}
local timer
local vehiclechosen = {}

RegisterNetEvent("Gamemode:UpdatePlayers:2")
RegisterNetEvent("Gamemode:PollRandomCoords:2")
RegisterNetEvent("Gamemode:VehicleDestroyed:2")
RegisterNetEvent("Gamemode:Join:2")
RegisterNetEvent('Gamemode:UpdateTime:2')
--RegisterNetEvent("Gamemode:Join:2")

AddEventHandler('Gamemode:UpdateTime:2', function(Timer)
    local sauce = source
    PlayerList[sauce].time = Timer
    TriggerClientEvent('Gamemode:End:2', sauce, true, 5000)
    for i, v in ipairs(GetPlayers()) do
        if v ~= sauce then TriggerClientEvent('Gamemode:End:2', -1, false, 350) end
    end
    Citizen.Wait(1000)
end)

AddEventHandler("Gamemode:Leave:2", function(s)
    if SessionActive then
        table.remove(PlayerList, getRacePlayerIndex(s))
    end
end)

AddEventHandler("Gamemode:Join:2", function(s)
    if SessionActive then
        TriggerClientEvent("Gamemode:Join:2", source)
    end
end)

AddEventHandler("Gamemode:Start:2", function(g)
    Citizen.CreateThread(function()
        CurrentCoords = {}
        TriggerClientEvent("PrepareGamemode", -1, g, false)
        Wait(2500)
        for i,v in ipairs(PlayerList) do
            local id = Misc.GetPlayerSteamId(v.serverId)
            db:GetUser(id, function(result)
                TriggerClientEvent("race:ChooseVehicle", v.serverId, result.vehicles)
            end)
        end
        print("^5[INFO]^7 Waiting for players to select vehicle")
        while #vehiclechosen < #PlayerList do Wait(0) end
        print("^5[INFO]^7 Vehicle selection is over")
        TriggerClientEvent("Gamemode:Init:2", -1)
        Wait(1000)
        TriggerClientEvent("race:UpdateTime", -1, 0)
        SessionActive = true
        timer = GetGameTimer()
        while GetGameTimer() - timer < 600000 and SessionActive and GetNumPlayerIndices() ~= 0 do
            Wait(0)
        end
        local winner = getRaceWinner()
        for i,v in ipairs(PlayerList) do
            if v.serverId == winner then
                local identifier = Misc.GetPlayerSteamId(winner)
                local xp = 2 * v.time * 50
                TriggerClientEvent("Gamemode:End:2", winner, winner, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            else
                local xp = v.time * 50
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                TriggerClientEvent("Gamemode:End:2", v.serverId, winner, math.floor(xp))
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

AddEventHandler("Gamemode:PollRandomCoords:2", function()
    if not (#CurrentCoords == 0) then
        print("coords were available")
        TriggerClientEvent("Gamemode:FetchCoords:2", source, CurrentCoords)
    else
        print("coords were NOT available")
        local r = math.random(1,#AvailableCoords)
        CurrentCoords = AvailableCoords[tonumber(r)]
        TriggerClientEvent("Gamemode:FetchCoords:2", source, CurrentCoords)
    end
    print(json.encode(CurrentCoords))
end)

AddEventHandler("Gamemode:Kill:2", function(time)
    print('Not needed')
end)

RegisterNetEvent("Gamemode:UpdatePlayers:2")
AddEventHandler("Gamemode:UpdatePlayers:2", function(Operation, Player)
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

RegisterNetEvent("race:VehicleChosen")
AddEventHandler("race:VehicleChosen", function()
    table.insert(vehiclechosen, source)
end)

function getRacePlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            return i
        end
    end
    return 0
end

function getRaceWinner()
    local winner
    for i,v in ipairs(PlayerList) do
        if not winner then
            winner = v.serverId
        elseif PlayerList[getRacePlayerIndex(winner)].time < v.time then
            winner = v.serverId
        end
    end
    return winner
end