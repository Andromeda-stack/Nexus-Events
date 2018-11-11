resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description 'Nexus Events'
author 'IceHax & Shayan'
version 'v0.1'
resource_type 'gametype' { name = 'Nexus Events' }

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
	"gamemodes/gun_game/gamemode_s.lua",
	--FUNCTIONS
	"functions/misc.lua",
	--SQLITE
	"db/SQLite-Wrapper.net.dll",
	--"db/System.Data.SQLite.dll"
}

shared_scripts {
	"shared.lua"
}