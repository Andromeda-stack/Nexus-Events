RegisterNetEvent("PrepareGamemode")
AddEventHandler("PrepareGamemode", function(Gamemode, startnow)
    VotingVisible = false
    print(Gamemode.id)
    if Gamemode.id ~= 2 then
        TriggerServerEvent("Gamemode:UpdatePlayers:"..Gamemode.id, "Append", {serverId = GetPlayerServerId(PlayerId()), kills = 0, team = "0"})
    else
        TriggerServerEvent("Gamemode:UpdatePlayers:"..Gamemode.id, "Append", {serverId = GetPlayerServerId(PlayerId()), time = 0, team = "0"})
    end
    if startnow == nil or startnow == true then
        TriggerEvent("Gamemode:Init:"..Gamemode.id)
    end
end)

RegisterNetEvent("Nexus:StopSpectate")
AddEventHandler("Nexus:StopSpectate",function()
    Misc.SpectatorMode(false)
end)