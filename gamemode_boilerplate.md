# Boilerplate for gamemodes on Nexus-Events

## setting up the gamemode:

* check shared.lua and choose a "Coming soon" entry, edit it to match your gamemode and copy its `id` field.
* create a new folder in `./gamemodes`, it will hold all your gamemode's files.

## Gamemode Start:

your gamemode will begin in the `"Gamemode:Init:"..Gamemode.id` event, where Gamemode.id is the id you copied before. This id is what you wil use to register all your events, just like the init event.