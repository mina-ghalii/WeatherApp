//
//  SavedPlacesDataSourceMock.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import Foundation
@testable import WeatherApp
class SavedPlacesDataSourceMock: SavedPlacesDataSourceProtocol {
    var successFlag = true
    var places = [PlacesWeatherData]()
    func getSavedPlaces() async -> [PlacesWeatherData] {
        return places
    }
    
    func savePlace(place: Place, weather: WeatherModel) async -> Bool {
        if successFlag {
            let place = PlacesWeatherData(context: CoreDataManager.persistentContainer.viewContext)
            place.placeName = place.placeName
            place.latitude = weather.coord?.lat ?? 0
            place.longitude = weather.coord?.lon ?? 0
            place.weather = Int16(weather.main?.temp ?? 0)
            places.append(place)
            return true
        } else {
            return false
        }
    }
    
    func deletePlace(cityName: String) {
        
    }
    
}
