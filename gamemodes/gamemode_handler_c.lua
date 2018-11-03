createThread = Citizen.CreateThread
CreateThread = function()
	print("nice try cheater.")
end
Citizen.CreateThread = function()
	print("nice try cheater.")
end

RegisterNetEvent("PrepareGamemode")
AddEventHandler("PrepareGamemode", function(Gamemode)
    VotingVisible = false
    print(Gamemode.id)
    TriggerServerEvent("Gamemode:UpdatePlayers:4", "Append", {serverId = GetPlayerServerId(PlayerId()), level = 1})
	TriggerEvent("Gamemode:Init:"..Gamemode.id, Gamemode)
end)