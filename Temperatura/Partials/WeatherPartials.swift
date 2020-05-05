//
//  Humidity.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/5/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

import SwiftUI

struct WeatherPartials: View {
    var dataType: String? = ""
    var humidity: String? = ""
    var windSpeed: String? = ""
    var temp_min: String? = ""
    var temp_max: String? = ""
    
    var body: some View {
        HStack(spacing: 20.0) {
            if dataType == "humidity" {
                Image(systemName: "thermometer")
                    .font(.system(.largeTitle))
                    .foregroundColor(Color(#colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)))
            }
            
            if dataType == "windSpeed" {
                Image(systemName: "wind")
                    .font(.system(.largeTitle))
                    .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
            }

            if dataType == "min_temp" {
                Image(systemName: "arrow.down")
                    .font(.system(.largeTitle))
                    .foregroundColor(Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
            }

            if dataType == "max_temp" {
                Image(systemName: "arrow.up")
                    .font(.system(.largeTitle))
                    .foregroundColor(Color(#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)))
            }
            
            VStack(spacing: 10) {
                if dataType == "humidity" {
                    Text("Humidity")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("\((humidity != "" ? humidity : "-") ?? "")")
                            .font(.callout).bold()
                        
                        Text("\(humidity != "" ? "%" : "")")
                            .font(.footnote).foregroundColor(Color.secondary)
                    }
                }
                
                if dataType == "windSpeed" {
                    Text("Wind Speed")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("\((windSpeed != "" ? windSpeed : "-") ?? "")")
                            .font(.callout).bold()
                        
                        Text("\(windSpeed != "" ? "km/hr" : "")")
                            .font(.footnote).foregroundColor(Color.secondary)
                    }
                }
                
                if dataType == "min_temp" {
                    Text("Min Temp")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("\((temp_min != "" ? temp_min : "-") ?? "")")
                            .font(.callout).bold()
                        
                        Text("\(temp_min != "" ? "°C" : "")")
                            .font(.footnote).foregroundColor(Color.secondary)
                    }
                }
                
                if dataType == "max_temp" {
                    Text("Max Temp")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Text("\((temp_max != "" ? temp_max : "-") ?? "")")
                            .font(.callout).bold()
                        
                        Text("\(temp_max != "" ? "°C" : "")")
                            .font(.footnote).foregroundColor(Color.secondary)
                    }
                }
            }
        }
        .frame(width: screen.width * 0.35)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12.0))
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 3)
    }
}

struct WeatherPartials_Previews: PreviewProvider {
    static var previews: some View {
        WeatherPartials()
    }
}