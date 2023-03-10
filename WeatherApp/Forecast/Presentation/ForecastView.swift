//
//  ForecastView.swift
//  WeatherApp
//
//  Created by Mina Atef on 07/03/2023.
//

import SwiftUI
import CoreLocation
struct ForecastView: View {
    @StateObject var viewModel: ForecastViewModel = ForecastViewModel()
//    var coordinates: CLLocationCoordinate2D?
//    var currentWeather: WeatherModel?
//    var unit: Int?
    var weatherViewModel: WeatherViewModel!
    //    let forecastData: ForecastModel?
//    
    var body: some View {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                VStack {
                    WeatherView(viewModel: weatherViewModel)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.forecastList) { item in
                                VStack {
                                    Text(item.dateTxt ?? "")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                        .multilineTextAlignment(.center)
                                    Image(systemName: WeatherHelper.shared.getWeatherIcon(string: item.weather?.first?.main ?? ""))
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .padding(.bottom, 5)
                                    Text("\(Int(item.main?.temp ?? 0) )°")
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                    Text(item.weather?.first?.description ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                }
                                .frame(width: 110)
                                .padding(20)
                                .background(Color.blue)
                                .cornerRadius(10)
                                
                            }
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    
                }
            }.onAppear {
                let coordinates = CLLocationCoordinate2D(latitude: weatherViewModel.currentWeather?.coord?.lat ?? 0, longitude: weatherViewModel.currentWeather?.coord?.lon ?? 0)
                Task {
                    await viewModel.getForecast(coordinates: coordinates, unit: weatherViewModel.weatherMeasureUnit)
                }
                
            }
            
    }
    
    func getDayOfWeek(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    func secondsToHoursMinutesSeconds(_ seconds: Double) -> String {
        sdf(interval: seconds)
        return "\(seconds / 3600)"
        
    }
    func sdf(interval: Double) {
        let interval = interval
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        
        let formattedString = formatter.string(from: TimeInterval(interval))!
        print("Ai 7aga", formattedString)
        
    }
    
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
