--local InitPos = {3615.9, 3789.83, 29.2}
local PlayerServerId = GetPlayerServerId(PlayerId())
local CurrentTime = 0
local Sessionised = false
local CurrentCenter = {}
local end_time
local TargetCoords = { x = 691.0, y = 614.0, z = 128.9 }

RegisterNetEvent("Gamemode:Start:2")
RegisterNetEvent("Gamemode:Session:2")
RegisterNetEvent("Gamemode:FetchCoords:2")
RegisterNetEvent("Gamemode:End:2")
RegisterNetEvent("Gamemode:Init:2")
RegisterNetEvent("Gamemode:Join:2")
RegisterNetEvent("race:UpdateTime")

AddEventHandler("Gamemode:Join:2", function()
    Misc.SpectatorMode(true) 
end)

AddEventHandler("Gamemode:End:2", function(winner, xp)
    Sessionised = false
    SpawnManager.removeAllSpawnPoints()
    SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
    SpawnManager.forceRespawn()
    EndRace(winner, xp)
end)

AddEventHandler("Gamemode:Init:2", function()
    -- this removes the initial spawn, no matter what.
    --SpawnManager.removeAllSpawnPoints()
    SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})
    --print("removing: " .. SpawnIDX[1])
    --print(json.encode(SpawnIDX))
    --local x,y,z = table.unpack(InitPos)
    Sessionised = true
    VotingVisible = false

    TriggerServerEvent("Gamemode:PollRandomCoords:2")

    --[[ N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId()) ]]
    Wait(1000)
    print("CREATING CAMERA")
    view1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(view1, tonumber(CurrentCenter.x), tonumber(CurrentCenter.y), tonumber(CurrentCenter.z) + 20)
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
    StartRace()
end)

AddEventHandler("Gamemode:FetchCoords:2", function(Coords)
    print(json.encode(Coords))
    for i,v in ipairs(Coords) do
        local Coord = {}
         Coord.x, Coord.y, Coord.z = table.unpack(Misc.SplitString(v, ","))
         print("adding spawnpoint")
        SpawnManager.addSpawnPoint({x = tonumber(Coord.x), y = tonumber(Coord.y), z = tonumber(Coord.z), heading = 0.0, model=1657546978})
    end
    local r = math.random(1, #Coords)
    CurrentCenter["x"], CurrentCenter["y"], CurrentCenter["z"] = table.unpack(Misc.SplitString(Coords[r], ","))
    SpawnManager.forceRespawn()
end)

AddEventHandler("race:UpdateTime", function(time, timer) CurrentTime = time if timer then end_time = GetNetworkTime()+timer end end)

AddEventHandler("Gamemode:Spawn:2", function()
    if Sessionised then
        RequestModel(GetHashKey(ChosenRaceModel))
        while not HasModelLoaded(GetHashKey(ChosenRaceModel)) do
            RequestModel(GetHashKey(ChosenRaceModel))
            Citizen.Wait(0)
        end
        local veh = CreateVehicle(GetHashKey(ChosenRaceModel), GetEntityCoords(PlayerPedId(), true), 0.0, true, true)
        SetEntityCollision(veh, false, false)
        SetModelAsNoLongerNeeded(GetHashKey(ChosenRaceModel))
        SetPedIntoVehicle(PlayerPedId(), veh, -1)
        SetVehicleDoorsLocked(veh, 4)
        SetVehicleForwardSpeed(veh, 300.0)
        SetEntityCollision(veh, true, true)
    end
end)

function StartRace()
    RequestModel(GetHashKey(ChosenRaceModel))
    while not HasModelLoaded(GetHashKey(ChosenRaceModel)) do
        RequestModel(GetHashKey(ChosenRaceModel))
        Citizen.Wait(0)
    end
    local veh = CreateVehicle(GetHashKey(ChosenRaceModel), GetEntityCoords(PlayerPedId(), true), 0.0, true, true)
    SetEntityCollision(veh, false, false)
    SetModelAsNoLongerNeeded(GetHashKey(ChosenRaceModel))
    SetPedIntoVehicle(PlayerPedId(), veh, -1)
    SetVehicleDoorsLocked(veh, 4)
    SetEntityCollision(veh, true, true)
    Citizen.CreateThread(function()
        local TargetBlip = AddBlipForCoord(TargetCoords.x, TargetCoords.y, TargetCoords.z)
        for i = 0, 255 do
            local entity = GetPlayerPed(i)
            local blips = {}
            if DoesEntityExist(entity) then
                blips[#blips + 1] = AddBlipForEntity(entity)
            end
        end
        SetBlipRoute(TargetBlip, true)
        while Sessionised do 
            Wait(0)
            if not end_time then end_time = GetNetworkTime() + 600000 end
            if Vdist(TargetCoords.x, TargetCoords.y, TargetCoords.z, GetEntityCoords(PlayerPedId())) < 5 then
                TriggerServerEvent('Gamemode:UpdateTime:2', CurrentTime)
                ShowNotification('~r~' .. GetPlayerName(PlayerId()) .. '~w~ finished in 1st.')
                break
            end
            
            if (end_time - GetNetworkTime()) > 0 then
                CurrentTime = 600 - ((end_time - GetNetworkTime())/1000)
                GUI.MissionText("Finish ~r~First~s~!", 1, 1)
                GUI.DrawBar(0.13, "TIME", CurrentTime, nil, 2)
                GUI.DrawTimerBar(0.13, "GAME END", ((end_time - GetNetworkTime()) / 1000), 1)
            else
                end_time = nil
            end
            local CoordTable = {}
            DrawMarker(1, TargetCoords.x, TargetCoords.y, TargetCoords.z, 0, 0, 0, 0, 0, 0, 0.5000, 0.5000, 0.2500, 255, 255, 0, 200, 0, 0, 0, 0)
        end
        for i,v in ipairs(blips) do
            RemoveBlip(v)
        end
        SetBlipRoute(TargetBlip, false)
        RemoveBlip(TargetBlip)
    end)
end

function EndRace(winner, xp)
    Scaleform.RenderEndScreen(xp, xp/10, winner == PlayerServerId)
    SetPlayerInvincible(PlayerId(), false)
    SetEntityAsMissionEntity(GetVehiclePedIsIn(PlayerPedId(), false), 1, 1)
    DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
    Sessionised = false
    end_time = nil
    Misc.SpectatorMode(false)
end