Misc = { }


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