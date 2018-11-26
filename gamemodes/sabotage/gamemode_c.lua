--local InitPos = {3615.9, 3789.83, 29.2}
local PlayerServerId = GetPlayerServerId(PlayerId())
local CurrentCenter
local CurrentKills
local Sessionised = false
local team = 0
Base0 = {}
Base1 = {}
local Bomb = false
local BombPlanted = false

RegisterNetEvent("Gamemode:Start:6")
RegisterNetEvent("Gamemode:Session:6")
RegisterNetEvent("Gamemode:FetchCoords:6")
RegisterNetEvent("Gamemode:End:6")
RegisterNetEvent("Gamemode:Init:6")
RegisterNetEvent("Gamemode:Join:6")

AddEventHandler("Gamemode:End:6", function(winner, xp) 
    Citizen.CreateThread(function()
        Sessionised = false
        --KABOOM
        --btw remember to wait for the explosion to end :^)
        print(winner, winnername)
        CurrentCenter = {}
        SpawnManager.removeSpawnPointByCoords({x=tonumber(_G["Base"..team].x), y=tonumber(_G["Base"..team].y), z=tonumber(_G["Base"..team].z)})
        SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})
        SpawnManager.forceRespawn()
        --[[ if winner == PlayerServerId then
            local start = GetGameTimer()

            while GetGameTimer() - start < 5000 do 
                Wait(0)
                DrawGameEndScreen(true)
            end
        else
            local start = GetGameTimer()

            while GetGameTimer() - start < 5000 do 
                Wait(0)
                DrawGameEndScreen(false, winnername)
            end
        end ]]
        if winner == PlayerServerId then Scaleform.RenderEndScreen(xp, xp/10, true) else Scaleform.RenderEndScreen(xp, xp/10, false) end
        SpawnManager.forceRespawn()
        
    end) 
end)

AddEventHandler("Gamemode:FetchCoords:6", function(Coords, Center, Base0, Base1, CurrentTeam)
    --CoordsX, CoordsY, CoordsZ = table.unpack(Misc.SplitString(Coords, ","))
    print(Center)
    CenterX, CenterY, CenterZ = table.unpack(Misc.SplitString(Center, ","))
    Base0X, Base0Y, Base0Z = table.unpack(Misc.SplitString(Base0, ","))
    Base1X, Base1Y, Base1Z = table.unpack(Misc.SplitString(Base1, ","))
    --[[ for i,spawnpoint in pairs(Coords) do
        print(table.unpack(Misc.SplitString(spawnpoint, ",")))
        local spawnx,spawny,spawnz = table.unpack(Misc.SplitString(spawnpoint, ","))
        --print(tonumber(spawnx),tonumber(spawny),tonumber(spawnz))
        SpawnManager.addSpawnPoint({x=tonumber(spawnx), y=tonumber(spawny), z=tonumber(spawnz), heading = 0.0, model=1657546978})
    end ]]
    _G["Base0"] = vector3(tonumber(Base0X),tonumber(Base0Y),tonumber(Base0Z))
    _G["Base1"] = vector3(tonumber(Base1X),tonumber(Base1Y),tonumber(Base1Z))
    CurrentCenter = vector3(tonumber(CenterX),tonumber(CenterY),tonumber(CenterZ))
    --SetEntityCoords(PlayerPedId(), tonumber(CoordsX), tonumber(CoordsY), tonumber(CoordsZ), 0.0, 0.0, 0.0, 0)
    team = CurrentTeam
    print("MY TEAM: "..CurrentTeam)
    print(Base0)
    print(Base1)
    SpawnManager.addSpawnPoint({x=tonumber(_G["Base"..team].x), y=tonumber(_G["Base"..team].y), z=tonumber(_G["Base"..team].z), heading = 0.0, model=1657546978})
    SpawnManager.forceRespawn()
end)

AddEventHandler("Gamemode:Init:6", function()
    -- this removes the initial spawn, no matter what.
    SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})
    --print("removing: " .. SpawnIDX[1])
    --print(json.encode(SpawnIDX))
    --local x,y,z = table.unpack(InitPos)
    Sessionised = true
    VotingVisible = false

    TriggerServerEvent("Gamemode:PollRandomCoords:6")

    N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId())

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
    FreezeEntityPosition(PlayerPedId(), false)
    --Wait(10000)
    --TriggerEvent("sabotage:UpGunLevel", 1)
    StartSabotage()
end)

AddEventHandler("Gamemode:Join:6", function()
    if Sessionised then
        --spectator mode:TODO
    end
end)

function StartSabotage()
    --Wait(2500)
    RenderScriptCams(false, 1, 500,  true,  true)

    Citizen.CreateThread(function()
        local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")

        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~LEAVING AREA", "Head back to the battle!")
        --UpdateGunLevel(1)
        local end_time
        while Sessionised do
            Citizen.Wait(0)
            local pCoords = GetEntityCoords(PlayerPedId(), true)
            if math.sqrt((CurrentCenter.x - pCoords.x)^2 + (CurrentCenter.y - pCoords.y)^2) > 300.0  then
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


    Citizen.CreateThread(function()
        --print('should guiiiiii', Sessionised)
        while Sessionised do
            --print(json.encode(GunLevels))
            Citizen.Wait(0)
            --GUI.DrawBar(0.13, "LEVEL", GunLevels[tostring(GetPlayerServerId(PlayerId()))], nil, 3)
            GUI.DrawBar(0.13, "KILLS", CurrentKills, nil, 4)
        end
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
            Citizen.Wait(0)
            DrawMarker(1, CurrentCenter.x, CurrentCenter.y, CurrentCenter.z - 300, 0, 0, 0, 0, 0, 0, 600.0, 600.0, 500.0, 0, 0, 255, 200, 0, 0, 0, 0)
        end
    end)
    Citizen.CreateThread(function()
        if team == 0 then
            while Sessionised do
                Wait(0)
                DrawMarker(1, Base0.x, Base0.y, Base0.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.5, 0, 153, 51, 200, 0, 0, 0, 0)
                GUI.DrawText3D(Base0.x, Base0.y, Base0.z, "Defend")
                DrawMarker(1, Base1.x, Base1.y, Base1.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.5, 204, 102, 0, 200, 0, 0, 0, 0)
                GUI.DrawText3D(Base1.x, Base1.y, Base1.z, "Attack")
                if BombPlanted then
                    if not end_time then print(end_time) end_time = GetNetworkTime() + 40000 print("setting endtime")end

                    if (end_time - GetNetworkTime()) > 0 then
                        GUI.DrawTimerBar(0.13, "DETONATION", ((end_time - GetNetworkTime()) / 1000), 1)
                    end
                end
                local pCoords = GetEntityCoords(PlayerPedId(), true)
                if  Misc.Distance(pCoords.x, _G["Base1"].x,pCoords.y, _G["Base1"].y) < 2.5 and not BombPlanted then
                    --print(Bomb, BombPlanted)
                    if IsControlJustPressed(0, 288) and Bomb and not BombPlanted then
                        TaskPlayAnim(PlayerPedId(), "missfbi_s4mop", "plant_bomb_a", 4.0, 1.0, 0.2, 0, 1.0, true, true, true)
                        -- add some more checks in the future
                        TriggerServerEvent("sabotage:BombPlanted",team)
                        --BombPlanted = true
                    end
                elseif Bomb and not BombPlanted then
                    --print("missiontext no plant")
                    GUI.MissionText("Plant the bomb using F1.", 1, 1)
                end
            end
        else
            while Sessionised do
                Wait(0)
                DrawMarker(1, Base1.x, Base1.y, Base1.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.5, 0, 153, 51, 200, 0, 0, 0, 0)
                GUI.DrawText3D(Base1.x, Base1.y, Base1.z, "~g~Defend")
                DrawMarker(1, Base0.x, Base0.y, Base0.z, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 0.5, 204, 102, 0, 200, 0, 0, 0, 0)
                GUI.DrawText3D(Base0.x, Base0.y, Base0.z, "~r~Attack")
                if BombPlanted then
                    if not end_time then print("setting endtime") end_time = GetNetworkTime() + 40000 print("setting endtime")end

                    if (end_time - GetNetworkTime()) > 0 then
                        GUI.DrawTimerBar(0.13, "DETONATION", ((end_time - GetNetworkTime()) / 1000), 1)
                    end
                end
                local pCoords = GetEntityCoords(PlayerPedId(), true)
                if  Misc.Distance(pCoords.x, _G["Base0"].x,pCoords.y, _G["Base0"].y) < 2.5 and not BombPlanted then
                    --print(IsControlJustPressed(0, 288), Bomb, BombPlanted)
                    if IsControlJustPressed(0, 288) and Bomb and not BombPlanted then
                        TaskPlayAnim(PlayerPedId(), "missfbi_s4mop", "plant_bomb_a", 4.0, 1.0, 0.2, 0, 1.0, true, true, true)
                        -- add some more checks in the future
                        TriggerServerEvent("sabotage:BombPlanted")
                        --BombPlanted = true
                    end
                elseif Bomb and not BombPlanted then
                    --print("missiontext no plant")
                    GUI.MissionText("Plant the bomb using  ~INPUT_REPLAY_START_STOP_RECORDING~.", 1, 1)
                end
            end
        end
    end)
    --[[ Citizen.CreateThread(function()
        while Sessionised do
            Citizen.Wait(0)
            local CurrentWeapon = WeaponLevels[GunLevels[tostring(PlayerServerId)
            if CurrentWeapon then
                if GetBestPedWeapon(PlayerPedId(),0) ~= GetHashKey(CurrentWeapon) then
                    print("Giving weapon: "..CurrentWeapon)
                    RemoveAllPedWeapons(PlayerPedId(), true)
                    GiveWeaponToPed(PlayerPedId(), GetHashKey(CurrentWeapon), 1000, false, true)
                end
            end
        end
    end) ]]
end


--[[ function DrawGameEndScreen(win, winner)
    print(win, winner)
    local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
    if win then
        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~y~YOU WIN!", "You were the first to reach the maximum level!")
    else
        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~YOU LOSE!", winner.." won the game.")
    end
    Scaleform.Render2D(ShardS)
end ]]

RegisterNetEvent("sabotage:UpdateLevels")
AddEventHandler("sabotage:UpdateLevels", function(PlayersList)
    print("Received GunData: "..json.encode(GunData).." And PlayersList "..json.encode(PlayersList))
    for i,v in ipairs(PlayersList) do
        if v.serverId == PlayerServerId then
            CurrentKills = v.kills
            print("Current Kills set to "..tostring(v.kills))
            team = v.team
            print("Current Team set to "..tostring(v.team))
        end
    end   
end)

RegisterNetEvent("sabotage:UpdateBombStatus")
AddEventHandler("sabotage:UpdateBombStatus", function(ours, planted)
    print(ours, planted)
    if ours==true and not Bomb and planted == nil then
        GUI.DrawGameNotification("~g~You now have the bomb!~s~ Go plant it ASAP! ~g~", true)
        Bomb = true
    elseif not ours==true and Bomb and planted == nil then
        GUI.DrawGameNotification("~r~You lost the bomb!~s~ Defend your team's base! ~g~", true)
        Bomb = false
    elseif ours == -99 and planted == team then
        GUI.DrawGameNotification("~r~The bomb has been planted!~s~ Defend it! ~g~", true)
        BombPlanted = true
    elseif ours == -99 and planted ~= team then
        GUI.DrawGameNotification("~r~The bomb has been planted!~s~ Defuse it! ~g~", true)
        BombPlanted = true
    end
end)
