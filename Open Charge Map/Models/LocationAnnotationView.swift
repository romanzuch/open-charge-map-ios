//
//  LocationAnnotationView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 21.08.23.
//

import MapKit
import SwiftUI

class LocationAnnotationView: MKMarkerAnnotationView {
    static let reuseId = "locationAnnotation"
    
    init(annotation: LocationAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "location"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow
        markerTintColor = UIColor.green
        glyphImage = UIImage(systemName: "bolt.car")
    }
}
