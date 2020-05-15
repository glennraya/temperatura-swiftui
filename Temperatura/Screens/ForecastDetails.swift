//
//  ForecastDetails.swift
//  Temperatura
//
//  Created by Glenn Raya on 5/15/20.
//  Copyright © 2020 Glenn Raya. All rights reserved.
//

import SwiftUI

struct ForecastDetails: View {
    @ObservedObject var forecastVM = ForecastViewModel()
    var city: String = "City of Balanga"
    var main = MainForecast()
    var weather = WeatherForecast()
    var wind = WindForecast()
    var date: String = "Monday, May 11, 2020"
    var time: String = "5:00 pm"
    
    var body: some View {
        VStack {
            VStack(alignment: .trailing) {
                HStack(alignment: .center) {
                    AsyncImage(url: URL(string: "\(Constants.weatherIconUrl)\(self.weather.icon ?? "02d")@2x.png")!, placeholder: ActivityIndicator(isAnimating: .constant(true), style: .large))
                        .frame(width: 82, height: 82)
                        .aspectRatio(contentMode: .fit)
                    Text("\(self.forecastVM.formatDouble(temp: self.main.temp ?? 0.0))")
                        .font(.system(size: 72.0, weight: .bold))
                        .bold()
                    Text("°C")
                        .font(.title)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("\(self.city)")
                    Text("\(self.date)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("\(self.time)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.padding(.bottom, 30)
            
            ScrollView {
                VStack {
                    HStack(spacing: 10) {
                        DetailGrid(icon: "arrow.down", icon_color: Color.green, title: "Min Temp")
                        Divider()
                        DetailGrid(icon: "arrow.up", icon_color: Color.purple, title: "Max Temp")
                    }
                    Divider()
                    HStack(spacing: 10) {
                        DetailGrid(icon: "tornado", icon_color: Color.blue, icon_size: 24.0, title: "Wind Speed")
                        Divider()
                        DetailGrid(icon: "thermometer", icon_color: Color.red, title: "Humidity")
                    }
                    Divider()
                    HStack(spacing: 10) {
                        DetailGrid(icon: "sunrise", icon_color: Color.yellow, icon_size: 28, title: "Sunrise")
                        Divider()
                        DetailGrid(icon: "sunset", icon_color: Color.orange, icon_size: 28, title: "Sunset")
                    }
                    
                }.padding()
            }
            Spacer()
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

struct DetailGrid: View {
    var icon: String = ""
    var icon_color: Color = Color.green
    var icon_size: Float = 32
    var title: String = "Min Temp"
    
    var body: some View {
        HStack(spacing: 20.0) {
            Image(systemName: icon)
                .font(.system(size: CGFloat(icon_size), weight: .light))
                .foregroundColor(icon_color)
            VStack(alignment: .center) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack {
                    Text("26.9")
                        .font(.title)
                        .bold()
                        .lineLimit(1)
                    Text("°C")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }.fixedSize(horizontal: true, vertical: false)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding(10)
    }
}

struct ForecastDetails_Previews: PreviewProvider {
    static var previews: some View {
        ForecastDetails()
    }
}
