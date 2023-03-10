//
//  SavedPlacesDataSource.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation
protocol SavedPlacesDataSourceProtocol {
    func getSavedPlaces() async -> [PlacesWeatherData]
    func savePlace(place: Place, weather: WeatherModel) async -> Bool
    func deletePlace(cityName: String)
}
class SavedPlacesDataSource: SavedPlacesDataSourceProtocol {
    var placesWeatherLocalStorageManager: PlacesWeatherLocalStorage?
    init(placesWeatherLocalStorageManager: PlacesWeatherLocalStorage? = PlacesWeatherCoreData()) {
        self.placesWeatherLocalStorageManager = placesWeatherLocalStorageManager
    }
    func getSavedPlaces() async -> [PlacesWeatherData] {
        let places = await placesWeatherLocalStorageManager?.getPlacesData()
        return places ?? []
    }
    func savePlace(place: Place, weather: WeatherModel) async -> Bool {
        let isSaved = await placesWeatherLocalStorageManager?.addPlace(place: place, weather: weather)
        return isSaved ?? false
        
    }
    func deletePlace(cityName: String) {
        placesWeatherLocalStorageManager?.removePlaceWith(cityName: cityName)
    }
    private func savingLimit() {
        
    }
    
}
