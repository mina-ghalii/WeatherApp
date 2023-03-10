//
//  WeatherHelpers.swift
//  WeatherApp
//
//  Created by Mina Atef on 07/03/2023.
//

import SwiftUI
class WeatherHelper {
    static let shared = WeatherHelper()
    func getWeatherIcon(weatherCondition: WeatherConditions) -> String {
        // return system name of weather icon based on weather condition
        switch weatherCondition {
        case .clear:
            return "sun.max.fill"
        case .clouds:
            return "cloud.fill"
        case .rain:
            return "cloud.rain.fill"
        case .none:
            return ""
        case .haze:
            return "cloud.haze.fill"
        }
    }
    
    func getWeatherIcon(string: String) -> String {
        // return system name of weather icon based on weather condition
        switch convertToWeatherCondition(string: string) {
        case .clear:
            return "sun.max.fill"
        case .clouds:
            return "cloud.fill"
        case .rain:
            return "cloud.rain.fill"
        case .none:
            return ""
        case .haze:
            return "cloud.haze.fill"
        }
    }
    
    func getBackgroundColor(weatherCondition: WeatherConditions) -> Color {
        // return background color based on weather condition
        switch weatherCondition {
        case .clear:
            return Color.blue
        case .clouds:
            return Color.gray
        case .rain:
            return Color.green
        case .none:
            return .white
        case .haze:
            return .gray
        }
    }
    
    func convertToWeatherCondition(string: String) -> WeatherConditions {
        switch string {
        case "Clouds":
            return .clouds
        case "Clear":
            return .clear
        case "Rain":
            return .rain
        case "Haze":
            return .haze
        default:
            return .none
        }
    }

}
