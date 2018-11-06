resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
	--FUNCTIONS
	"functions/scaleforms.lua",
	"functions/streaming.lua",
	"functions/gui.lua",
	"functions/misc.lua",
	"functions/SpawnManager.lua",
	--Gamemodes
	"gamemodes/gamemode_handler_c.lua",
	"gamemodes/gun_game/gamemode_c.lua",
	"gamemodes/gun_game/pickup_c.lua",
	--VOTING
	"voting/vote_c.lua",
	--MAIN
	"main/main_c.lua",
}

server_scripts {
	"voting/vote_s.lua",
	"main/main_s.lua",
	"gamemodes/gamemode_handler_s.lua",
	"gamemodes/gun_game/gamemode_s.lua"
}

shared_scripts {
	"shared.lua"
}