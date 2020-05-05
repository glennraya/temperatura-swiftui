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

class TemperaturaViewModel: ObservableObject {
    private var temperatureService: TemperaturaService!
    @Published var city_name: String = ""
//    @Published var main = Main()
//    @Published var wind = Wind()
//    @Published var weather = [Weather]()
//    @Published var sys = Sys()
    @Published var weatherResponse = WeatherResponse.init(name: "", dt: 0, main: Main(), wind: Wind(), weather: [], sys: Sys())

    /// Initialize the WeatherService
    init() {
        self.temperatureService = TemperaturaService()
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
        if self.weatherResponse.weather.count >= 1 {
            let icon: String = self.weatherResponse.weather[0].icon
            let icon_url: String = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            
            return icon_url
        } else {
            return ""
        }
        
    }
    
    /// Get the weather description
    var description: String {
        if self.weatherResponse.weather.count >= 1 {
            let description: String = self.weatherResponse.weather[0].description
            return description
        } else {
            return ""
        }
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
    
    /// Search for city
    public func search() {
        /// You need to add the 'addingPercentEncoding' property so you can search for cities
        /// with space between words, otherwise it will only work on single word cities.
        if let city = self.cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            fetchWeather(by: city)
        }
    }
    
    /// Fetch the weather by city
    private func fetchWeather(by city: String) {
        /// Trigger the getWeather service from the WeatherService.swift
        self.temperatureService.getWeather(city: city) { weather  in
            
            if let weather = weather {
                DispatchQueue.main.async {
                    self.weatherResponse = weather
                }
            }
        }
    }
}
