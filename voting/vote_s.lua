local Voted = {}
VotingGamemodes = {}
local voting = false

function GetTotalVotes()
    local TotalVoted = {
        [0] = {votes = 0, id = 0},
        [1] = {votes = 0, id = 0},
        [2] = {votes = 0, id = 0},
        [3] = {votes = 0, id = 0},
        [4] = {votes = 0, id = 0},
        [5] = {votes = 0, id = 0},
    }

    for i=0, 5 do
        for x=1, #Voted do
            if Voted[x].vIndex == i then
                TotalVoted[i].id = VotingGamemodes[i + 1].id
                print(TotalVoted[i].id)
                TotalVoted[i].votes = TotalVoted[i].votes + 1
            end
        end
    end

    return TotalVoted
end

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

function UpdateVotes()
    TriggerClientEvent("UpdateDisplayVotes", -1, GetTotalVotes())
end

function RandomGamemodes()
    local g = {}
    math.randomseed(os.time())
    for i=1, 6 do
        local randomindex = math.random(1,#Gamemodes)
        repeat
            Citizen.Wait(0)
            randomindex = math.random(1,#Gamemodes)
        until not Misc.TableIncludes(g, Gamemodes[randomindex])

        table.insert(g, Gamemodes[randomindex])
    end
    return g
end

function GetWinner()
    local votes = {}
    local winner = 0
    local Votes = GetTotalVotes()

    for index, entry in pairs(Votes) do
        if Votes[winner].votes < entry.votes then
            winner = index
        end    
    end
    return Votes[winner].id
end

function StartVoteCounter()
    Citizen.CreateThread(function()
        voting = true
        print(GetNumPlayerIndices())
        while GetNumPlayerIndices() ~= #Voted or GetNumPlayerIndices() == 0 do Wait(0) end
        local TargetGamemode = GetWinner()
        print("Attempting to start "..TargetGamemode)
        TriggerEvent("Gamemode:Start:"..TargetGamemode,Gamemodes[GetIndexFromId(TargetGamemode)])
        Voted = {}
        voting = false

        --CurrentGamemode = VotingGamemodes
    end)
end

function GetIndexFromId(id)
    for i,v in ipairs(Gamemodes) do
        if id == v.id then
            return i
        end
    end
end


RegisterCommand("votedebug", function(source)
    Citizen.CreateThread(function()
        print("StartVoting was triggered.")
        StartVoteCounter()
        VotingGamemodes = RandomGamemodes()
	    TriggerClientEvent("StartVoteScreen", -1, VotingGamemodes)
    end)
end)

AddEventHandler("StartVoting", function()
    Citizen.CreateThread(function()
        print("StartVoting was triggered.")
        StartVoteCounter()
        VotingGamemodes = RandomGamemodes()
	    TriggerClientEvent("StartVoteScreen", -1, VotingGamemodes)
    end)
end)

RegisterNetEvent("Voting:Join")
AddEventHandler("Voting:Join", function()
    if voting then
        TriggerClientEvent("StartVoteScreen", source, VotingGamemodes)
    end
end)