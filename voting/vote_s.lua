local CurrentGamemode = "vote"
local VotingGamemodes

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
        local highestIndex = 0
        local highestValue = false
        for k, v in ipairs(TotalVotes) do
            if not highestValue or v.votes > highestValue then
                highestIndex = k
                highestValue = v.votes
            end
        end

        local IndexToGamemode = TotalVotes[highestIndex]
        local TargetGamemode
        for i=1, #Gamemodes do
            if Gamemodes[i].id == IndexToGamemode.id then
                TargetGamemode = Gamemodes[i]
                print("TargetGamemode is ".. json.encode(TargetGamemode))
                break
            end
        end
        print("Attempting to start "..TargetGamemode.id..", "..TargetGamemode.title)
        TriggerEvent("Gamemode:Start:"..TargetGamemode.id,TargetGamemode)

        --CurrentGamemode = VotingGamemodes
    end)
end



RegisterCommand("votedebug", function(source)
    Voted = {}
    --CurrentGamemode = "vote"
    StartVoteCounter()
	VotingGamemodes = SelectVotedGamemodes()
	TriggerClientEvent("StartVoteScreen", -1, VotingGamemodes)
end)

AddEventHandler("StartVoting", function()
    Voted = {}
    --CurrentGamemode = "vote"
    StartVoteCounter()
	VotingGamemodes = SelectVotedGamemodes()
	TriggerClientEvent("StartVoteScreen", -1, VotingGamemodes)
end)