//
//  LocationManager.swift
//  Tripzi
//
//  Created by Irinka Datoshvili on 26.07.24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Result<CLLocationCoordinate2D, Error>) -> Void)?
    var authorizationChanged: ((CLAuthorizationStatus) -> Void)?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestCurrentLocation(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        locationCompletion = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationCompletion?(.success(location.coordinate))
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCompletion?(.failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorizationChanged?(status)
    }

    static func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager().authorizationStatus
    }
}
