//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Mina Atef on 10/03/2023.
//

import XCTest
import CoreLocation
@testable import WeatherApp
@MainActor
class WeatherViewModelTests: XCTestCase {
    var weatherViewModel: WeatherViewModel?
    var weatherDataSource: CurrentWeatherDataSourceMock?
    var savedWeatherDataSource: SavedPlacesDataSourceMock?
    var placesDataSource: PlaceMock?
    @MainActor override func setUp() {
        weatherDataSource = CurrentWeatherDataSourceMock()
//        savedWeatherDataSource =
        placesDataSource = PlaceMock()
        weatherViewModel = WeatherViewModel(placesDataSource: placesDataSource, weatherDataSource: weatherDataSource, savedPlacesDataSource: SavedPlacesDataSourceMock())
        
    }
    @MainActor override func tearDown() {
        weatherDataSource = nil
        savedWeatherDataSource = nil
        placesDataSource = nil
        self.weatherViewModel = nil
    }
    
    func test_getWeatherValidData() async {
        await weatherViewModel?.getWeather(coordinates: CLLocationCoordinate2D(latitude: 30.048338, longitude: 31.242514))
        XCTAssertEqual(weatherViewModel?.error, "")
    }
    func test_getWeatherInvalidData() async {
        weatherDataSource?.successFlag = false
        await weatherViewModel?.getWeather(coordinates: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        XCTAssertNotEqual(weatherViewModel?.error, " ")
    }
    func test_savePlaceLocallySuccess() async {
        let weatherResult = await weatherDataSource?.getCurrentWeather(long: "30.048338", lat: "31.242514", units: 0)
        switch weatherResult {
        case .success(let weatherModel):
            let place = Place(id: UUID(), name: "Cairo", placemark: nil)
            let isSaved = await weatherViewModel?.savePlaceLocally(place: place, weatherModel: weatherModel) ?? false
            XCTAssertTrue(isSaved)
        case .failure(_):
            break
        default:
            break
        }
    }
    func test_convertPlacesToWeatherModel() {
        var places = [Place]()
        let place = Place(id: UUID(), name: "Cairo", placemark: nil)
        places.append(place)
        let weatherModels = weatherViewModel?.convertToWeatherModel(places: places)
        XCTAssertEqual(places.count, weatherModels?.count)
    }
    func test_updateWeatherTempUI() async {
        let weatherResult = await weatherDataSource?.getCurrentWeather(long: "30.048338", lat: "31.242514", units: 0)
        switch weatherResult {
        case .success(let weatherModel):
            weatherViewModel?.updateWeatherUI(weatherModel: weatherModel)
        default:
            break
        }
        XCTAssertNotEqual(weatherViewModel?.temperature, 0)
        
    }
    func test_updateWeatherConditionUI() async {
        let weatherResult = await weatherDataSource?.getCurrentWeather(long: "30.048338", lat: "31.242514", units: 0)
        switch weatherResult {
        case .success(let weatherModel):
            weatherViewModel?.updateWeatherUI(weatherModel: weatherModel)
        default:
            break
        }
        XCTAssertNotEqual(weatherViewModel?.weatherCondition, WeatherConditions.none)
    }
    func test_updateWeatherCityNameUI() async {
        let weatherResult = await weatherDataSource?.getCurrentWeather(long: "30.048338", lat: "31.242514", units: 0)
        switch weatherResult {
        case .success(let weatherModel):
            weatherViewModel?.updateWeatherUI(weatherModel: weatherModel)
        default:
            break
        }
        XCTAssertNotEqual(weatherViewModel?.cityName, "")
    }

}
