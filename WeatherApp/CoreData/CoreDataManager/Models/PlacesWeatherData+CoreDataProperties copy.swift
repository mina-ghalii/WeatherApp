//
//  PlacesWeatherData+CoreDataProperties.swift
//  
//
//  Created by Mina Atef on 10/03/2023.
//
//

import Foundation
import CoreData

extension PlacesWeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlacesWeatherData> {
        return NSFetchRequest<PlacesWeatherData>(entityName: "PlacesWeatherData")
    }

    @NSManaged public var condition: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var placeName: String?
    @NSManaged public var weather: Int16
    @NSManaged public var weatherMeasureTyoe: String?
    @NSManaged public var updatedAt: Date?

}
