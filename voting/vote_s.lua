local Gamemodes = {
	{id = 1, title="Team Deathmatch", desc="Good ol' TDM!", txd="mpweaponscommon", txn="w_ex_grenadesmoke"},
	{id = 2, title="Capture The Flag", desc="Two teams try to capture a flag and bring it back to their base.", txd="mpweaponscommon", txn="w_ex_pe"},
	{id = 3, title="Free For All", desc="Chaos will ensue! Kill kill kill!", txd="mpweaponscommon", txn="w_lr_rpg"},
	{id = 4, title="Another Gamemode", desc="This is another gamemode!", txd="mpweaponscommon", txn="w_sg_assaultshotgun"},
	{id = 5, title="Another Gamemode II", desc="This is another gamemode!", txd="mpweaponscommon", txn="w_sb_microsmg"},
	{id = 6, title="Another Gamemode III", desc="This is another gamemode!", txd="mpweaponscommon", txn="w_pi_combatpistol"},
	{id = 7, title="Another Gamemode IV", desc="This is another gamemode!", txd="digitaloverlay", txn="signal2"},
	{id = 8, title="Another Gamemode V", desc="This is another gamemode!", txd="digitaloverlay", txn="static1"},
	{id = 9, title="Another Gamemode VI", desc="This is another gamemode!", txd="mpweaponsgang0", txn="w_pi_stungun"},
	{id = 10, title="Another Gamemode VII", desc="This is another gamemode!", txd="mpweaponsgang0", txn="w_sr_heavysniper"},
}

function SelectVotedGamemodes()
    local Chosen = {}
    local Duplicates = {}
    local Copy = Gamemodes
    local randomIndex
    for i=1, 6 do
        repeat
            randomIndex = math.random(#Copy)
        until not Duplicates[randomIndex]
        Duplicates[randomIndex] = true
        table.insert(Chosen, Copy[randomIndex])
        table.remove(Copy, RandomIndex)
    end

    return Chosen
end

local Voted = {}

RegisterNetEvent("AddVote")
AddEventHandler("AddVote", function(VotedIndex)
    local found = false 
    for i=1, #Voted do
        if Voted[i].id == source then
            found = true
        end
    end

    if not found then
        table.insert(Voted, {id = source, vIndex = VotedIndex})
        print("Inserted the vote for "..VotedIndex)
        UpdateVotes()
    else
        print("Seems like someone is cheating, or it bugged!")
    end
end)

function GetTotalVotes()
    local TotalVoted = {
        [0] = 0,
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
    }

    for i=0, 5 do
        for x=1, #Voted do
            if Voted[x].vIndex == i then
                TotalVoted[i] = TotalVoted[i] + 1
            end
        end
    end

    return TotalVoted
end


function UpdateVotes()
    local Votes = GetTotalVotes()
    TriggerClientEvent("UpdateDisplayVotes", -1, Votes)
end

function StartVoteCounter()
    Citizen.CreateThread(function()
        local counter = 20
        for i=counter, 0, -1 do
            Wait(1000)
            if GetNumPlayerIndices() == #Voted then
                break
            end
        end

        local TotalVotes = GetTotalVotes()
        table.sort(TotalVotes)
        TriggerClientEvent("PrepareGamemode", -1, TotalVotes[#TotalVotes])
    end)
end



RegisterCommand("votedebug", function(source)
    Voted = {}
    StartVoteCounter()
	local randomGames = SelectVotedGamemodes()
	TriggerClientEvent("StartVoteScreen", -1, randomGames)
end)