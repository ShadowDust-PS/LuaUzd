local WeatherAPI = require('weather_api')
local WeatherData = require('weather_data')
local FavoriteCities = require('fav_city')


local api = WeatherAPI:new()
print(type(FavoriteCities))
local db = FavoriteCities:new()
local city

while true do
    print('\nPasirinkite veiksma: ')
    print('\n1. Gauti orus pagal vieno ar keliu miestu ZIP kodus')
    print('\n2. Gauti orus pagal viena ar kelis miestus')
    print('\n3. Prideti miesta i megstamus')
    print('\n4. Perziureti megstamus miestus')
    print('\n5. Istrinti miesta is megstamu saraso')
    print('\n6. Gauti orus pagal megstamu miestu sarasa')
    print('\n7. Iseiti')
    
    local choice = io.read()
    if choice == '1' then
        local zipCodes = {}
        print('Iveskite miesto Zip koda (arba ENTER uzbaigti veiksmui): ')
        while true do
           io.write('Zip kodas: ')
            local zip = io.read()
            if zip == '' then
                print("Klaida: reikia ivesti zip koda.")
                break
            end
           io.write('Salies kodas: ')
            local countryCode = io.read()
            if countryCode == '' then
                print("Klaida: reikia ivesti salies koda.")
                break
            end
           

            table.insert(zipCodes, {zip = zip, countryCode = countryCode})
        end

            print('Jusu ivestu zip kodu orai: ')
            for _, location in ipairs(zipCodes) do
                print('\nTikrinmos oro salygos ZIP kodui: ' .. location.zip .. ', ' .. location.countryCode)
                local status, data = pcall(api.getWBZ, api, location.zip, location.countryCode)
                if status then
                    local weather = WeatherData:new(data)
                    weather:disp()
                else
                    print('Klaida gaunant oru duomenis ZIP kodui ' .. location.zip .. ' : ', data)
                end
            end

    elseif choice == '2' then
        local cities = {}
       
        while true do
            print('Iveskite miesto pavadinima (arba ENTER uzbaigti veiksmui): ')
            local city = io.read()
            
            if city == '' then
                break
            end

            table.insert(cities, city)
        end

            print('Jusu ivestu miestu orai: ')
            for i, city in ipairs(cities) do
                local status, data = pcall(api.getWBC, api, city)
                if status then
                    local weather = WeatherData:new(data)
                    weather:disp()
                else
                    print('Klaida gaunant oru duomenis ' .. city .. ' miestui ', data)
                end
            end
    
    elseif choice == '3' then
        print('Iveskite megstamo miesto pavadinima: ')
        local city = io.read()
        --print(city)
        if db:addcity(city) then
            print('Miestas pridetas i megstamu miestu sarasa')
        else
            print('Miestas jau yra megstamu miestu sarase')
        end
    elseif choice == '4' then
        local FavoriteCities = db:getcities()
        if #FavoriteCities == 0 then
            print('Megstamu miestu sarasas tuscias')
        else
            print('Megstami miestai: ')
            for _, city in pairs(FavoriteCities) do
                print('-', city)
            end
        end
    elseif choice == '5' then
        io.write('Iveskite miesto pavadinima: ')
        local city = io.read()
        if db:removecity(city) then
            print('Miestas sekmingai pasalintas is saraso')
        else
            print('Miestas nerastas sarase')
        end

    elseif choice == '6' then
        WeatherAPI:getFW(FavoriteCities)

    elseif choice == '7' then
        print('Programa baigiama.')
        break
    else
        print('Neteisingas pasirinkimas, bandykite dar karta.')
    end
end