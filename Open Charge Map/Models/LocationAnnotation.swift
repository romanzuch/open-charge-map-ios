//
//  ChargePointAnnotation.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import MapKit

class LocationAnnotation: NSObject {
    var coordinate: CLLocationCoordinate2D
    
    init(for location: Location) {
        self.coordinate = CLLocationCoordinate2D(
            latitude: CLLocationDegrees(location.properties.address.lat),
            longitude: CLLocationDegrees(location.properties.address.lng)
        )
        super.init()
    }
}
