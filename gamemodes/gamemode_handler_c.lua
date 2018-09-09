RegisterNetEvent("PrepareGamemode")
AddEventHandler("PrepareGamemode", function(Gamemode)
    VotingVisible = false
    print(Gamemode.id)
	TriggerEvent("Gamemode:Init:"..Gamemode.id, Gamemode)
end)