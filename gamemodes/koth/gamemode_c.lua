--local InitPos = {3615.9, 3789.83, 29.2}
local PlayerServerId = GetPlayerServerId(PlayerId())
local CurrentPoints = 0
local Sessionised = false
local CurrentCastle = {}
local end_time
local CurrentWeapons = {}

RegisterNetEvent("Gamemode:Start:10")
RegisterNetEvent("Gamemode:Session:10")
RegisterNetEvent("Gamemode:FetchCoords:10")
RegisterNetEvent("Gamemode:End:10")
RegisterNetEvent("Gamemode:Init:10")
RegisterNetEvent("Gamemode:Join:10")
RegisterNetEvent("KOTH:UpdatePoints")

AddEventHandler("Gamemode:Join:10", function()
    Misc.SpectatorMode(true)
end)

AddEventHandler("Gamemode:End:10", function(winner, xp)
    Sessionised = false
    SpawnManager.removeAllSpawnPoints()
    SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
    SpawnManager.forceRespawn()
    EndKOTH(winner, xp)
end)

AddEventHandler("Gamemode:Init:10", function()
    -- this removes the initial spawn, no matter what.
    --SpawnManager.removeAllSpawnPoints()
    SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})
    --print("removing: " .. SpawnIDX[1])
    --print(json.encode(SpawnIDX))
    --local x,y,z = table.unpack(InitPos)
    Sessionised = true
    VotingVisible = false

    TriggerServerEvent("Gamemode:PollRandomCoords:10")

    N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId())
    Wait(1000)
    print("CREATING CAMERA")
    view1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(view1, tonumber(CurrentCastle.x), tonumber(CurrentCastle.y), tonumber(CurrentCastle.z) + 20)
    SetCamRot(view1, -20.0, 0.0, 180.0)
    SetCamFov(view1, 45.0)
    RenderScriptCams(true, 1, 500,  true,  true)
    AnimatedShakeCam(view1,"shake_cam_all@", "light", "", 1)
   
    Wait(10000)
    DestroyCam(view1, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    FreezeEntityPosition(PlayerPedId(), true)
    local start = GetGameTimer()
    -- we could play a sound or smth on the countdown as well
    print("DRAWING COUNTDOWN")
    while (GetGameTimer() - start) < 10000 do 
        Wait(0)
        HideHudAndRadarThisFrame()
        SetFollowPedCamViewMode(4)
        -- would be better if we were to freeze the player's cam, anyone knows how?
        --FreezePedCameraRotation(PlayerPedId())
        if (GetGameTimer() - start) < 7000 then
            --print("to start")
            GUI.DrawText("The Game Will Start Shortly", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if (GetGameTimer() - start) < 8000 and GetGameTimer() - start > 7000 then
            --print("3")
            GUI.DrawText("3", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if (GetGameTimer() - start) < 9000 and GetGameTimer() - start > 8000 then
            --print("2")
            GUI.DrawText("2", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if (GetGameTimer() - start) > 9000 then
            --print("1")
            GUI.DrawText("1", {x=0.5,y=0.5}, 2, {r=57,g=255,b=20,a=255}, 1.0, false, true, true, false, 0.1)
        end
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
        end
    end
    print("STARTING GAMEMODE")
    FreezeEntityPosition(PlayerPedId(), false)
    StartKOTH()
end)

AddEventHandler("Gamemode:FetchCoords:10", function(Coords, Castle, Weapons)
    for i,v in ipairs(Coords) do
        local Coord = {}
         Coord.x, Coord.y, Coord.z = table.unpack(Misc.SplitString(v, ","))
         print("adding spawnpoint")
        SpawnManager.addSpawnPoint({x = tonumber(Coord.x), y = tonumber(Coord.y), z = tonumber(Coord.z), heading = 0.0, model=1657546978})
    end
    CurrentWeapons = Weapons
    CurrentCastle.x, CurrentCastle.y, CurrentCastle.z = table.unpack(Misc.SplitString(Castle, ","))
    SpawnManager.forceRespawn()
end)

AddEventHandler("KOTH:UpdatePoints", function(Points, timer) CurrentPoints = Points if timer then end_time = GetNetworkTime()+timer end end)

function StartKOTH()
    Citizen.CreateThread(function()
        print(json.encode(CurrentWeapons))
        while Sessionised do
            Wait(500)
            for i,v in ipairs(CurrentWeapons) do
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

    Citizen.CreateThread(function()
        local lastvehicle = GetVehiclePedIsIn(PlayerPedId(),false)
        while Sessionised do 
            Wait(0)
            if not end_time then end_time = GetNetworkTime() + 600000 end

            if (end_time - GetNetworkTime()) > 0 then
                GUI.DrawBar(0.13, "POINTS", CurrentPoints, nil, 2)
                GUI.DrawTimerBar(0.13, "GAME END", ((end_time - GetNetworkTime()) / 1000), 1)
            else
                end_time = nil
            end
        end
    end)

    -- castle UI stuff loop
    Citizen.CreateThread(function()
        print(tonumber(CurrentCastle.x), tonumber(CurrentCastle.y), tonumber(CurrentCastle.z))
        local blip = AddBlipForRadius(tonumber(CurrentCastle.x) + 0.0, tonumber(CurrentCastle.y) + 0.0, tonumber(CurrentCastle.z) + 0.0,200.0)
        local blip2 = AddBlipForCoord(tonumber(CurrentCastle.x) + 0.0, tonumber(CurrentCastle.y) + 0.0, tonumber(CurrentCastle.z) + 0.0)
        SetBlipColour(blip, 23)
        SetBlipColour(blip2, 23)
        SetBlipAlpha(blip, 125)
        SetBlipSprite(blip, 9)
        SetBlipSprite(blip2, 181)
        SetBlipAsShortRange(blip2, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("~p~CASTLE")
        EndTextCommandSetBlipName(blip2)
        while Sessionised do
            Wait(0)
            local pCoords = GetEntityCoords(PlayerPedId(), true)
            if Misc.Distance(pCoords.x,tonumber(CurrentCastle.x), pCoords.y, tonumber(CurrentCastle.y)) > 200.0 then
                GUI.MissionText("Enter the ~p~castle area~s~ to get points!", 1, 1)
            else
                while Misc.Distance(pCoords.x,tonumber(CurrentCastle.x), pCoords.y, tonumber(CurrentCastle.y)) < 200.0 do
                    Wait(1000)
                    pCoords = GetEntityCoords(PlayerPedId(), true)
                    TriggerServerEvent("Gamemode:Point:10")
                end
            end
        end
        RemoveBlip(blip)
        RemoveBlip(blip2)
    end)

    Citizen.CreateThread(function()
        while Sessionised do
            Citizen.Wait(0)
            SetCanAttackFriendly(GetPlayerPed(-1), true, false)
            NetworkSetFriendlyFireOption(true)
        end
    end)

    Citizen.CreateThread(function()
        while Sessionised do
            SetDiscordRichPresenceAssetSmallText('King Of The Hill')
            SetRichPresence('King Of The Hill: '..CurrentPoints.." Points")
            Citizen.Wait(20000)
        end
    end)
end

function EndKOTH(winner, xp)
   Scaleform.RenderEndScreen(xp, xp/10, winner == PlayerServerId)
   SetPlayerInvincible(PlayerId(), false)
   Sessionised = false
   Misc.SpectatorMode(true)
end