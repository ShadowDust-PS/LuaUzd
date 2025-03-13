local WeatherAPI = require('weather_api')
local WeatherData = require('weather_data')
local FavoriteCities = require('fav_city')

local api = WeatherAPI:new()
local db = FavoriteCities:new()
local city

while true do
    print('\nPasirinkite veiksmą: ')
    print('\n1. Gauti orus pagal miestą')
    print('\n2. Pridėti miestą į mėgstamus')
    print('\n3. peržiūrėti mėgstamus miestus')
    print('\n4. Išeiti')
    
    local choice = io.read()
    if choice == '1' then
        print('Įveskite miesto pavadinimą: ')
        local city = io.read()
        local status, data = pcall(api.getWBC, api, city)
        if status then
            local weather = WeatherData:new(data)
            weather:disp()
        else
            print('Klaida gaunant orų duomenis:', data)
        end

    elseif choice == '2' then
        print('Įveskite mėgstamo miesto pavadinimą: ')
        pcall(db.addcity, db, city)

    elseif choice == '3' then
        print('Mėgstami miestai: ')
        pcall(db.getcities, db)

    elseif choice == '4' then
        print('Programa baigiama.')
        break
    else
        print('Neteisingas pasirinkimas, bandykite dar kartą.')
    end
end