# Nexus-Event JSON DataBase Wrapper

## Reference

```lua
local db = exports[GetCurrentResourceName()]

-- opens or creates a database.
db:OpenDB(file, callback)

-- gets a user, it will pass a "data" argument to callback, which is the user object or false when a user is not to be found.
db:GetUser(id, callback)

-- inserts a new user, note the id field has to be unique.
db:InsertUser(user, callback)

-- updates an existing user, does nothing if a user is not found, update is an object-like table whose elements will be upserted in the original user object.
db:UpdateUser(id, update, callback)

```