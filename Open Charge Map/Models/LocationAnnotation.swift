//
//  ChargePointAnnotation.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import MapKit
import SwiftUI

class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var tint: UIColor?
    var properties: LocationProperties?

    init(for location: Location, locationDescription: String?) {

        self.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(location.properties.address.lat),
            longitude: CLLocationDegrees(location.properties.address.lng)
        )
        self.title = location.properties.address.title
        self.subtitle = locationDescription != nil ? locationDescription: location.properties.locationOperator.title
        self.tint = MapService.shared.getTintFromStatus(location.properties.status)
        self.properties = location.properties
    }
}
