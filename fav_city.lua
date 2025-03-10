local sqlite3 = require('lsqlite3')

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