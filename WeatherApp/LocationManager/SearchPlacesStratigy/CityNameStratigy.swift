//
//  CityNameStratigy.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation

class CityNameStratigy: SearchStratigyProtocol {
    var placesDataSource: PlacesProtocol?
    init(placesDataSource: PlacesProtocol? = MapKitPlaces()) {
        self.placesDataSource = placesDataSource
    }
    func search(string: String) async -> [Place] {
        let places = await placesDataSource?.getPlaces(cityName: string)
        return places ?? []
    }
}
