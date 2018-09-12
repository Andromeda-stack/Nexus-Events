local InitPos = {199.32, -935.56, 32.69}

AddEventHandler("Gamemode:Init:4", function(GamemodeData)
    SetEntityCoords(PlayerPedId(), 199.32, -935.56, 32.0, 0.0, 0.0, 0.0, 0)
    N_0xd8295af639fd9cb8(PlayerPedId())
    local x,y,z = table.unpack(InitPos)
    while Citizen.InvokeNative(0x470555300D10B2A5) ~= 8 and Citizen.InvokeNative(0x470555300D10B2A5) ~= 10 do
        Citizen.Wait(0)
    end
    view1=CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(view1, x, y, z + 3.0)
    SetCamRot(view1, -20.0, 0.0, 180.0)
    SetCamFov(view1, 45.0)
    RenderScriptCams(true, 1, 500,  true,  true)

    StartMain()
end)

local GunLevel = 1

local WeaponLevels = {
    "WEAPON_PISTOL",
    "WEAPON_SMG",
    "WEAPON_RPG",
    "WEAPON_COMBATMG"
}

function StartMain()
    Wait(2500)
    RenderScriptCams(false, 1, 500,  true,  true)
    Citizen.CreateThread(function()
        local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
        Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", "~r~LEAVING AREA", "Head back to the battle!")
        local bx,by,bz = table.unpack(InitPos)
        local Blip = AddBlipForCoord(bx, by, bz)
        SetBlipAlpha(Blip, 0)
        UpdateGunLevel()
        while true do
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


    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            GUI.DrawBar(0.13, "YOUR SCORE", GunLevel, nil, 1)
        end
    end)
end

function UpdateGunLevel()
    local OldWeapon = WeaponLevels[GunLevel - 1]
    local NewWeapon = WeaponLevels[GunLevel]
    local ped = PlayerPedId()
    if OldWeapon then 
        RemoveWeaponFromPed(ped, GetHashKey(OldWeapon))
    end
    GiveWeaponToPed(ped, GetHashKey(NewWeapon), 1000, false, true)
end

RegisterNetEvent("gun_game:UpGunLevel")
AddEventHandler("gun_game:UpGunLevel", function()
    GunLevel = GunLevel + 1
    GUI.DrawGameNotification("~g~Level up!~s~ Your gun level is now: ~g~"..GunLevel, true)
    UpdateGunLevel()
end)