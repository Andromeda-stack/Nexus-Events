local SpawnIDX = {}
SpawnManager = {}
local s = exports["spawnmanager"]

function SpawnManager.addSpawnPoints(spawnpoints)
    for i,v in ipairs(spawnpoints) do
        SpawnIDX[s:addSpawnPoint(v)] = v
    end
end

function SpawnManager.addSpawnPoint(spawnpoint)
        SpawnIDX[s:addSpawnPoint(spawnpoint)] = spawnpoint
end

function SpawnManager.removeAllSpawnPoints()
    for k,v in pairs(SpawnIDX) do
        s:removeSpawnPoint(k)
        SpawnIDX[k] = nil
    end
end

function SpawnManager.removeSpawnPointByCoords(coords)
    for k,v in pairs(SpawnIDX) do
        if v.x == coords.x and v.y == coords.y and v.z == coords.x then
            s:removeSpawnPoint(k)
            SpawnIDX[k] = nil    
        end
    end
end

function SpawnManager.removeSpawnPointByIdx(idx)
    for k,v in pairs(SpawnIDX) do
        if k==idx then
            s:removeSpawnPoint(k)
            SpawnIDX[k] = nil    
        end
    end
end