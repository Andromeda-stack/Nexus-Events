local GunLevels = {}
local PlayerList = {}
local Session_
local SessionActive = false
local SessionRunnable = true

RegisterNetEvent("Gamemode:UpdatePlayers:4")
RegisterNetEvent("Gamemode:Heartbeat:4")
RegisterNetEvent("Gamemode:PollRandomCoords:4")
RegisterNetEvent("Gamemode:UpdateUI:4")

AddEventHandler("Gamemode:Start:4", function()
    for i=0, GetNumPlayerIndices() - 1 do
        local player = GetPlayerFromIndex(i)
        GunLevels[player] = 1
    end
end)

AddEventHandler("baseevents:onPlayerKilled", function(killerid, data)
    GunLevels[killerid] = GunLevels[killerid] + 1
    TriggerClientEvent("gun_game:UpGunLevel", killerid, GunLevels[killerid])
    TriggerClientEvent("gun_game:UpdateLevels", -1, GunLevels)
    PlayerList[getPlayerIndex(killerid)].level = PlayerList[getPlayerIndex(killerid)].level + 1
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
    elseif Operation == "Fetch" then
        -- this doesn't make sense, but shhhh we'll figure it out later :^)
        return PlayerList
    end
end)

AddEventHandler("Gamemode:PollRandomCoords:4", function()
    local AvailableCoords = {
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
    math.randomseed(os.time())

    local ChosenIndex = math.random(1, 15)

    TriggerClientEvent("Gamemode:FetchCoords:4", source, AvailableCoords[ChosenIndex])
end)

local function getPlayerIndex(id)
    for i,v in ipairs(PlayerList) do
        if v.serverId == id then
            return i
        end
    end
end