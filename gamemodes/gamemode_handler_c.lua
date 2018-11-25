RegisterNetEvent("PrepareGamemode")
AddEventHandler("PrepareGamemode", function(Gamemode)
    VotingVisible = false
    print(Gamemode.id)
    TriggerServerEvent("Gamemode:UpdatePlayers:"..Gamemode.id, "Append", {serverId = GetPlayerServerId(PlayerId()), kills = 0, team = 0})
	TriggerEvent("Gamemode:Init:"..Gamemode.id)
end)