local MyBlacklistedVehs

RegisterNetEvent("RecieveVehBlacklist")
AddEventHandler("RecieveVehBlacklist", function(blacklisted)
    MyBlacklistedVehs = blacklisted
end)

Citizen.CreateThread(function()
    TriggerServerEvent("GetVehBlacklist")

    while true do
        Citizen.Wait(0)
        if MyBlacklistedVehs ~= nil and IsPedInAnyVehicle(PlayerPedId(), true) then -- Making sure we actual have the blacklisted vehicles before attempting to check
            for i=1, #MyBlacklistedVehs do
                local veh = GetVehiclePedIsUsing(PlayerPedId())
                if IsVehicleModel(veh, MyBlacklistedVehs[i]) then
                    local VehName = GetLabelText( GetDisplayNameFromVehicleModel( GetEntityModel( veh ) ) )
                    TriggerEvent("DisplayNotification", "The vehicle you are trying to use (~r~"..VehName.."~s~) is blacklisted.", true)
					SetEntityAsMissionEntity(veh, true, true)
                    DeleteVehicle(veh)
				end
            end
        end
    end
end)
