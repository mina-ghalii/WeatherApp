//
//  SearchStratigy.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation
protocol SearchStratigyProtocol {
    func search(string: String) async -> [Place]
}
class SearchStratigy {
    func search(string: String) async -> [Place] {
        var stratigy: SearchStratigyProtocol?
        if string.contains(",") {
            stratigy = CoordinatesSearchStratigy()
        } else if Int(string) != nil {
            stratigy = ZipCodeStratigy()
        } else {
            stratigy = CityNameStratigy()
        }
        let places = await stratigy?.search(string: string)
        return places ?? []
    }
}
