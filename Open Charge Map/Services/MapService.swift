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
    func calculateDiagonalKilometers(_ coordinateRegion: MKCoordinateRegion) -> String
    func getCoordinatesFromAddress(address: LocationAddress) -> CLLocationCoordinate2D
    func getTintFromStatus(_ status: Status) -> UIColor
    func getLocationAnnotations(for locations: [Location]) -> [LocationAnnotation]
    func getPOIFilter() -> MKPointOfInterestFilter
    func getDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completion: @escaping ((Result<[MKRoute], MapError>) -> Void))
    func drawDirections(for route: [MKRoute], on map: MKMapView)
    func removeDirections(on map: MKMapView)
}

class MapService: MapServices {
    
    static let shared: MapService = MapService()
    
    func calculateDiagonalKilometers(_ coordinateRegion: MKCoordinateRegion) -> String {
        let latDelta: Double = MKMetersPerMapPointAtLatitude(coordinateRegion.span.latitudeDelta)
        let lngDelta: Double = MKMetersPerMapPointAtLatitude(coordinateRegion.span.longitudeDelta)
        let distance: Double = sqrt(latDelta * latDelta + lngDelta * lngDelta)
        let distanceString: String = String(format: "%.2f", distance).replacingOccurrences(of: ".", with: ",")
        return distanceString
    }
    
    func getCoordinatesFromAddress(address: LocationAddress) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(address.lat), longitude: CLLocationDegrees(address.lng))
    }
    
    func getTintFromStatus(_ status: Status) -> UIColor {
        switch status.operational {
            case true:
                return UIColor(red: 34/255, green: 197/255, blue: 94/255, alpha: 1) // green
            case false: 
                return UIColor(red: 153/255, green: 27/255, blue: 27/255, alpha: 1) // red
        }
    }
    
    func getLocationAnnotations(for locations: [Location]) -> [LocationAnnotation] {
        return locations.map { location in
            let annotation = LocationAnnotation(for: location, locationDescription: nil)
            return annotation
        }
    }
    
    func getPOIFilter() -> MKPointOfInterestFilter {
        return MKPointOfInterestFilter(including: [.bank, .airport, .atm, .bakery, .cafe, .carRental, .evCharger, .hospital, .hotel, .store, .restroom, .restaurant, .parking, .pharmacy, .police, .publicTransport])
    }
    
    func getDirections(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completion: @escaping ((Result<[MKRoute], MapError>) -> Void)) {
        let _start = MKMapItem(placemark: MKPlacemark(coordinate: start))
        let _end = MKMapItem(placemark: MKPlacemark(coordinate: end))
        let request: MKDirections.Request = MKDirections.Request()
        request.source = _start
        request.destination = _end
        request.highwayPreference = .any
        request.tollPreference = .avoid
        request.transportType = .automobile
        
        let directions: MKDirections = MKDirections(request: request)
        directions.calculate { response, error in
            
            if let error = error {
                completion(.failure(.noRoute(error.localizedDescription)))
            }
            
            if let response = response {
                completion(.success(response.routes))
            }
            
        }
    }
    
    func drawDirections(for route: [MKRoute], on map: MKMapView) {
        route.first?.steps.forEach({ step in
            map.addOverlay(step.polyline, level: .aboveRoads)
        })
    }
    
    func removeDirections(on map: MKMapView) {
        map.removeOverlays(map.overlays)
    }
    
    func isOutsideOfSpan(from old: MKCoordinateRegion, to new: MKCoordinateRegion) -> Bool {
        if new.center.latitude > (old.minLatitude + 0.01) || new.center.latitude < (old.maxLatitude - 0.01) {
            debugPrint("vertical")
            return true
        } else if new.center.longitude < (old.minLongitude) || new.center.longitude > (old.maxLongitude) {
            debugPrint("horizontal")
            return true
        } else {
            debugPrint("inside")
            return false
        }
    }
    
    func toggleUserInteraction(for map: MKMapView) {
        map.isZoomEnabled.toggle()
        map.isPitchEnabled.toggle()
        map.isRotateEnabled.toggle()
        map.isScrollEnabled.toggle()
    }
    
    func addLocationAnnotations(for annotations: [LocationAnnotation], to map: MKMapView) {
        for annotation in annotations {
            if !map.annotations.contains(where: { mapAnnotation in
                return mapAnnotation.coordinate.latitude == annotation.coordinate.latitude &&
                mapAnnotation.title == annotation.title
            }) {
                map.addAnnotation(annotation)
            }
        }
    }
}
