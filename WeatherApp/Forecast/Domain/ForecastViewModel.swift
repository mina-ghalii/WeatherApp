//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Mina Atef on 08/03/2023.
//

import Foundation
import CoreLocation
@MainActor
class ForecastViewModel: ObservableObject {
    var dataSource: ForcastDataSourceProtocol
    @Published var error = ""
    @Published var forecastList = [ForecastItem]()
    init( dataSource: ForcastDataSourceProtocol = ForcastDataSource()) {
        self.dataSource = dataSource
    }
    
    func getForecast(coordinates: CLLocationCoordinate2D?, unit: Int) async {
        let result = await dataSource.getForecast(lon: "\(coordinates?.longitude ?? 0)", lat: "\(coordinates?.latitude ?? 0)", units: unit)
        switch result {
        case .success(let forecastModel):
            forecastList = forecastModel.list ?? []
        case .failure(let error):
            self.error = error.localizedDescription
            print(error.localizedDescription)
        }
    }
}
