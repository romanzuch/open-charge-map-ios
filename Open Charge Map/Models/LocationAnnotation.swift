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
    var locationName: String?
    var locationDescription: String?
    var locationColor: Color?

    init(for location: Location, locationDescription: String?) {

        self.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(location.properties.address.lat),
            longitude: CLLocationDegrees(location.properties.address.lng)
        )
        self.locationName = location.properties.address.title
        self.locationDescription = locationDescription != nil ? locationDescription: location.properties.locationOperator.title
        self.locationColor = location.properties.status.operational == true ? .green : .red
    }
}
