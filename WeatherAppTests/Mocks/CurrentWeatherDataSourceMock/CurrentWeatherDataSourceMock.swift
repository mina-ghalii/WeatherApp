//
//  CurrentWeatherDataSourceMock.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import Foundation
@testable import WeatherApp
class CurrentWeatherDataSourceMock: CurrentWeatherDataSourceProtocol {
    var successFlag = true
    func getCurrentWeather(long: String, lat: String, units: Int) async -> Result<WeatherModel, Error> {
        if successFlag {
            let mockResult = Mockable().getResourcesMock(fileName: "WeatherFaceData",model: WeatherModel.self)
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
