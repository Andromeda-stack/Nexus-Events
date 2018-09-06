resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

client_scripts {
	--FUNCTIONS
	"functions/scaleforms.lua",
	"functions/colours.lua",
	"functions/streaming.lua",
	"functions/gui.lua",
	--VOTING
	"voting/vote_c.lua",
	--MAIN
	"main/main_c.lua"
}

server_scripts {
	"voting/vote_s.lua",
	"main/main_s.lua"
}
