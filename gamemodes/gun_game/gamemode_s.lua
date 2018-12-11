local GunLevels = {}
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
        ['center'] = "-2237.00, 249.719, 176.147"
    }
}
local CurrentCoords = {}

RegisterNetEvent("Gamemode:UpdatePlayers:4")
RegisterNetEvent("Gamemode:Heartbeat:4")
RegisterNetEvent("Gamemode:PollRandomCoords:4")
RegisterNetEvent("Gamemode:UpdateUI:4")
RegisterNetEvent("Gamemode:Join:4")

AddEventHandler("Gamemode:Join:4", function()
    TriggerClientEvent("Gamemode:Join:4", source)
end)

AddEventHandler("Gamemode:Leave:4", function(s)
    if SessionActive then
        GunLevels[s] = nil
        PlayerList[getGunGamePlayerIndex(s)] = nil
        TriggerClientEvent("gun_game:UpdateLevels", -1, GunLevels, PlayerList)
    end
end)

--[[ AddEventHandler("GetGunGameState", function(cb)
    cb(SessionActive)
end) ]]

AddEventHandler("Gamemode:Start:4", function(g)
    CreateThread(function()
        InitGunGamePlayers()
        TriggerClientEvent("PrepareGamemode", -1, g)
        Wait(1000)
        TriggerClientEvent("gun_game:UpdateLevels", -1, GunLevels, PlayerList)
    end)

    SessionActive = true
    --[[ Citizen.CreateThread(function()
        while SessionActive do
            Wait(100)
            InitPlayers()
        end
    end) ]]
end)

AddEventHandler("Gamemode:Kill:4", function(killerid, source)
    -- this will be subject to lua injection exploits unfortunately, but there's not much that can be done.
    if SessionActive then
        local source = source
        if GetPlayerName(killerid) == nil then
            print("passing onPlayerKilled with id: "..source.." to onPlayerDied")
            TriggerEvent("baseevents:onPlayerDied", nil, nil, source)
            CancelEvent()
        end
        print(GetPlayerName(killerid).." killed ".. GetPlayerName(source))
        print(GunLevels[tostring(killerid)])
        if GunLevels[tostring(killerid)] == nil then 
            GunLevels[tostring(killerid)] = 1
        elseif GunLevels[tostring(killerid)] == 4 then
            print("Game end, winner: ".. GetPlayerName(killerid))
            EndGunGame(killerid)
        end
        GunLevels[tostring(killerid)] = GunLevels[tostring(killerid)] + 1
        PlayerList[getGunGamePlayerIndex(killerid)].kills = PlayerList[getGunGamePlayerIndex(killerid)].kills + 1
        TriggerClientEvent("gun_game:UpGunLevel", killerid, GunLevels[tostring(killerid)])
        TriggerClientEvent("gun_game:UpdateLevels", -1, GunLevels,PlayerList)
    end
end)

AddEventHandler("Gamemode:Suicide:4", function(s)
    -- this will be subject to lua injection exploits unfortunately, but there's not much that can be done.
    if SessionActive then
        local source = s or source
        print(source)
        print(GetPlayerName(source).." died.")
        if GunLevels[tostring(source)] == 1 then 
            GunLevels[tostring(source)] = 1
        else
            print(json.encode(GunLevels))
            GunLevels[tostring(source)] = GunLevels[tostring(source)] - 1
            TriggerClientEvent("gun_game:DownGunLevel", source, GunLevels[tostring(source)])
            TriggerClientEvent("gun_game:UpdateLevels", -1, GunLevels,PlayerList)
            --PlayerList[getGunGamePlayerIndex(source)].level = PlayerList[getGunGamePlayerIndex(source)].level - 1
        end
    end
end)

AddEventHandler("Gamemode:UpdatePlayers:4", function(Operation, Player)
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

AddEventHandler("Gamemode:PollRandomCoords:4", function()
    if CurrentCoords.coords == nil or CurrentCoords.center == nil then
        math.randomseed(os.time())
        print("Creating CurrentCoords")

        local ChosenIndex = math.random(1, Misc.TableLength(AvailableCoords))
        --local _ChosenIndex = math.random(1, #AvailableCoords[ChosenIndex].coords)
        print(ChosenIndex)
        print(json.encode(AvailableCoords))
        CurrentCoords = AvailableCoords[ChosenIndex]
        print(json.encode(CurrentCoords))
        TriggerClientEvent("Gamemode:FetchCoords:4", source, CurrentCoords.coords, CurrentCoords.center)
    else
        math.randomseed(os.time())
        
        --local _ChosenIndex = math.random(1, #AvailableCoords[ChosenIndex].coords)
        print(json.encode(CurrentCoords))
        TriggerClientEvent("Gamemode:FetchCoords:4", source, CurrentCoords.coords, CurrentCoords.center)
    end
end)

function getGunGamePlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            return i
        end
    end
end

function InitGunGamePlayers()
    for i=0, GetNumPlayerIndices() - 1 do
        local player = GetPlayerFromIndex(i)
        print("initializing player "..GetPlayerName(player) .. " id: ".. player)
        GunLevels[player] = 1
        print(json.encode(GunLevels))
        --PlayerList[getGunGamePlayerIndex(player)].kills = 1
    end
end

function EndGunGame(winner)
    local winner = winner 
    Citizen.CreateThread(function()
        --local players = GetPlayers()
        print(json.encode(PlayerList))
        for i,v in ipairs(PlayerList) do
            --print(players[i])
            if v.serverId == winner then
                local identifier = Misc.GetPlayerSteamId(winner)
                --print("winner, ".. getGunGamePlayerIndex(winner))
                local xp = 2 * (v.kills * 50)
                TriggerClientEvent("Gamemode:End:4", v.serverId, winner, xp)
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            else
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                --print("not winner, ".. getGunGamePlayerIndex(winner))
                local xp = (v.kills * 50)
                TriggerClientEvent("Gamemode:End:4", v.serverId, winner, xp)
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.") end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, math.floor(user.money + xp/10), user.xp + xp)
                end)
            end
        end
        CurrentCoords = {}
        GunLevels = {}
        PlayerList = {}
        SessionActive = false
        SessionRunnable = true
        Citizen.Wait(16000)
        print("Start Freeroam!")
        TriggerEvent("Freeroam:Start")
        --CancelEvent()
        --return
    end)
end