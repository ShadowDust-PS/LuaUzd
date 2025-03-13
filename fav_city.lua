--[[
package.cpath = package.cpath .. ";C:\\msys64\\mingw32\\lib\\lua\\5.1\\?.dll"
local status, sqlite3 = pcall(require, "lsqlite3")
if not status then
    error("Failed to load lsqlite3. Ensure lsqlite3.dll is in package.cpath.")
end
]]
--[[
package.cpath = package.cpath .. ";C:/msys64/mingw32/lib/lua/5.1/?.dll"
print(package.cpath)
local sqlite3 = require('lsqlite3')
]]
local path = "C:/msys64/mingw32/lib/lua/5.1/lsqlite3.dll"
local func, err = package.loadlib(path, "luaopen_lsqlite3")

if not func then
    error("Failed to load lsqlite3.dll: " .. tostring(err))
else
    print("DLL loaded successfully!")
    func()  -- Initialize the module
end



local FavoriteCities = {}
FavoriteCities.__index = FavoriteCities

function FavoriteCities:new()
    local self = setmetatable({}, FavoriteCities)
    self.db = sqlite3.open('faveorites.db')
    
    self.db:exec([[
        CREATE TABLE IF NOT EXISTS favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            city TEXT UNIQUE
            );
    ]])

    return self
end

function FavoriteCities:addcity(city)
    local stmt = self.db:prepare('INSERT INTO favorites (city) VALUES (?);')
    stmt:bind_value(city)
    stmt:step()
    stmt:finalize()
    print('Miestas pridėtas')
end

function FavoriteCities:getcities()
    for row in self.db:nrows('SELECT city FROM favorites;') do
        print(row.city)
    end
end