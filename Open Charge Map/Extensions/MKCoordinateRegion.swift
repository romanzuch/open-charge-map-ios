//
//  MKCoordinateRegion.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 20.08.23.
//

import MapKit

extension MKCoordinateRegion {
    func isMoreThan50PercentOutside(of otherRegion: MKCoordinateRegion) -> Bool {
        let latitudeDifference = abs(center.latitude - otherRegion.center.latitude)
        let longitudeDifference = abs(center.longitude - otherRegion.center.longitude)
        
        let maxLatitudeSpan = (span.latitudeDelta + otherRegion.span.latitudeDelta) / 2
        let maxLongitudeSpan = (span.longitudeDelta + otherRegion.span.longitudeDelta) / 2
        
        return latitudeDifference > maxLatitudeSpan * 0.5 || longitudeDifference > maxLongitudeSpan * 0.5
    }
}
