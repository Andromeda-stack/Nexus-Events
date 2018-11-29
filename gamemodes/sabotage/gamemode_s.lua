local GunLevels = {}
local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true
local AvailableCoords = {
    {
        ['center'] = "-2237.00, 249.719, 176.147",
        ['base0'] = "-2294.2, 449.735, 174.601",
        ['base1'] = "-2205.25, 191.805, 174.602"
    }
}
local CurrentCoords = {}
local BomberMan


RegisterNetEvent("Gamemode:UpdatePlayers:6")
RegisterNetEvent("Gamemode:Heartbeat:6")
RegisterNetEvent("Gamemode:PollRandomCoords:6")
RegisterNetEvent("Gamemode:UpdateUI:6")
--RegisterNetEvent("Gamemode:Join:6")

AddEventHandler("Gamemode:Leave:6", function(s)
    if SessionActive then
        --GunLevels[s] = nil
        PlayerList[getSabotagePlayerIndex(s)] = nil
        TriggerClientEvent("sabotage:UpdateLevels", -1, PlayerList)
    end
end)

--[[ AddEventHandler("GetGunGameState", function(cb)
    cb(SessionActive)
end) ]]

AddEventHandler("Gamemode:Start:6", function(g)
    CreateThread(function()
        TriggerClientEvent("PrepareGamemode", -1, g)
        Wait(1000)
        InitSabotagePlayers()
        Wait(1000)
        TriggerClientEvent("sabotage:UpdateLevels", -1, PlayerList)
    end)

    SessionActive = true
    --[[ Citizen.CreateThread(function()
        while SessionActive do
            Wait(100)
            InitSabotagePlayers()
        end
    end) ]]
end)

AddEventHandler("Gamemode:Kill:6", function(killerid, source)
    -- this will be subject to lua injection exploits unfortunately, but there's not much that can be done.
    if SessionActive then
        local source = source
        if GetPlayerName(killerid) == nil then
            print("passing onPlayerKilled with id: "..source.." to onPlayerDied")
            TriggerEvent("baseevents:onPlayerDied", nil, nil, source)
            CancelEvent()
        end
        print(GetPlayerName(killerid).." killed ".. GetPlayerName(source))
        PlayerList[getSabotagePlayerIndex(killerid)].kills = PlayerList[getSabotagePlayerIndex(killerid)].kills + 1
        TriggerClientEvent("sabotage:UpdateLevels", -1, PlayerList)
        if source == BomberMan then
            local otherteam = {}
            for i,v in pairs(PlayerList) do
                if v.team ~= PlayerList[getSabotagePlayerIndex(BomberMan)] then
                    table.insert(otherteam, v.serverId)
                end
            end
            local r = math.random(1,#otherteam)
            TriggerClientEvent("sabotage:UpdateBombStatus", otherteam[r], true)
            TriggerClientEvent("sabotage:UpdateBombStatus", BomberMan, false)
            BomberMan = otherteam[r]
        end
    end
end)

AddEventHandler("Gamemode:Suicide:6", function(s)
    -- this will be subject to lua injection exploits unfortunately, but there's not much that can be done.
    if SessionActive then
        local source = s or source
        print(source)
        print(GetPlayerName(source).." died.")
        PlayerList[getSabotagePlayerIndex(source)].kills = PlayerList[getSabotagePlayerIndex(source)].kills - 1
        TriggerClientEvent("sabotage:UpdateLevels", -1, PlayerList)
        if source == BomberMan then
            local otherteam = {}
            for i,v in pairs(PlayerList) do
                if v.team ~= PlayerList[getSabotagePlayerIndex(BomberMan)] then
                    table.insert(otherteam, v.serverId)
                end
            end
            local r = math.random(1,#otherteam)
            TriggerClientEvent("sabotage:UpdateBombStatus", otherteam[r], true)
            TriggerClientEvent("sabotage:UpdateBombStatus", BomberMan, false)
            BomberMan = otherteam[r]
        end
    end
end)

AddEventHandler("Gamemode:UpdatePlayers:6", function(Operation, Player)
    if Operation == "Append" then
        -- adding some checks to prevent cheating.
        for i,v in ipairs(PlayerList) do
            if v == Player then
                print("cheats detected")
                CancelEvent()
                return
            end
        end
        PlayerList[#PlayerList + 1] = Player
        print("added player")
    end
end)

AddEventHandler("Gamemode:PollRandomCoords:6", function()
    if CurrentCoords.coords == nil or CurrentCoords.center == nil then
        math.randomseed(os.time())
        print("Creating CurrentCoords")

        local ChosenIndex = math.random(1, Misc.TableLength(AvailableCoords))
        --local _ChosenIndex = math.random(1, #AvailableCoords[ChosenIndex].coords)
        print(ChosenIndex)
        print(json.encode(AvailableCoords))
        CurrentCoords = AvailableCoords[ChosenIndex]
        print(json.encode(CurrentCoords))
        TriggerClientEvent("Gamemode:FetchCoords:6", source, CurrentCoords.coords, CurrentCoords.center, CurrentCoords.base0, CurrentCoords.base1, PlayerList[getSabotagePlayerIndex(source)].team)
    else
        math.randomseed(os.time())
        
        --local _ChosenIndex = math.random(1, #AvailableCoords[ChosenIndex].coords)
        print(json.encode(CurrentCoords))
        TriggerClientEvent("Gamemode:FetchCoords:6", source, CurrentCoords.coords, CurrentCoords.center, CurrentCoords.base0, CurrentCoords.base1, PlayerList[getSabotagePlayerIndex(source)].team)
    end
end)

function getSabotagePlayerIndex(id)
    print("getSabotagePlayerIndex: "..id)
    print(json.encode(PlayerList))
    for i,v in ipairs(PlayerList) do
        print(json.encode(v))
        if v.serverId == tonumber(id) then
            print("found index "..i)
            return i
        end
    end
end

function InitSabotagePlayers()
    local teamswitch = false
    local randomindex = math.random(0, GetNumPlayerIndices() - 1)
    print("bomberman index is: "..randomindex)
    print(json.encode(PlayerList))
    for i=0, GetNumPlayerIndices() - 1 do
        local player = GetPlayerFromIndex(i)
        print("initializing player "..GetPlayerName(player) .. " id: ".. player)
        print(json.encode(PlayerList))
        --PlayerList[getSabotagePlayerIndex(player)].kills = 1
        if teamswitch then
            PlayerList[getSabotagePlayerIndex(player)].team = 1
        else
            --print("initializing player ".. player.." index: "..getSabotagePlayerIndex(player))
            PlayerList[getSabotagePlayerIndex(player)].team = 0
        end
        if randomindex == i then
            print("setting bomberman up")
            BomberMan = player
            TriggerClientEvent("sabotage:UpdateBombStatus", player, true)
        end
        teamswitch = not teamswitch
    end
    TriggerClientEvent("sabotage:UpdateLevels", -1, PlayerList)
end

function EndSabotage(winner)
    local winner = winner 
    Citizen.CreateThread(function()
        --local players = GetPlayers()
        print(json.encode(PlayerList))
        for i,v in ipairs(PlayerList) do
            --print(players[i])
            if v.team == winner then
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                --print("winner, ".. getSabotagePlayerIndex(winner))
                local xp = 2 * (v.kills * 50)
                TriggerClientEvent("Gamemode:End:6", v.serverId, winner, xp)
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.")  end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, winner, math.floor(user.money + xp/10))
                end)
            else
                local identifier = Misc.GetPlayerSteamId(v.serverId)
                --print("not winner, ".. getSabotagePlayerIndex(winner))
                local xp = (v.kills * 50)
                TriggerClientEvent("Gamemode:End:6", v.serverId, winner, xp)
                db:GetUser(identifier, function(user)
                    db:UpdateUser(identifier, {money = math.floor(user.money + xp/10), xp = user.xp + xp},function() print("^4[INFO]^7 Updated User's Money and XP.") end)
                    TriggerClientEvent("Nexus:UpdateMoney", v.serverId, winner, math.floor(user.money + xp/10))
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

RegisterNetEvent("sabotage:BombPlanted")
AddEventHandler("sabotage:BombPlanted", function(team)
    print(source, BomberMan)
    print(source == BomberMan)
    print(tostring(source) == tostring(BomberMan))
    if tostring(source) == tostring(BomberMan) then
        print("Bomb has been Planted.")
        local team = team
        Citizen.CreateThread(function()
            print(team)
            for i,v in ipairs(PlayerList) do
                TriggerClientEvent("sabotage:UpdateBombStatus", v.serverId, -99, team, team ~= v.team)
            end
            Wait(40000)
            EndSabotage(team)
        end)
    end
end)