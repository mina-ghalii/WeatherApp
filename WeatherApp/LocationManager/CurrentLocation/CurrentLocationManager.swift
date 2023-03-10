//
//  CurrentLocationManager.swift
//  WeatherApp
//
//  Created by Mina Atef on 09/03/2023.
//

import Foundation
import CoreLocation
protocol CurrentLocationProtocol: AnyObject {
    @MainActor func currentLocation(coordinates: CLLocationCoordinate2D)
}
class CurrentLocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    weak var locationDelegate: CurrentLocationProtocol?
    override init() {
        super.init()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @MainActor
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        locationDelegate?.currentLocation(coordinates: locationValue)
        print("locations = \(locationValue.latitude) \(locationValue.longitude)")
    }

}
