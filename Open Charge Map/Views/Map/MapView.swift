//
//  MapView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    private let locationService: LocationService = LocationService.shared
    private var mapView: MKMapView = MKMapView()
    @StateObject private var viewModel: MapViewModel
    
    init(with viewModel: StateObject<MapViewModel>) {
        self._viewModel = viewModel
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, with: self._viewModel)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = context.coordinator
        
        // initially setting the map region
        let coordinates: CLLocationCoordinate2D = locationService.getCoordinates() ?? CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954)
        let coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: coordinateSpan)
        mapView.region = region
        
        // setting the map's configuration
        mapView.showsScale = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true

        // map standard configuration
        let config: MKStandardMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic)
        config.pointOfInterestFilter = MKPointOfInterestFilter(including: [.bank, .airport, .atm, .bakery, .cafe, .carRental, .evCharger, .hospital, .hotel, .store, .restroom, .restaurant, .parking, .pharmacy, .police, .publicTransport])
        config.showsTraffic = true
        mapView.preferredConfiguration = config
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // do something
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
    
        var parent: MapView
        private var lastLocation: MKUserLocation?
        @StateObject var viewModel: MapViewModel
        
        init(_ parent: MapView, with viewModel: StateObject<MapViewModel>) {
            self.parent = parent
            self.lastLocation = parent.mapView.userLocation
            self._viewModel = viewModel
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            // do something
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if let newLocation = userLocation.location?.coordinate {
                let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let newRegion = MKCoordinateRegion(center: newLocation, span: coordinateSpan)
                mapView.setRegion(newRegion, animated: true)
            }
        }
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            // do something
        }
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            // do something
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            viewModel.fetchLocations(coordinates: mapView.userLocation.coordinate, coordinateRegion: mapView.region) { result in
                switch result {
                case .success(let locations):
                    let locationAnnotations: [LocationAnnotation] = locations.map { location in
                        return LocationAnnotation(for: location, locationDescription: nil)
                    }
                    mapView.addAnnotations(locationAnnotations)
                case .failure(let err):
                    debugPrint("🔴 >>> Error occured: \(err)")
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return nil
        }
        
    }

}
