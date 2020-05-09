import SwiftUI

let screen = UIScreen.main.bounds

struct Home: View {
    @ObservedObject var temperaturaVM = TemperaturaViewModel()
    @ObservedObject var lm = LocationManager()
    @State var searchCity: Bool = false
    @State var size: CGFloat = 0.0
    
    var placemark: String { return("\(lm.placemark?.locality ?? "")") }
    var latitude: Double  { return lm.location?.latitude ?? 0 }
    var longitude: Double { return lm.location?.longitude ?? 0 }
    
    var date = Date().description(with: Locale.init(identifier: "Asia/Manila"))
    
    /// Get the timezone.
    var timezone = TimeZone.current
    
    var dateUnix = Date(timeIntervalSince1970: 1588991610)
    
    /// Format date
    var dateFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: dateUnix)
    }

    
    /// Initialize the temperaturaVM.
    init() {
        self.temperaturaVM = TemperaturaViewModel()
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                /// Temperature reading.
                GeometryReader { geo in
                    HStack {
                        Spacer()
                        Text("\(self.temperaturaVM.temperature != "" ? self.temperaturaVM.temperature : "30.0")")
                            .font(.system(size: 92)).bold()
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.35), radius: 5, x: 0, y: 5)
                            .scaleEffect(self.size)
                            .onAppear() {
                                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
                                    self.size = 1
                                }
                        }
                        
                    }.offset(x: -16, y: geo.size.height / 2 - 48)
                }
                
                /// City, weather description and magnifying glass button
                ZStack(alignment: .topLeading) {
                    GeometryReader { geo in
                        HStack {
                            VStack(alignment: .leading, spacing: 5.0) {
                                Text(self.temperaturaVM.city_country != "" ? self.temperaturaVM.city_country : "City of Balanga, PH")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.5), radius: 3, x: 0, y: 3)
                                HStack {
                                    AsyncImage(url: URL(string: "http://openweathermap.org/img/wn/02dg\(self.temperaturaVM.weatherIcon)" + "@2x.pn"), placeholder: ActivityIndicator(isAnimating: true, style: <#T##UIActivityIndicatorView.Style#>))
                                    Text(self.temperaturaVM.description != "" ? self.temperaturaVM.description.capitalized : "Sunny")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.35), radius: 3, x: 0, y: 3)
                                }
                                Text("\(self.temperaturaVM.date)")
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                    .shadow(color: Color.black.opacity(0.35), radius: 3, x: 0, y: 3)
                            }
                            Spacer()
                            HStack {
                                Button(action: { self.searchCity = true }) {
                                    Image(systemName: "magnifyingglass")
                                        .font(Font.system(size: 26))
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.35), radius: 1, x: 0, y: 1)
                                        
                                }
                                .animation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0).delay(self.searchCity ? 0.0 : 0.4))
                                
                                Button(action: {
                                    self.temperaturaVM.searchOnLoad(city: self.placemark, lat: self.latitude, long: self.longitude)
                                }) {
                                    Image(systemName: "location.fill")
                                        .font(Font.system(size: 26))
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.35), radius: 1, x: 0, y: 1)
                                }.padding(.leading, 16)
                            
                            }
                            .scaleEffect(self.size)
                            .onAppear() {
                                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
                                    self.size = 1
                                }
                            }
                            .offset(x: self.searchCity ? 80 : -32)
                        }.offset(x: 16, y: (geo.size.height - geo.size.height) - geo.size.height / 2 + 16)
                    }
                }.padding(.top, 16)
                
                ZStack(alignment: .top) {
                    GeometryReader { geo in
                        HStack {
                            TextField("Enter City", text: self.$temperaturaVM.cityName) {
                                self.temperaturaVM.search()
                                self.searchCity = false
                                self.temperaturaVM.cityName = ""
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 20)
                            
                            Button(action: { self.searchCity = false; self.temperaturaVM.cityName = "" }) {
                                Text("Close")
                            }.offset(x: -20)
                        }
                        .frame(width: screen.width - 30)
                        .background(Color.white)
                        .cornerRadius(50)
                        .shadow(color: Color.black.opacity(0.45), radius: 30, x: 0, y: 10)
                        .offset(y: self.searchCity ? (geo.size.height - geo.size.height) - geo.size.height / 2 + 32 : -280)
                        .animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3))
                    }
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: screen.height * 0.70)
            .background(
                Image("sunny")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .onAppear() {
                self.temperaturaVM.searchOnLoad(city: self.placemark, lat: self.latitude, long: self.longitude)
                
            }
            
            /// List view for other weather details
            OtherDetails(weatherData: self.temperaturaVM)
                
        }
    }
}

/// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
