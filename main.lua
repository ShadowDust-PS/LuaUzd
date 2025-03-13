local WeatherAPI = require('weather_api')
local WeatherData = require('weather_data')
local FavoriteCities = require('fav_city')


local api = WeatherAPI:new()
print(type(FavoriteCities))
local db = FavoriteCities:new()
local city

while true do
    print('\nPasirinkite veiksma: ')
    print('\n1. Gauti orus pagal miesta')
    print('\n2. Prideti miesta i megstamus')
    print('\n3. perziureti megstamus miestus')
    print('\n4. Iseiti')
    
    local choice = io.read()
    if choice == '1' then
        print('Iveskite miesto pavadinima: ')
        local city = io.read()
        local status, data = pcall(api.getWBC, api, city)
        if status then
            local weather = WeatherData:new(data)
            weather:disp()
        else
            print('Klaida gaunant oru duomenis:', data)
        end

    elseif choice == '2' then
        print('Iveskite megstamo miesto pavadinima: ')
        pcall(db.addcity, db, city)

    elseif choice == '3' then
        print('Megstami miestai: ')
        pcall(db.getcities, db)

    elseif choice == '4' then
        print('Programa baigiama.')
        break
    else
        print('Neteisingas pasirinkimas, bandykite dar karta.')
    end
end