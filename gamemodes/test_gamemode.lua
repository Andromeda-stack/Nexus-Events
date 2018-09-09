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
end)