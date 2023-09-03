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
    
    func getConnector(for connection: ChargePointConnectionType) -> ChargePointConnector {
        switch connection.id {
            case 2: // chademo
                return .chademo
            case 25: // type 2
                return .type2
            case 33: // ccs type 2
                return .ccs
            default:
                return .type2
        }
    }
    
    func getConnectionPower(for connection: ChargePointConnection) -> String {
        if let power = connection.power {
            return String(format: "%.2f", power).replacingOccurrences(of: ".", with: ",")
        }
        return "unbekannte Leistung"
    }
    
    func getConnectionStatus(for connection: ChargePointConnection) -> ChargePointStatus {
        switch connection.status.operational {
        case false:
            return .broken
        case true:
            switch connection.status.selectable {
            case true:
                return .available
            case false:
                return .occupied
            }
        }
    }
    
    func getOperatorWebsite(for location: Location) -> Link<Label<Text, Image>>? {
        if let website = location.properties.locationOperator.website {
            return Link(destination: URL(string: website)!) {
                Label {
                    Text(website)
                        .font(.footnote)
                        .foregroundColor(.primary)
                } icon: {
                    Image(systemName: "arrow.up.right")
                }
            }
        }
        return nil
    }
    
    func callServiceLine(for location: Location, handler: @escaping (Result<URL, APIError>) -> Void) {
        if location.properties.locationOperator.phonePrimary != "undefined" {
            let telephone = "tel://"
            let formattedString = telephone + location.properties.locationOperator.phonePrimary.replacingOccurrences(of: "+", with: "00").replacingOccurrences(of: " ", with: "")
            debugPrint(formattedString)
            guard let url = URL(string: formattedString) else {
                handler(.failure(.unknown("Keine Telefonnummer vorhanden")))
                return
            }
            handler(.success(url))
            return
        }
        handler(.failure(.unknown("Ein unbekannter Fehler ist aufgetreten.")))
    }
}
