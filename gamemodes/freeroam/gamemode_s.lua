local SessionRunning = false
local ready = {}
RegisterNetEvent("Freeroam:ReadyUp")
RegisterNetEvent("Freeroam:BoughtGun")

AddEventHandler("Freeroam:BoughtGun", function(w, name)
    local identifier = Misc.GetPlayerSteamId(source)
    local source = source
    print(w)
    local price = Weapons[tostring(w)].price
    if price > 0 then
        db:GetUser(identifier, function(user)
            if user.money > price and not Misc.TableIncludes (user.weapons, w) then
                user.weapons[#user.weapons + 1] = w
                db:UpdateUser(identifier, {money = math.floor(user.money - price), weapons = user.weapons},function() print("^4[INFO]^7 "..GetPlayerName(source).." bought a new weapon for $"..price)  end)
                TriggerClientEvent("Nexus:UpdateMoney", source, math.floor(user.money - price), user.xp)
                TriggerClientEvent("Freeroam:BoughtGun", source, true, "~g~ You now own "..name.."!", user.weapons)
            elseif Misc.TableIncludes (user.weapons, w) then
                TriggerClientEvent("Freeroam:BoughtGun", source, false, "~r~You already own this gun.")
            else
                TriggerClientEvent("Freeroam:BoughtGun", source, false, "~r~You don't have enough money.")
            end
        end)
    else
        TriggerClientEvent("Freeroam:BoughtGun", source, false, "~r~Invalid price.")
    end
end)

AddEventHandler("Freeroam:ReadyUp", function()
    ready[source] = "ok"
end)

AddEventHandler("Freeroam:Start", function()
    ready = {}
    SessionRunning = true
    print("starting freeroam")
    print("^5PLAYERS:^7 "..json.encode(GetPlayers()))
    for i,v in ipairs(GetPlayers()) do
        local identifier = Misc.GetPlayerSteamId(v)
        db:GetUser(identifier, function(user)
            TriggerClientEvent("Freeroam:Start", v, 1200000, user.weapons)
        end)
    end
    Citizen.CreateThread(function()
        start = GetGameTimer()
        print(Misc.TableLength(ready), GetNumPlayerIndices())
        while GetGameTimer() - start < 1200000 and SessionRunning and (Misc.TableLength(ready) < GetNumPlayerIndices()) or GetNumPlayerIndices() < 2 do
            Wait(0)
        end
        TriggerClientEvent("Freeroam:End", -1)
        SessionRunning = false
        TriggerEvent("StartVoting") 
    end)
end)

AddEventHandler("Freeroam:Leave", function(s)
    ready[s] = nil
end)

RegisterNetEvent("Freeroam:Join")

AddEventHandler("Freeroam:Join", function()
    if SessionRunning then
        local source = source
        print("joined freeroam: "..source)
        print(1200000 - (GetGameTimer()-start))
        local identifier = Misc.GetPlayerSteamId(source)
        db:GetUser(identifier, function(user)
            TriggerClientEvent("Freeroam:Start", source, 1200000 - (GetGameTimer()-start), user.weapons)
        end)
    end
end)