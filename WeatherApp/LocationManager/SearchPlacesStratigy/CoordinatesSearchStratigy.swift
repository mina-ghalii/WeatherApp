//
//  CoordinatesSearchStratigy.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation
class CoordinatesSearchStratigy: SearchStratigyProtocol {
    var placesDataSource: PlacesProtocol?
    init(placesDataSource: PlacesProtocol? = MapKitPlaces()) {
        self.placesDataSource = placesDataSource
    }
    func search(string: String) async -> [Place] {
        var places  = [Place]()
        let lonLat = string.components(separatedBy: ",")
        if lonLat.count == 2 {
            let place = await placesDataSource?.getAddressFromLatLon(pdblLatitude: lonLat[0], withLongitude: lonLat[1])
            if let place = place {
                places.append(place)
            }
            return places
        } else {
            return []
        }
        
    }
    
}
