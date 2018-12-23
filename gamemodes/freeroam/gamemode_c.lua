local ready = false
local Sessionised = false
RegisterNetEvent("Freeroam:Start")
RegisterNetEvent("Freeroam:BoughtGun")

AddEventHandler("Freeroam:Start", function(msec)
    if not Sessionised then
        ready = false
        Sessionised = true
        Main(msec)
    end
end)

RegisterNetEvent("Freeroam:End")

AddEventHandler("Freeroam:End", function()
    ready = false
    Sessionised = false
end)

function Main(msec)
    local msec = msec or 1200000

    local ammunationblips = {}

    Citizen.CreateThread(function()
        for i,v in ipairs(Ammunations) do
            ammunationblips[#ammunationblips + 1] = AddBlipForCoord(v.x, v.y, v.z)
            SetBlipSprite(ammunationblips[#ammunationblips], 110)
            SetBlipColour(ammunationblips[#ammunationblips], 38)
        end

        local menuopen = false
        while Sessionised do
            Wait(0)
            for i,v in ipairs(ammunationblips) do
                local coords = GetBlipCoords(v)
                local pcoords = GetEntityCoords(PlayerPedId())
                DrawMarker(1, coords.x, coords.y, coords.z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 0, 255, 200, 0, 0, 0, 0)
                if Misc.Distance(coords.x,pcoords.x,coords.y,pcoords.y) < 1.2 and not menuopen then
                    print("BLIP: "..coords.." PLAYER: "..pcoords)
                    print("opening menu")
                    menuopen = true
                    Citizen.CreateThread(function()
                        local v = v
                        print("BLIP ID: "..v)
                        Wait(100)
                        if not JayMenu.IsMenuOpened('ammunation') then
                            JayMenu.OpenMenu('ammunation')
                        end
                        local coords = GetBlipCoords(v)
                        local pcoords = GetEntityCoords(PlayerPedId())                  
                        while Misc.Distance(coords.x,pcoords.x,coords.y,pcoords.y) < 1.2 and Sessionised do
                            coords = GetBlipCoords(v)
                            pcoords = GetEntityCoords(PlayerPedId())    
                            if JayMenu.IsMenuOpened('ammunation') then
                                for k,v in pairs(Weapons) do
                                    if JayMenu.Button(GetLabelText(v.textLabel).. " - $" .. v.price) then
                                        print("bought a new gun")
                                        TriggerServerEvent("Freeroam:BoughtGun", tonumber(k), GetLabelText(v.textLabel))
                                    end
                                end
                    
                                JayMenu.Display()
                            end
                    
                            Citizen.Wait(0)
                        end
                        JayMenu.CloseMenu()
                        menuopen = false
                    end)
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
		        local instructional = GUI.InstructionalButtons(57, "Set As Ready")
                GUI.DrawTimerBar(0.13, "NEXT MATCH", ((end_time - GetNetworkTime()) / 1000), 3)
                GUI.DrawBar(0.13, "STATUS", readystr, nil, 5)
		        Scaleform.Render2D(instructional)
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

AddEventHandler("Freeroam:BoughtGun", function(success, msg)
    GUI.DrawGameNotification(msg, true)
end)
