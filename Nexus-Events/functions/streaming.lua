Streaming = { }

function Streaming.RequestTextureDict(dict)
	if not HasStreamedTextureDictLoaded(dict) then
		RequestStreamedTextureDict(dict)
		while not HasStreamedTextureDictLoaded(dict) do Citizen.Wait(0) end
	end
end
