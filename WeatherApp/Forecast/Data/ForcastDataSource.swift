//
//  ForcastDataSource.swift
//  WeatherApp
//
//  Created by Mina Atef on 08/03/2023.
//

import Foundation
protocol ForcastDataSourceProtocol {
    func getForecast(lon: String, lat: String, units: Int) async -> Result<ForecastModel, Error>
}
class ForcastDataSource: ForcastDataSourceProtocol {
    let network: Network
    init(network: Network = AFNetwork()) {
        self.network = network
    }
    func getForecast(lon: String, lat: String, units: Int) async -> Result<ForecastModel, Error> {
        let url = Constant.baseURL + Constant.forecasePath
        let params = [
            "lon": lon,
            "lat": lat,
            "appid": Constant.apiKey,
            "units": units == 0 ? "imperial" : "metric"
        ]
        let result = await network.request(url: url, type: ForecastModel.self, parameters: params, headers: nil, method: .get, encoding: .queryString)
        return result
    }
    
}
