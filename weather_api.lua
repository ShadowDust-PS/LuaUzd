local WeatherData = require "weather_data"
package.path = package.path .. ";C:/msys64/ucrt64/share/lua/5.1/?.lua"
package.cpath = package.cpath .. ";C:/msys64/ucrt64/share/lua/5.1/socket/?.dll;C:/msys64/ucrt64/share/lua/5.1/socket/?.lua"
local socket = require("socket.core")
local http = require('socket.http')
local json = require("dkjson")
local config = require('config')

local WeatherAPI = {}

WeatherAPI.__index = WeatherAPI

function WeatherAPI:new() --patikrinimas ar egzistuoja API raktas
    local self = setmetatable({}, WeatherAPI)
    if not config.apikey or config.apikey == '' then
        error('API Raktas neegzistuoja, Prasome nustatyti API rakta config.lua faile')
    end
    return self
end

function WeatherAPI:getWBC(city)
--[[ Get Weather By City: gautas miesto pavadinimas yra talpinamas į city, ir 
    URL gauna miesto pav, iš config failo api raktą, formatą, kalbą 
    ]]
    local url = string.format(
        "https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=%s&lang=%s",
        city, config.apikey, config.format, config.lang
    )

    local res, status = http.request(url)
    if status ~= 200 then
        error('Nepavyko gauti oru duomenu')
    end

    return json.decode(res)
end

function WeatherAPI:getWBZ(zip, zipCodes)
    --[[ Get Weather By City: gautas miesto pavadinimas yra talpinamas į city, ir 
        URL gauna miesto pav, iš config failo api raktą, formatą, kalbą 
        ]]
        local url = string.format(
            "https://api.openweathermap.org/data/2.5/weather?zip=%s,%s&appid=%s&units=%s&lang=%s",
            zip, zipCodes, config.apikey, config.format, config.lang
        )
    
        local res, status = http.request(url)
        if status ~= 200 then
            error('Klaida gaunant oru duomenis ZIP kodui ' .. zip .. ' ('.. status .. ')')
        end
    
        return json.decode(res)
    end

    function WeatherAPI:getFW(FavoriteCities)
        --getFW  - get favorites weather
        local fav_cities = FavoriteCities:new()
        local cities = fav_cities:getcities()

        if #cities == 0 then
            print('Jusu megstamu miestu sarasas tuscias')  
            return
        end
        print('Megstamu miestu oru prognozes: ')
        
        for _, city in ipairs(cities) do
            print('\nTikrinamos oro salygos miestui: ' .. city)
            local status, data = pcall(self.getWBC, self, city)
            if status then
                local weather = WeatherData:new(data)
                weather:disp()
            else
                print('Klaida gaunant oru duomenis ' .. city .. ' miestui ', data)
            end

        end
    end

return WeatherAPI