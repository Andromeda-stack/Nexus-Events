RegisterNetEvent("Gamemode:UpdatePlayers:3")
RegisterNetEvent("Gamemode:Heartbeat:3")
RegisterNetEvent("Gamemode:PollRandomCoords:3")
RegisterNetEvent("Gamemode:UpdateUI:3")

AddEventHandler("Gamemode:PollRandomCoords:3", function()
    local AvailableCoords = {
        "-2313.08, 437.1, 173.98",
        "-2343.12, 280.96, 168.98",
        "-2270.01, 201.15, 169.12",
        "-2334.46, 243.23, 169.12",
        "-2315.62, 261.93, 174.12",
        "-2299.49, 286.95, 184.12",
        "-2278.35, 286.57, 184.12",
        "-2249.55, 307.79, 184.12",
        "-2224.06, 233.01, 174.12",
        "-2262.93, 205.72, 174.12",
        "-2326.4, 379.96, 173.98",
        "-2212.23, 215.88, 174.12",
        "-2235.71, 265.97, 174.13",
        "-2259.48, 271.73, 174.6",
        "-2187.77, 287.58, 169.12"
    }
    math.randomseed(os.time())

    local ChosenIndex = math.random(1, 15)

    TriggerClientEvent("Gamemode:FetchCoords:3", source, AvailableCoords[ChosenIndex])
end)