//
//  MKCoordinateRegion.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 20.08.23.
//

import MapKit

extension MKCoordinateRegion {
    var maxLongitude: CLLocationDegrees {
        center.longitude + span.longitudeDelta / 2
    }

    var minLongitude: CLLocationDegrees {
        center.longitude - span.longitudeDelta / 2
    }

    var maxLatitude: CLLocationDegrees {
        center.latitude + span.latitudeDelta / 2
    }

    var minLatitude: CLLocationDegrees {
        center.latitude - span.latitudeDelta / 2
    }

    func contains(_ other: MKCoordinateRegion) -> Bool {
        maxLongitude >= other.maxLongitude && minLongitude <= other.minLongitude && maxLatitude >= other.maxLatitude && minLatitude <= other.minLatitude
    }
}
