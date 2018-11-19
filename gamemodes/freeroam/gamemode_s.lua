local SessionRunning = false
local ready = {}
RegisterNetEvent("Freeroam:ReadyUp")

AddEventHandler("Freeroam:ReadyUp", function()
    ready[source] = "ok"
end)

AddEventHandler("Freeroam:Start", function()
    ready = {}
    SessionRunning = true
    TriggerClientEvent("Freeroam:Start", -1)
    Citizen.CreateThread(function()
        start = GetGameTimer()
        while GetGameTimer() - start < 1200000 and SessionRunning and  Misc.TableLength(ready) < GetNumPlayerIndices()  do
            Wait(0)
        end
        TriggerClientEvent("Freeroam:End", -1)
        TriggerEvent("StartVoting") 
    end)
end)

AddEventHandler("Freeroam:Leave", function(s)
    ready[s] = nil
end)

RegisterNetEvent("Freeroam:Join")

AddEventHandler("Freeroam:Join", function()
    TriggerClientEvent("Freeroam:Start", source, 1200000 - (GetGameTimer()-start))
end)