//
//  CurrentWeatherDataSource.swift
//  WeatherApp
//
//  Created by Mina Atef on 08/03/2023.
//

import Foundation
protocol CurrentWeatherDataSourceProtocol: AnyObject {
    func getCurrentWeather(long: String, lat: String, units: Int) async -> Result<WeatherModel, Error>
}
class CurrentWeatherDataSource: CurrentWeatherDataSourceProtocol {
    var network: Network
    init(network: Network = AFNetwork()) {
        self.network = network
    }
    func getCurrentWeather(long: String, lat: String, units: Int) async -> Result<WeatherModel, Error> {
        print("Weather called")
        let params = [
            "lon": long,
            "lat": lat,
            "appid": Constant.apiKey,
            "units": units == 0 ? "imperial" : "metric"
        ]
        let url = Constant.baseURL + Constant.weatherPath
        let result = await network.request(url: url, type: WeatherModel.self, parameters: params, headers: nil, method: .get, encoding: .queryString)
        
        return result
    }
    
}
