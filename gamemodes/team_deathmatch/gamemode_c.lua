--local InitPos = {3615.9, 3789.83, 29.2}
local PlayerServerId = GetPlayerServerId(PlayerId())
local CurrentKills = 0
local Sessionised = false
local CurrentCenter = {}
local end_time
local CurrentWeapons = {}

RegisterNetEvent("Gamemode:Start:9")
RegisterNetEvent("Gamemode:Session:9")
RegisterNetEvent("Gamemode:FetchCoords:9")
RegisterNetEvent("Gamemode:End:9")
RegisterNetEvent("Gamemode:Init:9")
RegisterNetEvent("Gamemode:Join:9")
RegisterNetEvent("TDM:UpdateKills")

AddEventHandler("Gamemode:End:9", function(winner, xp)
    Sessionised = false
    SpawnManager.removeAllSpawnPoints()
    SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
    SpawnManager.forceRespawn()
    EndTDM(winner, xp)
end)

AddEventHandler("Gamemode:Init:9", function()
    -- this removes the initial spawn, no matter what.
    SpawnManager.removeAllSpawnPoints()
    SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})
    --print("removing: " .. SpawnIDX[1])
    --print(json.encode(SpawnIDX))
    --local x,y,z = table.unpack(InitPos)
    Sessionised = true
    VotingVisible = false

    TriggerServerEvent("Gamemode:PollRandomCoords:9")

    N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId())
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
    end
    print("STARTING GAMEMODE")
    FreezeEntityPosition(PlayerPedId(), false)
    StartTDM()
end)

AddEventHandler("Gamemode:FetchCoords:9", function(Coords, Center, Model, Weapons)
    print(json.encode(Center))
    for i,v in ipairs(Coords) do
        local Coord = {}
         Coord.x, Coord.y, Coord.z = table.unpack(Misc.SplitString(v, ","))
         print("adding spawnpoint")
        SpawnManager.addSpawnPoint({x = tonumber(Coord.x), y = tonumber(Coord.y), z = tonumber(Coord.z), heading = 0.0, model=Model})
    end
    CurrentWeapons = Weapons
    local r = math.random(1, #Coords)
    CurrentCenter["x"], CurrentCenter["y"], CurrentCenter["z"] = table.unpack(Misc.SplitString(Center, ","))
    SpawnManager.forceRespawn()
end)

AddEventHandler("TDM:UpdateKills", function(kills, timer) CurrentKills = kills if timer then end_time = GetNetworkTime()+timer end end)

AddEventHandler("Gamemode:Spawn:9", function()
    if Sessionised then
        
    end
end)

function StartTDM()
    Citizen.CreateThread(function()
        print(json.encode(CurrentWeapons))
        while Sessionised do
            Wait(0)
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
        local end_time
        while Sessionised do 
            Wait(0)
            if not end_time then end_time = GetNetworkTime() + 600000 end

            if (end_time - GetNetworkTime()) > 0 then
                GUI.MissionText("Kill the ~r~Enemy~s~!", 1, 1)
                GUI.DrawBar(0.13, "KILLS", CurrentKills, nil, 4)
                GUI.DrawTimerBar(0.13, "GAME END", ((end_time - GetNetworkTime()) / 1000), 3)
                DrawMarker(1, tonumber(CurrentCenter.x), tonumber(CurrentCenter.y), tonumber(CurrentCenter.z) - 300, 0, 0, 0, 0, 0, 0, 300.0, 300.0, 500.0, 0, 0, 255, 200, 0, 0, 0, 0)
            else
                end_time = nil
            end
        end
    end)

    Citizen.CreateThread(function()
        local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")

        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~LEAVING AREA", "Head back to the battle!")        
        while Sessionised do
            Citizen.Wait(0)
            local pCoords = GetEntityCoords(PlayerPedId(), true)
            if Misc.Distance(pCoords.x,CurrentCenter.x,pCoords.y,CurrentCenter.y) > 150.0  then
                if not end_time then end_time = GetNetworkTime() + 30000 end

                if (end_time - GetNetworkTime()) > 0 then
                    GUI.MissionText("Go to the ~b~shootout.", 1, 1)
                    Scaleform.Render2D(ShardS)
                    GUI.DrawTimerBar(0.13, "LEAVING AREA", ((end_time - GetNetworkTime()) / 1000), 1)
                    --SetBlipAlpha(Blip, 255)
                else
                    ExplodePedHead(PlayerPedId(), 0x1D073A89)
                    SpawnManager.forceRespawn()
                end
            else
                SetBlipAlpha(Blip, 0)
                end_time = nil
            end
        end
    end)
end

function EndTDM(winner, xp)
    Scaleform.RenderEndScreen(xp, xp/10, winner)
    SetPlayerInvincible(PlayerId(), false)
    Sessionised = false
    end_time = nil
end