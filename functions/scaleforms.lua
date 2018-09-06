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
