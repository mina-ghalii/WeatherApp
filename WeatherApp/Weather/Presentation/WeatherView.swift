//
//  WeatherScreen.swift
//  WeatherApp
//
//  Created by Mina Atef on 07/03/2023.
//

import SwiftUI
import CoreLocation
struct WeatherMainView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                WeatherView(viewModel: viewModel)
                Button("Get Weather From My Location") {
                    viewModel.getCurrentLocation()
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 70, alignment: .center)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                NavigationLink("Show Forcast", destination:
                                ForecastView( weatherViewModel: viewModel)
                )
                    .navigationBarTitle(Text("Weather"))
                    .frame(width: UIScreen.main.bounds.width - 40, height: 70, alignment: .center)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        
    }
}
struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    var fromDashboard = false
    var body: some View {
        ZStack {
            Color("BackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                if !fromDashboard {
                    TextField("Search City", text: $viewModel.searchText, onEditingChanged: { foucus in
                        if foucus {
                            viewModel.searchTabbed()
                        } else {
                            viewModel.searchText = ""
                        }
                    })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.search()
                        }
                }
                
                Picker("", selection: $viewModel.weatherMeasureUnit) {
                    Text("Fr").tag(0)
                    Text("C").tag(1)
                }.onChange(of: viewModel.weatherMeasureUnit, perform: { _ in
                    viewModel.convertUnit()
                })
                    .pickerStyle(.segmented)
                
                if viewModel.searchText.isEmpty {
                    if viewModel.error == "" {
                        Spacer()
                        Text("\(viewModel.cityName)")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.black)
                        Text("\(viewModel.temperature)°")
                            .font(.system(size: 80, weight: .bold))
                            .foregroundColor(.black)
                        
                        Image(systemName: WeatherHelper.shared.getWeatherIcon(weatherCondition: viewModel.weatherCondition))
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        
                        Text(viewModel.weatherCondition.rawValue)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.black)
                        
                        Spacer()
                    } else {
                        Spacer()
                        Text(viewModel.error).multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(viewModel.places) { weatherModel in
                                VStack {
                                    Text("\(weatherModel.name ?? "")")
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 70)
                                .padding()
                                .onTapGesture {
                                    viewModel.selectCity(weatherModel: weatherModel)
                                }
                            }
                        }
                    }
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onTapGesture(perform: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
        }
    }
    
}

struct WeatherViewMain_Previews: PreviewProvider {
    static var previews: some View {
        WeatherMainView(viewModel: WeatherViewModel())
    }
}
