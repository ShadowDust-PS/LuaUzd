local WeatherData = {}
WeatherData.__index = WeatherData

function WeatherData:new(data) --gaunami duomenys priskiriami self.(var) kad galima būtu juos kviesti lengviau
    local self = setmetatable({},WeatherData)
    self.city = data.name
    self.temp = data.main.temp
    self.weather = data.weather[1].description
    return self
end

function WeatherData:disp() --išrašoma informacija į ekraną
    print(string.format('Miestas: %s', self.city))
    print(string.format('Temperatura: %.1f°C', self.temp))
    print(string.format('Oru salygos: %s', self.weather))
end

return WeatherData