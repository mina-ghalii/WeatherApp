//
//  MapKitPlaces.swift
//  WeatherApp
//
//  Created by Mina Atef on 07/03/2023.
//

import Foundation
import MapKit
import CoreLocation
protocol PlacesProtocol {
    func getPlaces(cityName: String) async -> [Place]
    func getPlaceFrom(zipCode: String) async -> Place?
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) async -> Place?
}

class MapKitPlaces: PlacesProtocol {
    func getPlaces(cityName: String) async -> [Place] {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = cityName
        searchRequest.pointOfInterestFilter = .excludingAll
        // Set the region to an associated map view's region.
        
        var places = [Place]()
        var citiesPlaces = [String: CLPlacemark]()
        let data = await withCheckedContinuation({ (continuation: CheckedContinuation<[Place], Never>) in
            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, _) in
                guard let response = response else {
                    return
                }
                for item in response.mapItems {
                    if let city = item.placemark.locality {
                        citiesPlaces[city] = item.placemark
                    }
                }
                for (key, value) in citiesPlaces {
                    places.append(Place(name: key, placemark: value))
                }
                continuation.resume(returning: places)
            }
        })
        return data
    }
    
    func getPlaceFrom(zipCode: String) async -> Place? {
        let geocoder = CLGeocoder()
        let dic = [NSTextCheckingKey.zip: zipCode]
        let place = await withCheckedContinuation({ (continuation: CheckedContinuation<Place?, Never>) in
            geocoder.geocodeAddressDictionary(dic) { (placemark, error) in
                if (error) != nil {
                    print(error!)
                }
                if let placemark = placemark?.first {
                    continuation.resume(returning: Place(name: placemark.locality, placemark: placemark))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        })
        return place
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) async -> Place? {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        // 21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        // 72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        
        let place = await withCheckedContinuation({ (continuation: CheckedContinuation<Place?, Never>) in
            ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let placemark = placemarks?.first {
                    continuation.resume(returning: Place(name: placemark.locality, placemark: placemark))
                    print(placemark.locality ?? "")
                }
            })
        })
        return place
        
    }
    
}
struct Place: Identifiable, Hashable {
    var id = UUID()
    var name: String?
    var placemark: CLPlacemark?
}
