//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Mina Atef on 08/03/2023.
//

import Foundation
struct WeatherModel: Codable, Identifiable {
    var id = UUID()
    var weather: [Weather]?
    var main: WeatherMain?
    var name: String?
    var coord: WeatherPlaceCoordiates?
    var weatherID: Double?
    enum CodingKeys: String, CodingKey {
        case weather
        case main
        case name
        case coord
        case weatherID = "id"
    }
}
struct WeatherPlaceCoordiates: Codable {
    var lon: Double?
    var lat: Double?
}
struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
}
struct WeatherMain: Codable {
    var temp: Double?
    var feelsLike: Double?
    var tempMin: Double?
    var tempMax: Double?
    enum CodingKeys: String, CodingKey {
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case temp
    }
}
