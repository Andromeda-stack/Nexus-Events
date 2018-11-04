RegisterNetEvent("Gamemode:Start:3")
RegisterNetEvent("Gamemode:Session:3")
RegisterNetEvent("Gamemode:FetchCoords:3")
RegisterNetEvent("Gamemode:End:3")

AddEventHandler("Gamemode:End:4", function(winner, winnername) 
    CreateThread(function()
        if winner == PlayerServerId then
            local start = GetGameTimer()

            while GetGameTimer() - start < 5000 do 
                DrawGameEndScreen(true)
            end
            return
        end
        local start = GetGameTimer()

        while GetGameTimer() - start < 5000 do 
            DrawGameEndScreen(false, winnername)
        end
    end) 
end)

AddEventHandler("Gamemode:FetchCoords:4", function(Coords)
    CoordsX, CoordsY, CoordsZ = table.unpack(Misc.SplitString(Coords, ","))
    print(CoordsX, CoordsY, CoordsZ)
    SetEntityCoords(PlayerPedId(), tonumber(CoordsX), tonumber(CoordsY), tonumber(CoordsZ), 0.0, 0.0, 0.0, 0)
end)

AddEventHandler("Gamemode:Init:4", function()
    local x,y,z = table.unpack(InitPos)
    Sessonised = true

    TriggerServerEvent("Gamemode:PollRandomCoords:4")

    N_0xd8295af639fd9cb8(PlayerPedId())

    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end

    N_0xd8295af639fd9cb8(PlayerPedId())

    view1 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(view1, tonumber(CoordsX), tonumber(CoordsY), tonumber(CoordsZ) + 20)
    SetCamRot(view1, -20.0, 0.0, 180.0)
    SetCamFov(view1, 45.0)
    RenderScriptCams(true, 1, 500,  true,  true)
    AnimatedShakeCam(view1,"shake_cam_all@", "light", "", 1)
   
    Wait(10000)
    DestroyCam(view1, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    SetFocusEntity(GetPlayerPed(PlayerId()))
    TriggerEvent("gun_game:UpGunLevel", 2)

    Wait(10000)
    StartMain()
end)

local GunLevels = {}


function StartMain()
    Wait(2500)
    RenderScriptCams(false, 1, 500,  true,  true)

    createThread(function()
        local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
        local bx,by,bz = table.unpack(InitPos)
        local Blip = AddBlipForCoord(bx, by, bz)

        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~LEAVING AREA", "Head back to the battle!")
        SetBlipAlpha(Blip, 0)

        while Sessionised do
            Citizen.Wait(0)
            if not IsEntityInArea(IsPedInAnyVehicle(PlayerPedId(), true) and GetVehiclePedIsIn(PlayerPedId(), false) or PlayerPedId(), 290.91, -858.1, 20.23, 107.82, -1003.69, 47.8, 1, 1, 1) then
                if not end_time then end_time = GetNetworkTime() + 30000 end

                if (end_time - GetNetworkTime()) > 0 then
                    GUI.MissionText("Go to the ~y~shootout.", 1, 1)
                    Scaleform.Render2D(ShardS)
                    GUI.DrawTimerBar(0.13, "LEAVING AREA", ((end_time - GetNetworkTime()) / 1000), 1)
                    SetBlipAlpha(Blip, 255)
                end
            else
                SetBlipAlpha(Blip, 0)
                end_time = nil
            end
        end
    end)


    createThread(function()
        while Sessionised do
            Citizen.Wait(0)
            GUI.DrawBar(0.13, "LEVEL", GunLevel, nil, 3)
            GUI.DrawBar(0.13, "KILLS", GunLevel, nil, 4)
        end
    end)
end