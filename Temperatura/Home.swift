import SwiftUI

let screen = UIScreen.main.bounds

struct Home: View {
    @ObservedObject var temperaturaVM = TemperaturaViewModel()
    @State var searchCity: Bool = false
    
    /// Initialize the temperaturaVM.
    init() {
        self.temperaturaVM = TemperaturaViewModel()
    }
    
    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .top) {
                    LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))]), startPoint: .bottom, endPoint: .top)
        
                    HStack {
                        TextField("Enter City", text: self.$temperaturaVM.cityName) {
                            /// Call the search function from the TemperaturaViewModel.
                            self.temperaturaVM.search()
                            self.searchCity = false
                        }
                        .keyboardType(.alphabet)
                        .padding(.vertical, 16)
                        .padding(.leading, 16)
                        .padding(.trailing, 42)
                        
                        Button(action: {
                            self.searchCity = false
                            self.temperaturaVM.cityName = ""
                        }) {
                            Image(systemName: "chevron.up.circle.fill")
                                .font(Font.system(size: 24))
                                .font(Font.body.weight(.semibold))
                                
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .compositingGroup()
                    .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 2)
                    .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 10)
                    .offset(x: 0, y: searchCity ? 44 : -100)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0))
                    .padding(.horizontal, 44)
                    
                    if !searchCity {
                        HStack {
                            Spacer()
                            Button(action: {
                                self.searchCity = true
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 32))
                                    .foregroundColor(Color.white)
                            }
                        }
                        .offset(x: -30, y: 60)
                    }
                }
                
                VStack {
                    HStack {
                        if self.temperaturaVM.weatherIcon != "" {
                            AsyncImage(url: URL(string: self.temperaturaVM.weatherIcon)!, placeholder: ActivityIndicator(isAnimating: .constant(true), style: .medium))
                                .frame(width: 50, height: 50)
                                .scaledToFit()
                                .clipShape(Circle())
                        }
                        
                        Text("\(self.temperaturaVM.city_country)")
                            .foregroundColor(.white)
                    }
                    Text("\(self.temperaturaVM.temperature != "" ? self.temperaturaVM.temperature : "-")\(self.temperaturaVM.temperature != "" ? "°C" : "")")
                        .font(.system(size: 72.0)).bold()
                        .foregroundColor(.white)
                    
                    Text(self.temperaturaVM.description.capitalized)
                        .foregroundColor(.white)
                        
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: screen.width, maxHeight: screen.height * 0.50)
            .padding(.bottom, -7)
            
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
