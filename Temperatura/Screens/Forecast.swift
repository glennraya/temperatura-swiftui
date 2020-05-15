//
//  Forecast.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/8/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

import SwiftUI

struct Forecast: View {
    @ObservedObject var forecastVM = ForecastViewModel()
    @ObservedObject var weatherVM = WeatherViewModel()
    @ObservedObject var lm = LocationManager()
    
    var latitude: Double  { return lm.location?.latitude ?? 0 }
    var longitude: Double { return lm.location?.longitude ?? 0 }
    var zip: String { return lm.placemark?.name ?? "2100" }
    var country_code: String { return lm.placemark?.isoCountryCode ?? "PH" }
    var status: String    { return("\(String(describing: lm.status))") }
    
    var body: some View {
        NavigationView {
            List(self.forecastVM.forecastResponse.list, id: \.dt) { forecast in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(self.forecastVM.dateFormatter(timeStamp: forecast.dt!))").font(.headline)
                        Text("\(self.forecastVM.getTime(timeStamp: forecast.dt!))")
                            .font(.footnote)
                            .foregroundColor(Color.secondary)
                        Text(self.forecastVM.city)
                            .font(.footnote).foregroundColor(Color.gray)
                        Text("\(forecast.weather?[0].description ?? "")".capitalized)
                            .font(.caption)
                            .padding(.top, 20)
                        Text("\(self.zip)")
                    }
                    Spacer()
                    HStack {
                        AsyncImage(url: URL(string: "\(Constants.weatherIconUrl)\(forecast.weather?[0].icon ?? "02d")@2x.png")!, placeholder: ActivityIndicator(isAnimating: .constant(true), style: .large))
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                            .clipShape(Circle())
                        Text("32.9")
                    }
                }
            }
            .onAppear() {
                /// When the list view appears, get the weather forecast by zip and country code.
                /// The zip and country code are returned by the location manager.
                self.forecastVM.getForecastByZip(by: self.zip, country_code: self.country_code)
            }
            .onDisappear() {
                
            }
            
            .navigationBarTitle("Weather Forecast")
            .navigationBarItems(trailing: Button(action: {
                /// Reload the weather forecast.
                self.forecastVM.getForecastByZip(by: self.zip, country_code: self.country_code)
            }) {
                Image(systemName: "arrow.clockwise")
            })
        }
    }
}

struct Forecast_Previews: PreviewProvider {
    static var previews: some View {
        Forecast()
    }
}
