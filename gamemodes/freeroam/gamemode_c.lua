local ready = false
local Sessionised = false
RegisterNetEvent("Freeroam:Start")

AddEventHandler("Freeroam:Start", function(msec)
    ready = false
    Sessionised = true
    Main(msec)
end)

RegisterNetEvent("Freeroam:End")

AddEventHandler("Freeroam:End", function()
    ready = false
    Sessionised = false
end)

function Main(msec)
    local msec = msec or 1200000

    local ammunationblips = {}

    for i,v in ipairs(Ammunations) do
        ammunationblips[#ammunationblips + 1] = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(ammunationblips[#ammunationblips], 110)
        SetBlipColour(ammunationblips[#ammunationblips], 38)
    end
    Citizen.CreateThread(function()
        while true do
            Wait(0)
            for i,v in ipairs(ammunationblips) do
                local coords = GetBlipCoords(v)
                local pcoords = GetEntityCoords(PlayerPedId())
                DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 0, 255, 200, 0, 0, 0, 0)
                if Misc.Distance(coords.x,pcoords.x,coords.y,pcoords.y) then
                    
                end
            end
        end
    end)
    Citizen.CreateThread(function()
        local start = GetGameTimer()
        local end_time = GetNetworkTime() + msec
        while GetGameTimer() - start < msec and Sessionised do 
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
            if IsControlJustReleased(0, 57) and not ready then
                ready = true
                TriggerServerEvent("Freeroam:ReadyUp")
            end
        end
        for i,v in ipairs(ammunationblips) do
            RemoveBlip(v)
        end
        ammunationblips = {}
    end)
end

