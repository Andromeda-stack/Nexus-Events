local Gamemodes = {
	{id = 1, title="TDM", desc="Good ol' TDM!", txd="mpweaponscommon", txn="w_ex_grenadesmoke"},
	{id = 2, title="ROBLOX", desc="Good game", txd="mpweaponscommon", txn="w_ex_pe"},
	{id = 3, title="test", desc="stuff", txd="mpweaponscommon", txn="w_lr_rpg"},
	{id = 4, title="aaa", desc="ssssss", txd="mpweaponscommon", txn="w_sg_assaultshotgun"},
	{id = 5, title="lol why", desc="kill me", txd="mpweaponscommon", txn="w_sb_microsmg"},
	{id = 6, title="xd", desc="sds", txd="mpweaponscommon", txn="w_pi_combatpistol"},
	{id = 7, title="xre", desc="sds", txd="mpweaponscommon", txn="w_pi_combatpistol"},
	{id = 8, title="xr232e", desc="sd23s", txd="mpweaponscommon", txn="w_pi_combatpistol"},
	{id = 9, title="xr32e", desc="s3ds", txd="mpweaponscommon", txn="w_pi_combatpistol"},
	{id = 10, title="x222222re", desc="sd44s", txd="mpweaponscommon", txn="w_pi_combatpistol"},
}

function SelectVotedGamemodes()
	local Chosen = {}
	-- TODO: Add code here to select 6 random gamemodes and return them
end



RegisterCommand("votedebug", function(source)
	TriggerClientEvent("StartVoteScreen", source, Gamemodes)
end)