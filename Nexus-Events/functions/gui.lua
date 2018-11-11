GUI = {}

function GUI.DrawHelpText(text, loop, beep, duration)
	BeginTextCommandDisplayHelp("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, loop, beep, duration)
end

function GUI.MissionText(text, displayTime, drawImmediately)
	BeginTextCommandPrint("STRING")
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandPrint(displayTime, drawImmediately)
end

function GUI.DrawGameNotification(text, blink, picName1, picName2, flash, iconType, sender, subject)
    SetNotificationTextEntry("STRING")
    if not picName1 then
        AddTextComponentSubstringPlayerName(text)
    else
        SetNotificationMessage(picName1, picName2, flash, iconType, sender, subject)
    end
    DrawNotification(blink, true)
end

function GUI.DrawText(text, position, font, colour, scale, shadow, outline, center, rightJustify, width)
	SetTextFont(font)
	SetTextColour(colour.r, colour.g, colour.b, colour.a)
	SetTextScale(scale, scale)

	if shadow then
		SetTextDropshadow(8, 0, 0, 0, 255)
		SetTextDropShadow()
	end

	if outline then
		SetTextEdge(4, 0, 0, 0, 255)
		SetTextOutline()
	end

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(tostring(text))

	if center then
		SetTextCentre(true)
	elseif rightJustify then
		SetTextWrap(position.x - width, position.x)
		SetTextRightJustify(true)
	end

	EndTextCommandDisplayText(position.x, position.y)
end

function GUI.DrawPlaceMarker(x, y, z, radius, r, g, b, a)
	DrawMarker(1, x, y, z, 0, 0, 0, 0, 0, 0, radius, radius, radius, r, g, b, a, false, nil, nil, false)
end

function GUI.DrawBar(width, text, subText, colour, position, isPlayerText)
	local barIndex = position or 1
	local rectHeight = 0.038
	local rectX = GetSafeZoneSize() - width + width / 2
	local rectY = GetSafeZoneSize() - rectHeight + rectHeight / 2 - (barIndex - 1) * (rectHeight + 0.005)
	local hTextMargin = 0.003
	local textFont = isPlayerText and 4 or 0
	local subTextFont = 0
	local textColour = colour or { r = 254, g = 254, b = 254, a = 255 }
	local textScale = isPlayerText and 0.5 or 0.32
	local subTextScale = 0.5
	local textMargin = isPlayerText and 0.013 or 0.008

	Streaming.RequestTextureDict("timerbars")

	DrawSprite("timerbars", "all_black_bg", rectX, rectY, width, rectHeight, 0, 0, 0, 0, 128)
	GUI.DrawText(text, { x = GetSafeZoneSize() - width + hTextMargin, y = rectY - textMargin }, textFont, textColour, textScale, isPlayerText)
	GUI.DrawText(subText, { x = GetSafeZoneSize() - hTextMargin, y = rectY - 0.0175 }, subTextFont, textColour, subTextScale, false, false, false, true, width / 2)
end

function GUI.DrawTimerBar(width, text, seconds, position, isPlayerText)
	local textColour = seconds <= 10 and { r = 224, g = 50, b = 50, a = 255 } or {r = 254, g = 254, b = 254, a = 255 }
	GUI.DrawBar(width, text, string.format("%02.f", math.floor(seconds / 60))..':'..string.format("%02.f", math.floor(seconds % 60)), textColour, position, isPlayerText)
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

function GUI.InstructionalButtons(...)
    local scaleform = RequestScaleformMovie("instructional_buttons")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    local arg = {...}
    local numberOfButtons = tonumber(#arg / 2)
    for i=0,numberOfButtons-1 do
        local button = arg[2*i + 1]
        local msg = arg[2*i + 2]
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(i)
        Button(GetControlInstructionalButton(0, button, true))
        ButtonMessage(msg)
        PopScaleformMovieFunctionVoid()
    end

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end
