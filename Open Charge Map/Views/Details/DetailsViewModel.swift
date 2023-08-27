//
//  DetailsViewModel.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 26.08.23.
//

import Foundation
import SwiftUI
import CoreLocation

class DetailsViewModel: ObservableObject {
    private let locationService: LocationService = LocationService.shared
    private let dataService: DataService = DataService.shared
    
    func getAddressText(for location: Location) -> Text {
        return Text("\(location.properties.address.street), \(location.properties.address.postcode) \(location.properties.address.city), \(location.properties.address.country)")
    }
    func getAvailablePlugsText(for location: Location) -> Text {
        let countTotalConnections: Int = location.properties.connections.count
        let countAvailableConnections: Int = DataService.shared.getAvailableConnections(for: location.properties.connections)
        switch countAvailableConnections {
        case 0..<countTotalConnections/2:
            return Text("\(countAvailableConnections)").foregroundColor(.red) +
            Text(" von \(countTotalConnections)") +
            Text(" verfügbar").foregroundColor(.red)
        case countTotalConnections/2...countAvailableConnections:
            return Text("\(countAvailableConnections)").foregroundColor(.green) +
            Text(" von \(countTotalConnections)") +
            Text(" verfügbar").foregroundColor(.green)
        default:
            return Text("\(countAvailableConnections) von \(countTotalConnections) verfügbar")
        }
    }
    func getConnectionTypes(for location: Location) -> Array<String> {
        let connectionTypes: [ChargePointConnectionType] = DataService.shared.getConnectionTypes(for: location.properties.connections)
        return connectionTypes.map { connectionType in
            return connectionType.title
        }
    }
    func getDistance(for location: Location) -> Float? {
        if let userCoordinates = locationService.getCoordinates() {
            let locationLocation: CLLocation = CLLocation(
                latitude: CLLocationDegrees(location.properties.address.lat),
                longitude: CLLocationDegrees(location.properties.address.lng)
            )
            let userLocation: CLLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
            return (Float(locationLocation.distance(from: userLocation)) / 1000)
        }
        return nil
    }
    func getMaxPower(for location: Location) -> Float? {
        return dataService.getMaxPower(for: location.properties.connections)
    }
    
}