import SwiftUI

/// This will get the device's screen dimensions.
let screen = UIScreen.main.bounds

struct Home: View {
//    @ObservedObject var temperaturaVM = TemperaturaViewModel()
    /// The TemperaturaViewModel has been moved to the environment object.
    /// To make all the data available to child components of this view.
    @EnvironmentObject var temperaturaVM: TemperaturaViewModel
    
    /// The location manager is the class that fetches the location of the user
    /// This requires 'Privacy' location proerties in the info.plist file.
    @ObservedObject var lm = LocationManager()
    
    /// Show the search city text field or not.
    @State var searchCity: Bool = false
    
    @State var iconScaleInitSize: CGFloat = 0.0
    
    /// The ImageUrl class is responsible for fetching remote images.
    let imageLoader = ImageUrl()
    
    @State var image: UIImage? = nil
    @State var showAlert: Bool = false
    
    /// These are the data returned by the location manager class.
    var placemark: String { return("\(lm.placemark?.locality ?? "")") }
    var latitude: Double  { return lm.location?.latitude ?? 0 }
    var longitude: Double { return lm.location?.longitude ?? 0 }

    
    /// Initialize the temperaturaVM (If not using EnvironmentObject).
//    init() {
//        self.temperaturaVM = TemperaturaViewModel()
//    }
//
    /// Create the view to render the remote image.
    private func makeContent() -> some View {
        if let image = image {
            return AnyView(
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 82, height: 82)
                    .aspectRatio(contentMode: .fit)
            )
        } else {
            return AnyView(Text("😢"))
        }
    }
    
    var body: some View {
        
        VStack {
            ZStack {
                /// Temperature reading.
                GeometryReader { geo in
                    HStack(alignment: .top) {
                        Spacer()
                        self.makeContent()
                        Text("\(self.temperaturaVM.temperature != "" ? self.temperaturaVM.temperature : "30.0")")
                            .font(.system(size: 82)).bold()
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.35), radius: 5, x: 0, y: 5)
                            .scaleEffect(self.iconScaleInitSize)
                            .onAppear() {
                                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
                                    self.iconScaleInitSize = 1
                                }
                        }
                        Text("°C")
                            .font(.system(size: 24)).bold()
                            .foregroundColor(Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.35), radius: 5, x: 0, y: 5)
                            .padding(.top, 20)
                            .padding(.trailing, 16)
                        
                    }
                    .frame(width: screen.width, alignment: .bottomTrailing)
                    .offset(x: 0, y: geo.size.height / 2 - 42)
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
                                    self.showAlert = true
                                }) {
                                    Image(systemName: "location.circle.fill")
                                        .font(Font.system(size: 26))
                                        .foregroundColor(.white)
                                        .shadow(color: Color.black.opacity(0.35), radius: 1, x: 0, y: 1)
                                }.padding(.leading, 16)
                                    .alert(isPresented: self.$showAlert) {
                                        Alert(title: Text("Current Location"), message: Text(self.temperaturaVM.city_country), dismissButton: .default(Text("Got it!")))
                                }
                            
                            }
                            .scaleEffect(self.iconScaleInitSize)
                            .onAppear() {
                                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0)) {
                                    self.iconScaleInitSize = 1
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
                                self.imageLoader.load(url: URL(string: self.temperaturaVM.weatherIcon)!)
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
                Image(self.temperaturaVM.loadBackgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .onAppear() {
                self.temperaturaVM.searchOnLoad(city: self.placemark, lat: self.latitude, long: self.longitude)
                self.imageLoader.load(url: URL(string: self.temperaturaVM.weatherIcon)!)
            }
            .onReceive(imageLoader.objectWillChange, perform: { image in
                self.image = image
            })
            .onDisappear(perform: {
                self.imageLoader.cancel()
            })
            
            /// List view for other weather details
            OtherDetails()
                
        }
    }
}

/// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(TemperaturaViewModel())
    }
}
