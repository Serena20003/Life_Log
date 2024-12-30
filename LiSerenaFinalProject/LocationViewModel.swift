//
//  LocationViewModel.swift
//  LocationTracker
//
//  Created by Serena Li.
//

import Foundation
import Combine
import CoreLocation


class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation?
    
    // initializing the parameters
    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = kCLDistanceFilterNone
        manager.delegate = self
        // CLLocationManagerDelegate is a protocol, so need to conform to the other protocols too
        requestPermission()
    }
    
    // for every change in location, this function will be called
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        lastKnownLocation = location
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
}
