//
//  ForecastDataSourceMock.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import Foundation
@testable import WeatherApp
class ForecastDataSourceMock: ForcastDataSourceProtocol {
    var successFlag = true
    func getForecast(lon: String, lat: String, units: Int) async -> Result<ForecastModel, Error> {
        if successFlag {
            let mockResult = Mockable().getResourcesMock(fileName: "ForecastFakeData", model: ForecastModel.self)
            switch mockResult {
            case .success(let forecastModel):
                return .success(forecastModel)
            case .failure(let error):
                return .failure(error)
            }
        } else {
            return .failure(CustomError.faildtoPasrse)
        }
    }
    
}
