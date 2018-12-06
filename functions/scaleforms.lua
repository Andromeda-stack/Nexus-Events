Scaleform = {}

function Scaleform.Request(scaleform)
    local ScaleformHandle = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(ScaleformHandle) do Citizen.Wait(0) end
	return ScaleformHandle
end

function Scaleform.RequestHud(scaleform)
	local ScaleformHandle = RequestHudScaleform(scaleform)
	while not HasHudScaleformLoaded(ScaleformHandle) do Citizen.Wait(0) end
	return ScaleformHandle
end

function Scaleform.CallHudFunction(scaleform, returndata, theFunction, ...)
    BeginScaleformMovieMethodHudComponent(scaleform, theFunction)
    local arg = {...}
    if arg ~= nil then
        for i=1,#arg do
            local sType = type(arg[i])
            if sType == "boolean" then
                PushScaleformMovieMethodParameterBool(arg[i])
            elseif sType == "number" then
                if not string.find(arg[i], '%.') then
                    PushScaleformMovieMethodParameterInt(arg[i])
                else
                    PushScaleformMovieMethodParameterFloat(arg[i])
                end
            elseif sType == "string" then
                PushScaleformMovieMethodParameterString(arg[i])
            end
        end
		if not returndata then
        	EndScaleformMovieMethod()
		else
			EndScaleformMovieMethodReturn()
		end
    end
end

function Scaleform.Dispose(ScaleformHandle)
	SetScaleformMovieAsNoLongerNeeded(ScaleformHandle)
end

function Scaleform.CallFunction(scaleform, returndata, theFunction, ...)
    BeginScaleformMovieMethod(scaleform, theFunction)
    local arg = {...}
    if arg ~= nil then
        for i=1,#arg do
            local sType = type(arg[i])
            if sType == "boolean" then
                PushScaleformMovieMethodParameterBool(arg[i])
            elseif sType == "number" then
                if not string.find(arg[i], '%.') then
                    PushScaleformMovieMethodParameterInt(arg[i])
                else
                    PushScaleformMovieMethodParameterFloat(arg[i])
                end
            elseif sType == "string" then
                PushScaleformMovieMethodParameterString(arg[i])
            end
        end
		if not returndata then
        	EndScaleformMovieMethod()
		else
			EndScaleformMovieMethodReturn()
		end
    end
end

function Scaleform.Render2D(scaleform)
	DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
end

function Scaleform.Render2DScreenSpace(scaleform, x, y, width, height)
	DrawScaleformMovie(scaleform, x, y, width, height, 255, 255, 255, 255)
end

function Scaleform.Render3DNonAdditive(scaleform, x, y, z, rotx, roty, rotz, scalex, scaley, scalez)
    DrawScaleformMovie_3dNonAdditive(scaleform, x, y, z, rotx, roty, rotz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function Scaleform.Render3D(scaleform, x, y, z, rotx, roty, rotz, scalex, scaley, scalez)
    DrawScaleformMovie_3d(scaleform, x, y, z, rotx, roty, rotz, 2.0, 2.0, 1.0, scalex, scaley, scalez, 2)
end

function Scaleform.Render2DMasked(scaleform1, scaleform2, r, g, b, a)
    DrawScaleformMovieFullscreenMasked(scaleform1, scaleform2, r, g, b, a)
end

function Scaleform.RenderEndScreen(xp, money, win)
    Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)      
            local scaleforms = {}
            local label = win and "CELEB_WINNER" or "CELEB_LOSER"
			scaleforms.mp_celeb_bg = Scaleform.Request("MP_CELEBRATION_BG") --A_0
			scaleforms.mp_celeb_fg = Scaleform.Request("MP_CELEBRATION_FG") -- A_0+4
			scaleforms.celeb = Scaleform.Request("MP_CELEBRATION") -- A_0 +8

            --[[ for _, scaleform in pairs(scaleforms) do
                
                
            end ]]
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "CREATE_STAT_WALL", "ch", "HUD_COLOUR_BLACK", -1)
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "SET_PAUSE_DURATION", 3.0)
            Scaleform.CallFunction(scaleforms.mp_celeb_bg,false, "ADD_WINNER_TO_WALL", "ch", label, GetPlayerName(PlayerId()), "", 0, false, "", false) -- any text is possible
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "ADD_STAT_NUMERIC_TO_WALL", "ch", "XP", tonumber(xp), true, true)
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "ADD_STAT_NUMERIC_TO_WALL", "ch", "Money", tonumber(money), true, true)
            --Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "ADD_JOB_POINTS_TO_WALL", "ch", 1000, true)
            --Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "ADD_CASH_TO_WALL", "ch", 1000, false)
            --Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "ADD_REP_POINTS_AND_RANK_BAR_TO_WALL", "ch", 1500, 0, 0, 1000, 1, 2, "Rank", "Up")
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "ADD_BACKGROUND_TO_WALL", "ch")
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "SHOW_STAT_WALL", "ch")
            ---------------------------------------------------------------------------------------------
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "CREATE_STAT_WALL", "ch", "HUD_COLOUR_RED", -1)
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "SET_PAUSE_DURATION", 3.0)
            Scaleform.CallFunction(scaleforms.mp_celeb_fg,false, "ADD_WINNER_TO_WALL", "ch", label, GetPlayerName(PlayerId()), "", 0, false, "", false) -- any text is possible
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "ADD_STAT_NUMERIC_TO_WALL", "ch", "XP", tonumber(xp), true, true)
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "ADD_STAT_NUMERIC_TO_WALL", "ch", "Money", tonumber(money), true, true)
            --Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "ADD_JOB_POINTS_TO_WALL", "ch", 1000, true)
            --Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "ADD_CASH_TO_WALL", "ch", 1000, false)
            --Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "ADD_REP_POINTS_AND_RANK_BAR_TO_WALL", "ch", 1500, 0, 0, 1000, 1, 2, "Rank", "Up")
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "ADD_BACKGROUND_TO_WALL", "ch")
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "SHOW_STAT_WALL", "ch")
            ---------------------------------------------------------------------------------------------
            Scaleform.CallFunction(scaleforms.celeb, false, "CREATE_STAT_WALL", "ch", "HUD_COLOUR_BLUE", -1)
            Scaleform.CallFunction(scaleforms.celeb, false, "SET_PAUSE_DURATION", 3.0)
            Scaleform.CallFunction(scaleforms.celeb,false, "ADD_WINNER_TO_WALL", "ch", label, GetPlayerName(PlayerId()), "", 0, false, "", false) -- any text is possible
            Scaleform.CallFunction(scaleforms.celeb, false, "ADD_STAT_NUMERIC_TO_WALL", "ch", "XP", tonumber(xp), true, true)
            Scaleform.CallFunction(scaleforms.celeb, false, "ADD_STAT_NUMERIC_TO_WALL", "ch", "Money", tonumber(money), true, true)
            --Scaleform.CallFunction(scaleforms.celeb, false, "ADD_JOB_POINTS_TO_WALL", "ch", 1000, true)
            --Scaleform.CallFunction(scaleforms.celeb, false, "ADD_CASH_TO_WALL", "ch", 1000, false)
            --Scaleform.CallFunction(scaleforms.celeb, false, "ADD_REP_POINTS_AND_RANK_BAR_TO_WALL", "ch", 1500, 0, 0, 1000, 1, 2, "Rank", "Up")
            Scaleform.CallFunction(scaleforms.celeb, false, "ADD_BACKGROUND_TO_WALL", "ch")
            Scaleform.CallFunction(scaleforms.celeb, false, "SHOW_STAT_WALL", "ch")
			local starttime = GetNetworkTime()
            while GetNetworkTime() - starttime < 10000 and not canceled do
				Scaleform.Render2DMasked(scaleforms.mp_celeb_bg, scaleforms.mp_celeb_fg, 255, 255, 255, 255)
				Scaleform.Render2D(scaleforms.mp_celeb)
                HideHudAndRadarThisFrame()
                SetFollowPedCamViewMode(4)
                Citizen.Wait(0)
                print(GetNetworkTime() - starttime)
            end
			StartScreenEffect("MinigameEndNeutral", 0, 0)
            PlaySoundFrontend(-1, "SCREEN_FLASH", "CELEBRATION_SOUNDSET")
            Scaleform.CallFunction(scaleforms.celeb, false, "CLEANUP")
            Scaleform.CallFunction(scaleforms.mp_celeb_fg, false, "CLEANUP")
            Scaleform.CallFunction(scaleforms.mp_celeb_bg, false, "CLEANUP")

            Scaleform.Dispose(scaleforms.celeb)
            Scaleform.Dispose(scaleforms.mp_celeb_bg)
            Scaleform.Dispose(scaleforms.mp_celeb_fg)
            return -- end thread
		end
	end)
end

function Scaleform.InitializeXP(xp, lowlimit, uplimit, gain)
    SCALEFORM_RANKBAR = RequestHudScaleform(19)
    while not HasHudScaleformLoaded(19) do Wait(0) end
    Scaleform.CallHudFunction(SCALEFORM_RANKBAR, false, "SET_RANK_SCORES", lowlimit, uplimit, xp, xp + gain, math.floor(xp/1000))
    Scaleform.CallHudFunction(SCALEFORM_RANKBAR, false, "SET_COLOUR", 116)
end