//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mina Atef on 07/03/2023.
//

import SwiftUI
import MapKit

struct InitialScreen: View {
    @StateObject var weatherViewModel = WeatherViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)
                VStack {
                    WeatherView(viewModel: weatherViewModel, fromDashboard: true)
                    NavigationLink("Weather", destination: WeatherMainView(viewModel: weatherViewModel))
                        .frame(width: UIScreen.main.bounds.width - 40, height: 70, alignment: .center)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
//                        .padding()

                    NavigationLink("Forcast", destination: ForecastView(weatherViewModel: weatherViewModel))
                        .navigationBarTitle(Text("Dashboard"))
                        .frame(width: UIScreen.main.bounds.width - 40, height: 70, alignment: .center)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding()
                }
            }
            
        }
        .accentColor(Color.black)
        
    }
}

struct InitialScreen_Previews: PreviewProvider {
    static var previews: some View {
        InitialScreen()
    }
}
