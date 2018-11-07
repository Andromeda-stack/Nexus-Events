# Boilerplate for gamemodes on Nexus-Events

## setting up the gamemode:

* check shared.lua and choose a "Coming soon" entry, edit it to match your gamemode and copy its `id` field.
* create a new folder in `./gamemodes`, it will hold all your gamemode's files.
* create gamemode_c.lua and gamemode_s.lua in that folder.

## Gamemode Start:

your gamemode will begin in the `"Gamemode:Init:"..Gamemode.id` event, where Gamemode.id is the id you copied before. This id is what you wil use to register all your events, just like the init event.

### things to put in the init event:

* remove the initial spawn! it is done like this: `SpawnManager.removeSpawnPointByCoords({x=3615.9, y=3789.83, z=29.2})`
* add your gamemode's spawn, there are multiple ways to do this, you can use `SpawnManager.addSpawnPoint({x=0.0,y=0.0,z=0.0,heading=0.0,model=0})` or you can pass a table with all the spawns in the format i just showed you to `SpawnManager.addSpawnPoints`
* you will also need a bool value to check wether the game is ongoing or not, for example, `gunmode` uses `Sessionised`, it should have a default `false` value and change to true once the gamemode starts, in your init event.
* another thing to add in here is the code to get the player out of the transition, you can see an example in `gunmode`.
* a countdown would also be nice to have.
* it is now time to call the core of your gamemode, `StartMain()`, call it at the end of the init event.

## Gamemode Core

the core of your gamemode is the `StartMain` function, it is what does all the work, from the UI to everything else you might think of.

### things to put in StartMain:

* all the UI Threads
* enable PvP loop
* anything else that needs to run after the game has been initialized

## End of the Gamemode

the end of the matches is handled by the `Gamemode:End:id` event.

## things to put in the end event:

* reinitialize all the variables, to make sure they dont have weird values the next match.
* remove all the spawns, using `SpawnManager.removeAllSpawnPoints`
* add the main spawn, by doing `SpawnManager.addSpawnPoint({x=3615.9, y=3789.83, z=29.2, heading=0.0, model=1657546978})`
* respawn the player
* draw the win/lose screen.


# i left out the server side, as that's relatively easy to do.
