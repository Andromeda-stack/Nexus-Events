local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true
local AvailableCoords = {
    {
        ['coords'] = {
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
        },
        ['center'] = "-2237.00, 249.719, 176.147",
        ['model0'] = 1846523796,
        ['model1'] = 946007720
    }
}
local CurrentCoords = {}
local timer
local gm

RegisterNetEvent("Gamemode:UpdatePlayers:9")
RegisterNetEvent("Gamemode:PollRandomCoords:9")
RegisterNetEvent("Gamemode:VehicleDestroyed:9")
RegisterNetEvent("Gamemode:Join:9")
--RegisterNetEvent("Gamemode:Join:9")

AddEventHandler("Gamemode:Leave:9", function(s)
    if SessionActive then
        PlayerList[getTDMPlayerIndex(s)] = nil
    end
end)

AddEventHandler("Gamemode:Join:9", function(s)
    if SessionActive then
        -- spectator
    end
end)

AddEventHandler("Gamemode:Start:9", function(g)
    Citizen.CreateThread(function()
        gm = g
        CurrentCoords = {}
        TriggerClientEvent("PrepareGamemode", -1, g)
        Wait(1000)
        InitTDMPlayers()
        Wait(1000)
        TriggerClientEvent("TDM:UpdateKills", -1, 0)
        SessionActive = true
        timer = GetGameTimer()
        while GetGameTimer() - timer < 600000 and SessionActive do
            Wait(0)
        end
        local winner = getTDMWinner()
        for i,v in ipairs(PlayerList) do
            if v.team == winner then
                local identifier = Misc.GetPlayerSteamId(winner)
                local xp = 2 * v.kills * 50
                TriggerClientEvent("Gamemode:End:9", v.serverId, true, math.floor(xp))
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            else
                local xp = v.kills * 50
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                TriggerClientEvent("Gamemode:End:9", v.serverId, false, math.floor(xp))
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

AddEventHandler("Gamemode:PollRandomCoords:9", function()
    if not (#CurrentCoords == 0) then
        print("coords were available")
        TriggerClientEvent("Gamemode:FetchCoords:9", source, CurrentCoords.coords, CurrentCoords.center, CurrentCoords['model'..PlayerList[getTDMPlayerIndex(source)].team])
    else
        print("coords were NOT available")
        print(json.encode(PlayerList))
        local r = math.random(1,#AvailableCoords)
        CurrentCoords = AvailableCoords[tonumber(r)]
        TriggerClientEvent("Gamemode:FetchCoords:9", source, CurrentCoords.coords, CurrentCoords.center, CurrentCoords['model'..PlayerList[getTDMPlayerIndex(source)].team])
    end
end)

AddEventHandler("Gamemode:Kill:9", function(killerid, source)
    if SessionActive and PlayerList[tonumber(getTDMPlayerIndex(killerid))].team ~= PlayerList[tonumber(getTDMPlayerIndex(source))].team then
        PlayerList[tonumber(getTDMPlayerIndex(killerid))].kills = PlayerList[tonumber(getTDMPlayerIndex(killerid))].kills + 1
        local teamkills = 0
        for i,v in ipairs(PlayerList) do
            if v.team == PlayerList[tonumber(getTDMPlayerIndex(killerid))].team then
                teamkills = teamkills + v.kills
            end
        end
        for i,v in ipairs(PlayerList) do
            if v.team == PlayerList[tonumber(getTDMPlayerIndex(killerid))].team then
                TriggerClientEvent("TDM:UpdateKills", v.serverId, teamkills)
            end
        end
    end
end)

RegisterNetEvent("Gamemode:UpdatePlayers:9")
AddEventHandler("Gamemode:UpdatePlayers:9", function(Operation, Player)
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

function getTDMPlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            print("^4[INFO]^7 Found "..GetPlayerName(id).."'s index.'")
            return i
        end
    end
end

function getTDMWinner()
    local kills0 = 0
    local kills1 = 0
    for i,v in ipairs(PlayerList) do
        if v.team == "0" then
            kills0 = kills0 + v.kills
        else
            kills1 = kills1 + v.kills
        end
    end
    return (kills0>kills1) and "0" or "1"
end

function InitTDMPlayers()
    local switch = true
    for i,v in ipairs(PlayerList) do
        if switch then PlayerList[i].team = "0" else PlayerList[i].team = "1" end
        switch = not switch
    end
end