//
//  PlaceMock.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import Foundation
import CoreLocation
@testable import WeatherApp

class PlaceMock: PlacesProtocol {
    func getPlaces(cityName: String) async -> [Place] {
        var places = [Place]()
        let place = Place(id: UUID(), name: "Cairo", placemark: nil)
        places.append(place)
        return places
    }
    
    func getPlaceFrom(zipCode: String) async -> Place? {
        let place = Place(id: UUID(), name: "Cairo", placemark: nil)
        return place
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) async -> Place? {
        let place = Place(id: UUID(), name: "Cairo", placemark: nil)
        return place
    }
    
}
