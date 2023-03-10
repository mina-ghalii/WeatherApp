//
//  ZipCodeStratigy.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation

class ZipCodeStratigy: SearchStratigyProtocol {
    var placesDataSource: PlacesProtocol?
    init(placesDataSource: PlacesProtocol? = MapKitPlaces()) {
        self.placesDataSource = placesDataSource
    }
    func search(string: String) async -> [Place] {
        var places  = [Place]()
        let place = await placesDataSource?.getPlaceFrom(zipCode: string)
        if let place = place {
            places.append(place)
        }
        return places
    }
}
