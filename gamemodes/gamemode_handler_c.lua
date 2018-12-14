RegisterNetEvent("PrepareGamemode")
AddEventHandler("PrepareGamemode", function(Gamemode, startnow)
    VotingVisible = false
    print(Gamemode.id)
    TriggerServerEvent("Gamemode:UpdatePlayers:"..Gamemode.id, "Append", {serverId = GetPlayerServerId(PlayerId()), kills = 0, team = "0"})
    if startnow == nil or startnow == true then
        TriggerEvent("Gamemode:Init:"..Gamemode.id)
    end
end)