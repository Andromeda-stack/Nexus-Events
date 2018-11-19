local ready = false
local Sessionised = false
RegisterNetEvent("Freeroam:Start")

AddEventHandler("Freeroam:Start", function()
    ready = false
    Sessionised = true
    Main()
end)

RegisterNetEvent("Freeroam:End")

AddEventHandler("Freeroam:End", function()
    ready = false
    Sessionised = false
end)

function Main()
    -- add blips and stuff once shayan pushes his commits
    Citizen.CreateThread(function()
        local start = GetGameTimer()
        local end_time = GetNetworkTime() + 1200000
        while GetGameTimer() - start < 1200000 and Sessionised do 
            Wait(0)
            if (end_time - GetNetworkTime()) > 0 then
                local readystr = ready and "~g~READY" or "~r~NOT READY"
                GUI.DrawTimerBar(0.13, "NEXT MATCH", ((end_time - GetNetworkTime()) / 1000), 1)
                GUI.DrawBar(0.13, "STATUS", readystr, nil, 3)
            else
                ready = false
                Sessionised = false
                break
            end
            if IsControlJustReleased(0, 288) and not ready then
                ready = true
                TriggerServerEvent("Freeroam:ReadyUp")
            end
        end
    end)
end

