//
//  Forecast.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/8/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

import SwiftUI

struct Forecast: View {
    @ObservedObject var temperaturaVm = TemperaturaViewModel()
    @ObservedObject var lm = LocationManager()
    
    var latitude: Double  { return lm.location?.latitude ?? 0 }
    var longitude: Double { return lm.location?.longitude ?? 0 }
    var placemark: String { return("\(lm.placemark?.locality ?? "XXX")") }
    var status: String    { return("\(String(describing: lm.status))") }
    
    /// Reload the weather forecast.
    private func reloadWeather() {
        self.temperaturaVm.searchOnLoad(city: "", lat: self.latitude, long: self.longitude)
    }
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Sunday").font(.headline)
                        Text("City of Balanga")
                            .font(.footnote).foregroundColor(Color.gray)
                        Text("Mosty Cloudy")
                            .font(.caption)
                            .padding(.top, 20)
                    }
                    Spacer()
                    Text("32.9")
                }
                
                VStack(alignment: .leading) {
                    Text("Latitude: \(self.latitude)")
                    Text("Longitude: \(self.longitude)")
                    Text("Placemark: \(self.placemark)")
                    Text("Status: \(self.status)")
                }
            }
            
            .navigationBarTitle("Weather Forecast")
            .navigationBarItems(trailing: Button(action: {
                self.reloadWeather()
            }) {
                Text("Get")
            })
        }
    }
}

struct Forecast_Previews: PreviewProvider {
    static var previews: some View {
        Forecast()
    }
}
