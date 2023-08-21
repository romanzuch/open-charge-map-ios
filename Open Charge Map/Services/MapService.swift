//
//  MapService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import MapKit
import CoreLocation
import SwiftUI

protocol MapServices {
    func calculateDiagonalKilometers(_ coordinateRegion: MKCoordinateRegion) -> String
    func getCoordinatesFromAddress(address: LocationAddress) -> CLLocationCoordinate2D
    func getTintFromStatus(_ status: Status) -> UIColor
    func getLocationAnnotations(for locations: [Location]) -> [LocationAnnotation]
    func getPOIFilter() -> MKPointOfInterestFilter
}

class MapService: MapServices {
    
    static let shared: MapService = MapService()
    
    func calculateDiagonalKilometers(_ coordinateRegion: MKCoordinateRegion) -> String {
        let latDelta: Double = MKMetersPerMapPointAtLatitude(coordinateRegion.span.latitudeDelta)
        let lngDelta: Double = MKMetersPerMapPointAtLatitude(coordinateRegion.span.longitudeDelta)
        let distance: Double = sqrt(latDelta * latDelta + lngDelta * lngDelta)
        let distanceString: String = String(format: "%.2f", distance).replacingOccurrences(of: ".", with: ",")
        return distanceString
    }
    
    func getCoordinatesFromAddress(address: LocationAddress) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(address.lat), longitude: CLLocationDegrees(address.lng))
    }
    
    func getTintFromStatus(_ status: Status) -> UIColor {
        switch status.operational {
            case true:
                return UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1) // green
            case false: 
                return UIColor(red: 153/255, green: 27/255, blue: 27/255, alpha: 1) // red
        }
    }
    
    func getLocationAnnotations(for locations: [Location]) -> [LocationAnnotation] {
        return locations.map { location in
            let annotation = LocationAnnotation(for: location, locationDescription: nil)
            return annotation
        }
    }
    
    func getPOIFilter() -> MKPointOfInterestFilter {
        return MKPointOfInterestFilter(including: [.bank, .airport, .atm, .bakery, .cafe, .carRental, .evCharger, .hospital, .hotel, .store, .restroom, .restaurant, .parking, .pharmacy, .police, .publicTransport])
    }
}
