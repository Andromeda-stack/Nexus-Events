local alwaysSafeEvents = {
	["playerDropped"] = true,
	["playerConnecting"] = true
}

local IgnoredEvents = {
    "onServerResourceStart",
    "onResourceStart",
    "getMapDirectives",
    "onResourceStarting",
    "onServerResourceStop",
	"onResourceStop",
	"playernames:extendContext",
	"hostedSession",
	"chat:init",
	"playernames:init",
	"rlUpdateNamesResult",
	"playerConnecting"
}

local eventHandlers = {}
local deserializingNetEvent = false

Citizen.SetEventRoutine(function(eventName, eventPayload, eventSource)
    local send = true
    for i=1, #IgnoredEvents do
        if string.find(eventName, IgnoredEvents[i]) ~= nil then
            send = false
        elseif string.find(eventName, "_cfx_") ~= nil then
            send = false
        end
    end

	if send then 
		local SourceData = "None"

		if eventSource ~= "" then
			local trueSource = string.gsub(eventSource, "net:", "")
			SourceData = "\n  • Name: "..GetPlayerName(trueSource).."\n  • ID: "..trueSource.."\n  • Identifiers: "..table.concat(GetPlayerIdentifiers(trueSource), ", ")
		end
        local eventSauce = (eventSource ~= "" and SourceData or "Console/Server")
        local unpacked = msgpack.unpack(eventPayload)
        if #unpacked > 0 and unpacked ~= nil then
            eventData = json.encode(unpacked)
        else
            eventData = "No data"
        end

        local eventMsg = ("```\nAn Event Was Triggered:\nEvent Name: %s\nEvent Data: %s\nSource Data: %s```"):format(eventName, eventData, eventSauce)
        PerformHttpRequest("https://discordapp.com/api/webhooks/511950615186898944/IrvUDeQba1muGKLB0LkU1ekWkGmIWFrg7DaCOB-2foDLJn15IY_5yL7VIWGOnzqDLoT6", function(errorCode, resultData, resultHeaders)
        end, "POST", json.encode({username = "Event Logs", content = eventMsg}), {})
    end

	_G.source = lastSource
end)

-- Other functions