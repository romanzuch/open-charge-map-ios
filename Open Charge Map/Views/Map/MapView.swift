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
    private let apiService: APIService = APIService.shared
    private let mapService: MapService = MapService.shared
    private var mapView: MKMapView = MKMapView()
    @StateObject private var viewModel: MapViewModel
    
    init(with viewModel: StateObject<MapViewModel>) {
        self._viewModel = viewModel
        self.registerAnnotationViewClasses()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, with: self._viewModel)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // This method is called when the view updates
        // You can use this method to handle updates to the map view, if needed
        if uiView.annotations.isEmpty {
            // Setting up the map's configuration and annotations
            let coordinates: CLLocationCoordinate2D = locationService.getCoordinates() ?? CLLocationCoordinate2D(latitude: 52.520008, longitude: 13.404954)
            let coordinateSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: coordinates, span: coordinateSpan)
            uiView.region = region

            let config: MKStandardMapConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic)
            config.pointOfInterestFilter = mapService.getPOIFilter()
            config.showsTraffic = true
            uiView.preferredConfiguration = config

            apiService.fetchLocations(coordinates: coordinates, coordinateRegion: region) { result in
                switch result {
                case .success(let locations):
                    let locationAnnotations = mapService.getLocationAnnotations(for: locations)
                    uiView.addAnnotations(locationAnnotations)
                case .failure(let err):
                    debugPrint("🔴 >>> Error occurred: \(err)")
                }
            }
        }
    }
    
    private func registerAnnotationViewClasses() {
        mapView.register(LocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        mapView.register(LocationClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
    
        var parent: MapView
        private var lastRegion: MKCoordinateRegion?
        @StateObject var viewModel: MapViewModel
        
        init(_ parent: MapView, with viewModel: StateObject<MapViewModel>) {
            self.parent = parent
            self.lastRegion = parent.mapView.region
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
            // do something
            // this will be called whenever the map is re-rendered, not just the first time
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            self.lastRegion = mapView.region
            let region: MKCoordinateRegion = MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
            if let region = self.lastRegion {
                mapView.setRegion(region, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LocationAnnotation else { return nil }
            return LocationAnnotationView(annotation: annotation, reuseIdentifier: LocationAnnotationView.reuseId)
        }
        
    }

}
