//
//  LocationClusterAnnotationView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 21.08.23.
//

import MapKit

class LocationClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let totalLocations = cluster.memberAnnotations.count
        }
    }
    
}
