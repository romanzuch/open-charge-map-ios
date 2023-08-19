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
    func calculateDiagonalKilometers(_ coordinateRegion: MKCoordinateRegion) -> Double
    func getCoordinatesFromAddress(address: LocationAddress) -> CLLocationCoordinate2D
    func getTintFromStatus(_ status: Status) -> Color
}

class MapService: MapServices {
    static let shared: MapService = MapService()
    func calculateDiagonalKilometers(_ coordinateRegion: MKCoordinateRegion) -> Double {
        let latDelta: Double = MKMetersPerMapPointAtLatitude(coordinateRegion.span.latitudeDelta)
        let lngDelta: Double = MKMetersPerMapPointAtLatitude(coordinateRegion.span.longitudeDelta)
        return sqrt(latDelta * latDelta + lngDelta * lngDelta)
    }
    func getCoordinatesFromAddress(address: LocationAddress) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(address.lat), longitude: CLLocationDegrees(address.lng))
    }
    func getTintFromStatus(_ status: Status) -> Color {
        switch status.operational {
            case true:
                return Color.green
            case false:
                return Color.red
            default:
                return Color.gray
        }
    }
}
