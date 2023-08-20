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
    @StateObject private var viewModel: MapViewModel = MapViewModel()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, with: self._viewModel)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let coordinates: CLLocationCoordinate2D = locationService.getCoordinates() ?? CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954)
        let coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: coordinateSpan)
        
        mapView.delegate = context.coordinator
        mapView.region = region
        
        mapView.showsScale = true
        mapView.setUserTrackingMode(.follow, animated: true)
        mapView.userTrackingMode = .follow
        
        mapView.showsUserLocation = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // do something
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
    
        var parent: MapView
        @StateObject var viewModel: MapViewModel
        
        init(_ parent: MapView, with viewModel: StateObject<MapViewModel>) {
            self.parent = parent
            self._viewModel = viewModel
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            // do something
        }
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // do something
            debugPrint(userLocation.coordinate)
        }
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            // do something
        }
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            // do something
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            viewModel.fetchLocations() { result in
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
