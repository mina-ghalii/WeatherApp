//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation
import CoreLocation
import UIKit
@MainActor class WeatherViewModel: ObservableObject, CurrentLocationProtocol {
    @Published var searchText: String = ""
    @Published var places: [WeatherModel] = []
    @Published var temperature: Int = 0
    @Published var weatherCondition: WeatherConditions = .none
    @Published var cityName: String = ""
    @Published var error: String = ""
    @Published var weatherMeasureUnit: Int = 0
    @Published var currentWeather: WeatherModel?
    var placesDataSource: PlacesProtocol?
    var savedPlacesDataSource: SavedPlacesDataSourceProtocol?
    let searchStratigy = SearchStratigy()
    var locationManager: CurrentLocationManager?
    var weatherDataSource: CurrentWeatherDataSourceProtocol?
    init(currentWeather: WeatherModel? = nil, weatherMeasureUnit: Int? = 0, placesDataSource: PlacesProtocol? = MapKitPlaces(), weatherDataSource: CurrentWeatherDataSourceProtocol? = CurrentWeatherDataSource(), savedPlacesDataSource: SavedPlacesDataSourceProtocol? = SavedPlacesDataSource()) {
        self.placesDataSource = placesDataSource
        self.weatherDataSource = weatherDataSource
        self.savedPlacesDataSource = savedPlacesDataSource
        self.weatherMeasureUnit = weatherMeasureUnit ?? 0
        if let currentWeather = currentWeather {
            updateWeatherUI(weatherModel: currentWeather)
        }
        Task {
            await getSeachedCities()
        }
        
    }
    
    func getCurrentLocation() {
        locationManager  = CurrentLocationManager()
        locationManager?.locationDelegate = self
    }
    
    func convertUnit() {
        if weatherMeasureUnit == 0 {
            temperature = (temperature * 9/5) + 32
        } else {
            temperature = (temperature - 32) * 5/9
        }
    }
    
    func search() {
        Task {
            let places = await searchStratigy.search(string: searchText)
            self.places = convertToWeatherModel(places: places)
        }
    }
    func searchTabbed() {
        Task {
            await getSeachedCities()
            searchText = " "
        }
    }
    
    func convertToWeatherModel(places: [Place]) -> [WeatherModel] {
        var weatherModels = [WeatherModel]()
        for place in places {
            let coordinates = WeatherPlaceCoordiates(lon: place.placemark?.location?.coordinate.longitude ?? 0, lat: place.placemark?.location?.coordinate.latitude ?? 0)
            let weatherModel = WeatherModel(weather: nil, main: nil, name: place.name, coord: coordinates)
            weatherModels.append(weatherModel)
        }
        return weatherModels
    }
    
    func selectCity(weatherModel: WeatherModel) {
        Task {
            searchText = ""
            let coordinates = CLLocationCoordinate2D(latitude: weatherModel.coord?.lat ?? 0, longitude: weatherModel.coord?.lon ?? 0)
            await getWeather(coordinates: coordinates)
        }
    }
    
    func updateWeatherUI(weatherModel: WeatherModel) {
        currentWeather = weatherModel
        temperature = Int(weatherModel.main?.temp ?? 0)
        weatherCondition = WeatherHelper.shared.convertToWeatherCondition(string: weatherModel.weather?.first?.main ?? "")
        cityName = weatherModel.name ?? ""
    }

    func getSeachedCities() async {
        Task {
            var places = await savedPlacesDataSource?.getSavedPlaces()
            if places?.isEmpty ?? true {
                error = "No Previous Weather To Show, Please Search For Weather First"
                return
            }
            places = places?.sorted { ($0.updatedAt ?? Date()) > ($1.updatedAt ?? Date()) }
            let weatherModels = convertToWeatherModel(places: places ?? [])
            self.places = weatherModels
            if let weatherModel = weatherModels.first {
                updateWeatherUI(weatherModel: weatherModel)
            }
        }
    }

    func convertToWeatherModel(places: [PlacesWeatherData]) -> [WeatherModel] {
        var weatherModels = [WeatherModel]()
         for place in places {
            let weather = Weather(id: nil, main: place.condition, description: nil)
            var weatherArr = [Weather]()
            weatherArr.append(weather)
            let weatherMain = WeatherMain(temp: Double(place.weather), feelsLike: nil, tempMin: nil, tempMax: nil)
            let coordinates = WeatherPlaceCoordiates(lon: place.longitude, lat: place.latitude)
            let weatherModel = WeatherModel(weather: weatherArr, main: weatherMain, name: place.placeName, coord: coordinates)
            weatherModels.append(weatherModel)
        }
        return weatherModels
    }
    
    func getWeather(coordinates: CLLocationCoordinate2D) async {
        error = ""
        Task {
            let weatherResult = await weatherDataSource?.getCurrentWeather(long: "\(coordinates.longitude)", lat: "\(coordinates.latitude)", units: weatherMeasureUnit)
            let place = await placesDataSource?.getAddressFromLatLon(pdblLatitude: "\(coordinates.latitude)", withLongitude: "\(coordinates.longitude)")
            
            switch weatherResult {
            case .success(let weatherData):
                updateWeatherUI(weatherModel: weatherData)
                if let place = place {
                    let _ = await savePlaceLocally(place: place, weatherModel: weatherData)
                }
            case .failure(let error):
                self.error = error.localizedDescription
                print(error.localizedDescription)
            default:
                break
            }
        }
    }
    
    func savePlaceLocally(place: Place, weatherModel: WeatherModel) async -> Bool {
            var places = await savedPlacesDataSource?.getSavedPlaces()
            places = places?.sorted { ($0.updatedAt ?? Date()) > ($1.updatedAt ?? Date()) }
            if places?.count == 5 {
                savedPlacesDataSource?.deletePlace(cityName: places?.last?.placeName ?? "")
            }
            let isSaved = await savedPlacesDataSource?.savePlace(place: place, weather: weatherModel)
            return isSaved ?? false
    }
    
    func currentLocation(coordinates: CLLocationCoordinate2D) {
        Task {
            await getWeather(coordinates: coordinates)
        }
        
    }
}
