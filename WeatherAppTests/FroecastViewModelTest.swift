//
//  FroecastViewModelTest.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import XCTest
import CoreLocation
@testable import WeatherApp
@MainActor
class FroecastViewModelTest: XCTestCase {
    var forecastViewModel: ForecastViewModel?
    var forecastDataSource: ForecastDataSourceMock?
    @MainActor override func setUp() {
        forecastDataSource = ForecastDataSourceMock()
        forecastViewModel = ForecastViewModel(dataSource: forecastDataSource as! ForcastDataSourceProtocol)
    }
    @MainActor override func tearDown() {
        forecastViewModel = nil
        forecastDataSource = nil
    }
    func test_validData() async {
        await forecastViewModel?.getForecast(coordinates: CLLocationCoordinate2D(latitude: 30.048338, longitude: 31.242514), unit: 0)
        XCTAssertNotEqual(forecastViewModel?.forecastList.count, 0)
    }

}
