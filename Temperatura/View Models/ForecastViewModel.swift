//
//  ForecastViewModel.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/14/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

import Foundation

class ForecastViewModel: ObservableObject {
    private var forecastService: ForecastService!
    @Published var forecastResponse = ForecastResponse.init(city: City(), list: [])
    
    init() {
        self.forecastService = ForecastService()
    }
    
    /// Format the date properly (e.g. Monday, May 11, 2020)
    public func dateFormatter(timeStamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    /// The the current time in 12-hour format with the right timezone (e.g. 5:52 AM)
    public func getTime(timeStamp: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: self.forecastResponse.city.timezone ?? 0)
        return formatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
    /// Get the city name
    var city: String {
        if let city = forecastResponse.city.name {
            return city
        }
        return ""
    }
    
    public func reloadForecast() {
        
    }
    
    /// Search for city
    public func search(cityName: String) {
        /// You need to add the 'addingPercentEncoding' property so you can search for cities
        /// with space between words, otherwise it will only work on single word cities.
        print(cityName)
        if let city = cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
            getForecast(by: city)
        }
    }
    
    /// Get the weather forecast by city name
    public func getForecast(by city: String) {
        self.forecastService.getForecast(city: city) { forecast in
            if let forecast = forecast {
                DispatchQueue.main.async {
                    self.forecastResponse = forecast
                    print(self.forecastResponse)
                }
            }
        }
    }
    
    /// Get the 5 day weather forecast using zip and country code.
    public func getForecastByZip(by zip: String, country_code: String) {
        self.forecastService.getForecastByZipCode(zip: zip, country_code: country_code) { forecast in
            if let forecast = forecast {
                DispatchQueue.main.async {
                    self.forecastResponse = forecast
                    print(self.forecastResponse)
                }
            }
        }
    }
}
