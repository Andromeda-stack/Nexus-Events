local SpawnIDX = {}
SpawnManager = {}
local s = exports["spawnmanager"]

function SpawnManager.addSpawnPoints(spawnpoints)
    print("adding spawnpoints...")
    for k,v in pairs(spawnpoints) do
        local newidx = s:addSpawnPoint(v)
        print("added i:"..k.." v:"..json.encode(v))
        SpawnIDX[tostring(newidx)] = v
    end
end

function SpawnManager.addSpawnPoint(spawnpoint)
    local newidx = s:addSpawnPoint(spawnpoint)
    SpawnIDX[tostring(newidx)] = spawnpoint
    --print("added spawnpoint "..newidx)
end

function SpawnManager.removeAllSpawnPoints()
    for k,v in pairs(SpawnIDX) do
        s:removeSpawnPoint(tonumber(k))
        SpawnIDX[k] = nil
    end
    --print("removed all spawnpoints")
end

function SpawnManager.removeSpawnPointByCoords(coords)
    for k,v in pairs(SpawnIDX) do
        --print("v.x: "..v.x.." coords.x: "..coords.x.."v.y: "..v.y.." coords.y: "..coords.y.."v.z: "..v.z.." coords.z: "..coords.z)
        if v.x == coords.x and v.y == coords.y and v.z == coords.z then
            s:removeSpawnPoint(tonumber(k))
            SpawnIDX[k] = nil
            --print("removed idx by coords: "..k)    
        end
    end
    print(json.encode(SpawnIDX))
end

function SpawnManager.removeSpawnPointByIdx(idx)
    for k,v in pairs(SpawnIDX) do
        if k==idx then
            s:removeSpawnPoint(k)
            SpawnIDX[k] = nil
            --print("removed idx "..k)
        end
    end
end

function SpawnManager.forceRespawn()
    s:forceRespawn()
end

function SpawnManager.spawnPlayer(idx,cb)
    s:spawnPlayer(idx,cb)
end

function SpawnManager.setAutoSpawn(toggle)
    s:setAutoSpawn(toggle)
end