//
//  LocationService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService() // Singleton instance
    private var locationManager: CLLocationManager
    private var authorizationStatus: CLAuthorizationStatus
    
    func getLocationManager() -> CLLocationManager {
        return self.locationManager
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return self.authorizationStatus
    }
    
    func getCoordinates() -> CLLocationCoordinate2D? {
        return self.locationManager.location?.coordinate
    }
    
    private override init() {
        self.locationManager = CLLocationManager()
        self.authorizationStatus = self.locationManager.authorizationStatus
        super.init()
        
        switch self.authorizationStatus {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            break
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        default:
            break
        }
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
}
