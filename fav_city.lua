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
    local stmt = self.db:prepare('SELECT COUNT(*) AS count FROM favorites WHERE city = ?;')
    if not stmt then
        print('Klaida: nepavyko paruosti SQL uzklausos (1)')      
    end
    stmt:bind_values(city)
    local result = stmt:step()
    local count = stmt:get_value(0)
    stmt:finalize()

    if count > 0 then
        return false
    else
        local stmt = self.db:prepare('INSERT INTO favorites (city) VALUES (?);')
        if not stmt then
            print('Klaida: nepavyko paruosti SQL uzklausos (2)')      
        end
        stmt:bind_values(city)
        local result = stmt:step()
        stmt:finalize()
        --print(result)
        --print(type(result))
        return true
    end

    
end

function FavoriteCities:getcities()
    local cities = {}
    for row in self.db:nrows('SELECT city FROM favorites;') do
        table.insert(cities, row.city)
    end
    return cities
end

function FavoriteCities:removecity(city)
    local stmt = self.db:prepare('DELETE FROM favorites WHERE city = ?;')
    stmt:bind_values(city)
    local result = stmt:step()
    stmt:finalize()
    return result == sqlite3.done
end


return FavoriteCities