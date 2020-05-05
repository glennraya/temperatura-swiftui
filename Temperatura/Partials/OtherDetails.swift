//
//  OtherDetails.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/5/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

import SwiftUI

/// Other weather details embedded in ScrollView view.
struct OtherDetails: View {
    @ObservedObject var weatherData = TemperaturaViewModel()
    
    var body: some View {
        ZStack {
            Color.init(#colorLiteral(red: 0.9672107618, green: 0.9672107618, blue: 0.9672107618, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack(spacing: 15) {
                        WeatherPartials(dataType: "humidity", humidity: weatherData.humidity)
                        WeatherPartials(dataType: "windSpeed", windSpeed: weatherData.wind_speed)
                    }
                    .frame(width: screen.width)
                    .padding(.top, 30)
                    
                    HStack(spacing: 15) {
                        WeatherPartials(dataType: "min_temp", temp_min: weatherData.temp_min)
                        WeatherPartials(dataType: "max_temp", temp_max: weatherData.temp_max)
                    }
                }
            }
        }
    }
}

struct OtherDetails_Previews: PreviewProvider {
    static var previews: some View {
        OtherDetails()
    }
}
