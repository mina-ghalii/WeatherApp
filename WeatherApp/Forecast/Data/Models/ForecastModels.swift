//
//  ForecastModels.swift
//  WeatherApp
//
//  Created by Mina Atef on 08/03/2023.
//

import Foundation
class ForecastModel: Codable {
    let list: [ForecastItem]?
}
class ForecastItem: Codable, Identifiable {
    let longDate: Double?
    let main: WeatherMain?
    let weather: [Weather]?
    let dateTxt: String?
    enum CodingKeys: String, CodingKey {
        case longDate = "dt"
        case main
        case weather 
        case dateTxt = "dt_txt"
    }
}
