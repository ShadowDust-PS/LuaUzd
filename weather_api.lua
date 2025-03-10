local http = require('http')
local json = require('dkjson')
local config = require('config')

local WeatherAPI = {}

WeatherAPI.__index = WeatherAPI

function WeatherAPI:new()
    local self = setmetatable({}, WeatherAPI)
    if not config.apikey or config.apikey == '' then
        error('API Raktas neegzistuoja, Prašome nustatyti API raktą config.lua faile')
    end
    return self
end

function WeatherAPI:getWBC(city) --Get Weather By City
    local url = string.format(
        "https://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=%s&lang=%s",
        city, config.apikey, config.format, config.lang
    )

    local res, status = http.request(url)
    if status ~= 200 then
        error('Nepavyko gauti orų duomenų')
    end

    return json.decode(res)
end

return WeatherAPI