local SessionRunning = false
local ready = {}
RegisterNetEvent("Freeroam:ReadyUp")

AddEventHandler("Freeroam:ReadyUp", function()
    ready[source] = "ok"
end)

AddEventHandler("Freeroam:Start", function()
    ready = {}
    SessionRunning = true
    print("starting freeroam")
    TriggerClientEvent("Freeroam:Start", -1)
    Citizen.CreateThread(function()
        start = GetGameTimer()
        print(Misc.TableLength(ready), GetNumPlayerIndices())
        while GetGameTimer() - start < 1200000 and SessionRunning and (Misc.TableLength(ready) < GetNumPlayerIndices()) or GetNumPlayerIndices() == 0 do
            Wait(0)
        end
        TriggerClientEvent("Freeroam:End", -1)
        SessionRunning = false
        TriggerEvent("StartVoting") 
    end)
end)

AddEventHandler("Freeroam:Leave", function(s)
    ready[s] = nil
end)

RegisterNetEvent("Freeroam:Join")

AddEventHandler("Freeroam:Join", function()
    if SessionRunning then
        print("joined freeroam: "..source)
        print(1200000 - (GetGameTimer()-start))
        TriggerClientEvent("Freeroam:Start", source, 1200000 - (GetGameTimer()-start))
    end
end)