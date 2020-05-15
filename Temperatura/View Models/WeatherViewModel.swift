//
//  TemperaturaViewModel.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/2/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

/// ViewModel Class
import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    private var temperatureService: WeatherService!
    @Published var city_name: String = ""
    @Published var weatherResponse = WeatherResponse.init(name: "", dt: 0, timezone: 0, main: Main(), wind: Wind(), weather: [], sys: Sys())
    var weatherDate: Int = 0

    /// Initialize the WeatherService
    init() {
        self.temperatureService = WeatherService()
        weatherDate = self.weatherResponse.dt
    }
    
    /// Format the date properly (e.g. Monday, May 11, 2020)
    private func dateFormatter(timeStamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    /// The the current time in 12-hour format with the right timezone (e.g. 5:52 AM)
    private func getTime(timeStamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: self.weatherResponse.timezone)
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    /// Get the date returned by the API
    var date: String {
        return self.dateFormatter(timeStamp: self.weatherResponse.dt)
    }
    
    /// Get the sunrise date
    var sunrise: String {
        if let sunrise = self.weatherResponse.sys.sunrise {
            return self.getTime(timeStamp: sunrise)
        }
        return ""
    }
    
    /// Get the sunset date
    var sunset: String {
        if let sunset = self.weatherResponse.sys.sunset {
            return self.getTime(timeStamp: sunset)
        }
        return ""
    }
    
    /// Get the temperature
    var temperature: String {
        if let temp = self.weatherResponse.main.temp {
            return String(format: "%.1f", temp)
        } else {
            return ""
        }
    }
    
    /// Get the min temp.
    var temp_min: String {
        if let temp_min = self.weatherResponse.main.temp_min {
            return String(format: "%.1f", temp_min)
        } else {
            return ""
        }
    }
    
    /// Get the max temp
    var temp_max: String {
        if let temp_max = self.weatherResponse.main.temp_max {
            return String(format: "%.1f", temp_max)
        } else {
            return ""
        }
    }
    
    /// Get the humidity
    var humidity: String {
        if let humidity = self.weatherResponse.main.humidity {
            return String(format: "%.1f", humidity)
        } else {
            return ""
        }
    }
    
    /// Get the wind speed.
    var wind_speed: String {
        if let wind_speed = self.weatherResponse.wind.speed {
            return String(format: "%.1f", wind_speed)
        } else {
            return ""
        }
    }
    
    /// Get the country code
    var country_code: String {
        if let country_code = self.weatherResponse.sys.country {
            return country_code
        } else {
            return ""
        }
    }
    
    /// Get the weather condition icon.
    var weatherIcon: String {
        if self.weatherResponse.weather.count != 0 {
            if let weatherIcon: String = self.weatherResponse.weather[0].icon {
                return "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
            }
        }
        return "https://openweathermap.org/img/wn/02d@2x.png"
    }
    
    /// Get the weather description
    var description: String {
        if self.weatherResponse.weather.count != 0 {
            if let description: String = self.weatherResponse.weather[0].description {
                return description
            }
        }
        return ""
        
    }
    
    /// Determine the background image to be loaded based on whether it's night or day time.
    var loadBackgroundImage: String {
        if let sunset = self.weatherResponse.sys.sunset {
            if self.weatherResponse.dt >= sunset {
                return "night"
            } else {
                return "sunny"
            }
        }
        return "sunny"
        
    }
    
    /// Concatenate the city and country code (City of Balanga, PH).
    var city_country: String {
        if self.weatherResponse.name != "" && country_code != "" {
            return self.weatherResponse.name + ", " + self.country_code
        } else {
            return ""
        }
    }
    
    /// City name
    var cityName: String = ""
    var cityNameOnLoad: String = ""
    
    /// Search for city
    public func search() {
        /// You need to add the 'addingPercentEncoding' property so you can search for cities
        /// with space between words, otherwise it will only work on single word cities.
        if let city = self.cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            fetchWeather(by: city, byCoordinates: false, lat: 0.0, long: 0.0)
        }
    }
    
    /// Search for weather in a city upon the app loads.
    public func searchOnLoad(city: String, lat: Double, long: Double) {
        if let city = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            
            /// TODO: Insert the location coordinates here...
            fetchWeather(by: city, byCoordinates: true, lat: lat, long: long)
        }
    }
    
    /// Fetch the weather by city
    private func fetchWeather(by city: String, byCoordinates: Bool, lat: Double, long: Double) {
        /// Trigger the getWeather service from the WeatherService.swift
        self.temperatureService.getWeather(city: city, byCoordinates: byCoordinates, lat: lat, long: long) { weather  in
            
            if let weather = weather {
                DispatchQueue.main.async {
                    self.weatherResponse = weather
                    print(self.weatherResponse)
                }
            }
        }
    }
}