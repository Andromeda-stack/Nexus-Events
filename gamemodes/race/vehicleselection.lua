local Vehicles = {}

local CurrentVehicle = 1
local Selecting = false

ChosenRaceModel = nil

function RacesetupCamera()
	view1=CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	SetCamCoord(view1, -1267.93, -2995.89, -47.49)
	SetCamRot(view1, 0.0, 0.0, 183.3)
	SetCamFov(view1, 45.0)
end

function RaceRequestAllVehicles()
    for i=1, #Vehicles do
        RequestModel(Vehicles[i].spawnName)
        while not HasModelLoaded(Vehicles[i].spawnName) do
            Wait(0)
        end
        print("Loaded: "..Vehicles[i].spawnName)
    end
end

function RaceNewVehicle()
    if not IsAnyVehicleNearPoint(-1267.04, -3013.16, -48.49, 50.0) then
        veh = CreateVehicle(GetHashKey(Vehicles[CurrentVehicle].spawnName), -1267.04, -3013.16, -48.49, 321.9, false, true)
    else
        heading = GetEntityHeading(veh)
        SetEntityAsMissionEntity(veh, 1, 1)
        DeleteVehicle(veh)
        veh = CreateVehicle(GetHashKey(Vehicles[CurrentVehicle].spawnName), -1267.04, -3013.16, -48.49, 321.9, false, true)
    end
    SetEntityHeading(veh, heading)
    FreezeEntityPosition(veh, true)
    print("vehicle: "..Vehicles[CurrentVehicle].Name)
    scaleform = RaceVehicleSelection(Vehicles[CurrentVehicle].Name, Vehicles[CurrentVehicle].speed, Vehicles[CurrentVehicle].handling, Vehicles[CurrentVehicle].damage, Vehicles[CurrentVehicle].armour)
end

function RaceVehicleSelection(vehName, speed, handling, damage, armour)
    scaleform = RequestScaleformMovie("mp_car_stats_20")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    PushScaleformMovieFunction(scaleform, "SET_VEHICLE_INFOR_AND_STATS") -- vehicleInfo
    PushScaleformMovieFunctionParameterString(vehName) --vehicleInfo
    PushScaleformMovieFunctionParameterString("Vehicle ("..CurrentVehicle.."/"..#Vehicles..")") --vehicleDetails
    PushScaleformMovieFunctionParameterString("MPCarHUD") --logoTXD
    PushScaleformMovieFunctionParameterString("hvy") --logoTexture
    PushScaleformMovieFunctionParameterString("Top Speed") --statStr1
    PushScaleformMovieFunctionParameterString("Handling") --statStr2
    PushScaleformMovieFunctionParameterString("Damage") --statStr3
    PushScaleformMovieFunctionParameterString("Armour") --statStr4
    PushScaleformMovieFunctionParameterInt(speed) --statVal1
    PushScaleformMovieFunctionParameterInt(handling) --statVal2
    PushScaleformMovieFunctionParameterInt(damage) --statVal3
    PushScaleformMovieFunctionParameterInt(armour) --statVal4
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function RaceshowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function RaceVehSelection(type)
    if type == "begin" then
        DoScreenFadeOut(2500)
        N_0xd8295af639fd9cb8(PlayerPedId())
        while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
            Citizen.Wait(0)
        end
        N_0xd8295af639fd9cb8(PlayerPedId())
        RacesetupCamera()
        Wait(2500)
        SetEntityCoords(PlayerPedId(), -1267.04, -3013.16, -48.49, 0.0, 0.0, 0.0, false) 
        Wait(2500)
        SetEntityCoords(PlayerPedId(), -1267.79, -2962.96, -36.9, 0, 0, 0, false)
        SetEntityHeading(PlayerPedId(), 175.8)
        FreezeEntityPosition(PlayerPedId(), true)
        Selecting = true
        LockMinimapAngle(180)
        SetGameplayCamRelativeHeading(87.58)
        SetGameplayCamRawPitch(10.77)
        RenderScriptCams(false, 1, 5000,  true,  true)
        Wait(2500)
        DoScreenFadeIn(2500)
        RenderScriptCams(true, 1, 5000,  true,  true)
        SetEntityAlpha(PlayerPedId(), 0, true)
        ShakeCam(view1,"HAND_SHAKE", 0.25)
        RaceRequestAllVehicles()
        RaceNewVehicle()
    else
        RenderScriptCams(false, 1, 2500,  true,  true)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityCoords(PlayerPedId(), 3615.9, 3789.83, 29.2, 0.0, 0.0, 0.0, false)
        UnlockMinimapAngle()
        Selecting = false

    end
end

RegisterCommand("startvehicleselection", function()
    TriggerEvent("race:ChooseVehicle")
end, false)

RegisterNetEvent("race:ChooseVehicle")
AddEventHandler("race:ChooseVehicle", function(v)
    Vehicles = v
    RaceVehSelection("begin")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if Selecting then
            x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.0, 0.0, 9))
            height = 15.0
            DrawScaleformMovie_3dNonAdditive(scaleform, x,y,z+9, 0, 0, 178.288, 0.0, 1.0, 0.0, height*1.8, height, 7.0, 0)
            SetGameplayCamRelativeHeading(5.0)
            SetGameplayCamRawPitch(10.77)
            ClampGameplayCamPitch(0.0, 0.0)
            local Buttons = GUI.InstructionalButtons(176, "Select", 175, "Next Vehicle", 174, "Previous Vehicle")
            DrawScaleformMovieFullscreen(Buttons, 255, 255, 255, 255)
            if IsControlJustPressed(0, 174) and CurrentVehicle ~= 1 then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                CurrentVehicle = CurrentVehicle - 1
                RaceNewVehicle()
            elseif IsControlJustPressed(0, 175) and CurrentVehicle ~= #Vehicles then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                CurrentVehicle = CurrentVehicle + 1
                RaceNewVehicle()
            elseif IsControlJustPressed(0, 176) then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                TriggerServerEvent("race:VehicleChosen", Vehicles[CurrentVehicle])
                ChosenRaceModel = Vehicles[CurrentVehicle].spawnName
                SetEntityAsMissionEntity(veh, 1, 1)
                DeleteVehicle(veh)
                RaceVehSelection("stop")
            end
            --SetEntityCoords(veh, -1267.04, -3013.16, -47.49, 0.0, 0, 0, false)
            SetEntityHeading(veh, GetEntityHeading(veh)+0.25)
        end
    end
end)