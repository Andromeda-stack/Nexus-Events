Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(529840125295853568)
		SetDiscordRichPresenceAsset('nexus')
		SetDiscordRichPresenceAssetSmall('nexus')
		SetDiscordRichPresenceAssetText('Nexus Events')
		
		--todo: improve this to display whether in a game session or freeroaming
		if Misc.GetNumberOfPlayers() < 2 then
			SetDiscordRichPresenceAssetSmallText('Waiting for more players...')
		else
			SetDiscordRichPresenceAssetSmallText('In-Game')
		end
		Citizen.Wait(20000)
	end
end)

