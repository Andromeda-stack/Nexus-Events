Misc = { }
local spectatormode = false
local spectating = 0

function Misc.LeavingArea(x, y, z, x2, y2, z2, timer, missionmsg, timertext, scaletext1, scaletext2)
    local ShardS = Scaleform.Request("MP_BIG_MESSAGE_FREEMODE")
    Scaleform.CallFunction(ShardS, false, "SHOW_SHARD_CENTERED_TOP_MP_MESSAGE", scaletext1, scaletext2)
    if not IsEntityInArea(PlayerPedId(), x, y, z, x2, y2, z2, 1, 1, 1) then
        if not end_time then end_time = GetNetworkTime() + timer end
        if (end_time - GetNetworkTime()) > 0 then
            GUI.MissionText(missionmsg, 1, 1)
            Scaleform.Render2D(ShardS)
            GUI.DrawTimerBar(0.13, timertext, ((end_time - GetNetworkTime()) / 1000), 1)
        end
    else
        end_time = nil
    end
end

function Misc.SplitString(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function Misc.TableIncludes (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function Misc.GetPlayerIdentifer (source, ident, _sub)
	local len
	local identifiers

	if ident == nil then return end

	identifiers = GetPlayerIdentifiers(source)

	if _sub then
		len = string.len(ident)

		for i, identifier in ipairs(identifiers) do
			if string.sub(identifier, 1, len) == ident then
				return identifier
			end
		end
	else
		for i, identifier in ipairs(identifiers) do
			if ident == identifier then
				return identifier
			end
		end
	end
end;

local LIC = 'license:'
function Misc.GetPlayerLicense (i) return Misc.GetPlayerIdentifer(i, LIC, true) end;

local STM =	'steam:'
function Misc.GetPlayerSteamId (i) return Misc.GetPlayerIdentifer(i, STM, true) end;

function Misc.PlayerHasIdentifier (source, identifier)
	return Misc.GetPlayerIdentifer(source, identifier, false) ~= nil
end
function Misc.GetPlayerFromIdentifier (identifier)
	for k, playerId in ipairs(GetPlayers()) do
		if Misc.PlayerHasIdentifier(playerId, identifier) then
			return playerId
		end
	end
end

function Misc.DoCountdown(from)
		local Countdown = from / 1000
		for i=Countdown, 0.0, -0.1 do
			Countdown = i
			Citizen.Wait(100)
		end
end

function Misc.DoForXSeconds(sec, func)
	local start = GetGameTimer()

	while GetGameTimer() - start < sec*1000 do func() end
end

function Misc.TableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function Misc.Distance(x1,x2,y1,y2)
	return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function Misc.spectatePlayer(targetPed,target,name)
	local playerPed = PlayerPedId() -- yourself
	enable = true
	if targetPed == playerPed then enable = false end

	if(enable)then

			local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

			RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(true, targetPed)

			GUI.DrawGameNotification(string.format("Now spectating: ~g~%s", name), true)
	else

			local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

			RequestCollisionAtCoord(targetx,targety,targetz)
			NetworkSetInSpectatorMode(false, targetPed)

			GUI.DrawGameNotification("Stopped spectating.", true)
	end
end

function Misc.SpectatorMode(toggle)
	local toggle = toggle
	CreateThread(function()
		if toggle then
			spectatormode = true
			while not NetworkIsPlayerActive(spectating) do
				if spectating < NetworkGetNumConnectedPlayers() then
					spectating = spectating + 1
				else
					spectating = 0
				end
			end
			Misc.spectatePlayer(GetPlayerPed(spectating),spectating,GetPlayerName(spectating))
			while spectatormode do
				Wait(0)
				local instructional = GUI.InstructionalButtons(56, "Next Player")
				Scaleform.Render2D(instructional)
				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(spectating), true))
				GUI.DrawText3D(x, y, z + 1.0, GetPlayerName(spectating))
				if IsControlJustReleased(0, 56) then
					spectating = spectating + 1
					while not NetworkIsPlayerActive(spectating) do
						if spectating < NetworkGetNumConnectedPlayers() then
							spectating = spectating + 1
						else
							spectating = 0
						end
					end
					Misc.spectatePlayer(GetPlayerPed(spectating),spectating,GetPlayerName(spectating))
				end
			end
			Misc.spectatePlayer(PlayerPedId(),PlayerId(),GetPlayerName(PlayerId()))
		else
			spectatormode = false
		end
	end)
end