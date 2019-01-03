local ready = false
local Sessionised = false
local Notifications = {
	{"Hey! looks like you got some money to spend... Come check out our guns!", "CHAR_AMMUNATION", "Ammunation"},
	{"Ever wanted to get your ride pimped up a bit? Come check us out at Los Santos Customs, coming soon to Nexus Events!", "CHAR_LS_CUSTOMS", "Los Santos Customs"},
	{"Happen to find a ~r~bug~s~? You can contact us through the FiveM Forum or via discord! Do /contacts in chat to know more.", "CHAR_NEXUS", "Nexus Events"},
	{"Hey, we have a ~b~Discord~s~! Come check it out, https://discord.gg/vJrjTdZ", "CHAR_NEXUS", "Nexus Events"},
	{"You don't wanna be flying that lame ass lazer forever do you... Come buy some planes from us!", "CHAR_PEGASUS_DELIVERY", "Pegasus"}
}
local lastnotification
local Guns = {}
RegisterNetEvent("Freeroam:Start")
RegisterNetEvent("Freeroam:BoughtGun")

AddEventHandler("Freeroam:Start", function(msec,guns)
    if not Sessionised then
        ready = false
        Sessionised = true
        Guns = guns
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
            if GetGameTimer() - start < msec or Misc.GetNumberOfPlayers() < 2 then
                print("DETECTED PLAYERS: "..Misc.GetNumberOfPlayers().. "RESULT OF THE IF: "..tostring((end_time - GetNetworkTime()) > 0 or Misc.GetNumberOfPlayers() < 2))
                local readystr = ready and "~g~READY" or "~r~NOT READY"
		        local instructional = GUI.InstructionalButtons(48, "View Stats", 57, "Set As Ready")
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
            if Misc.GetNumberOfPlayers() < 2 then
                GUI.MissionText("Too few players connected, wait for "..(2-NetworkGetNumConnectedPlayers()).." more players to start a new match.", 1, 1)
            end
        end
        for i,v in ipairs(ammunationblips) do
            RemoveBlip(v)
        end
        ammunationblips = {}
    end)

    Citizen.CreateThread(function()
        while Sessionised do
            Wait(120000)
            local r = math.random(1,#Notifications)
            while Notifications[r] == lastnotification do
                Wait(0)
                r = math.random(1,#Notifications)
            end
            GUI.DrawGameNotification(Notifications[r][1], true, Notifications[r][2], Notifications[r][2], true, 1, Notifications[r][3], "")
        end
    end)

    Citizen.CreateThread(function()
        while Sessionised do
            Wait(500)
            for i,v in ipairs(Guns) do
                v = math.floor(v)
                if not HasPedGotWeapon(PlayerPedId(), v, false) then
                    print("GIVING WEAPON: "..v)
                    RequestWeaponAsset(v, 31, 0)
                    while not HasWeaponAssetLoaded(v) do
                        Wait(0)
                    end
                    GiveWeaponToPed(PlayerPedId(), v, 50000, false, true)
                end
            end
        end
    end)
end

AddEventHandler("Freeroam:BoughtGun", function(success, msg, newguns)
    GUI.DrawGameNotification(msg, true)
    if success then Guns = newguns print(json.encode(Guns)) end
end)
