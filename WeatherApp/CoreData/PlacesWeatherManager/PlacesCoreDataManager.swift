//
//  AnalyticsCoreDataManager.swift
//  ValifyPaymobOCR
//
//  Created by Mina Atef on 16/10/2022.
//  Copyright © 2022 Valify. All rights reserved.
//

import Foundation
import CoreData
protocol PlacesWeatherLocalStorage {
    func addPlace(place: Place, weather: WeatherModel) async -> Bool 
    func getPlacesData() async -> [PlacesWeatherData]?
    func removePlaceWith(cityName: String)
}
class PlacesWeatherCoreData: PlacesWeatherLocalStorage {
    
    func addPlace(place: Place, weather: WeatherModel) async -> Bool {
        var placeModel: PlacesWeatherData!
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PlacesWeatherData>(entityName: "PlacesWeatherData")
        fetchRequest.predicate = NSPredicate(format: "placeName = %@", place.name ?? "")
        do {
            let result = try context.fetch(fetchRequest)
            if result.isEmpty {
                placeModel = PlacesWeatherData(context: context)
                placeModel.longitude = place.placemark?.location?.coordinate.longitude ?? 0
                placeModel.latitude = place.placemark?.location?.coordinate.latitude ?? 0
                placeModel.placeName = place.name
            } else {
                placeModel = result.first
                
            }
            placeModel.weather = Int16(weather.main?.temp ?? 0)
            placeModel.condition = weather.weather?.first?.main
            placeModel.weatherMeasureTyoe = "Fr"
            placeModel.updatedAt = Date()
            try context.save()
            return true
        } catch {
            print("Could not get")
            print(error.localizedDescription)
            return false
        }

    }
    
    func getPlacesData() async -> [PlacesWeatherData]? {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<PlacesWeatherData>(entityName: "PlacesWeatherData")
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            print("Could not get")
            return nil
        }
    }
    
    func removePlaceWith(cityName: String) {
        let context = CoreDataManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PlacesWeatherData")
        fetchRequest.predicate = NSPredicate(format: "placeName = %@", cityName )
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
