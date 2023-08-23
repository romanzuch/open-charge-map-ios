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
                    mapService.addLocationAnnotations(for: locationAnnotations, to: uiView)
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
        private let mapService: MapService = MapService.shared
        private let locationService: LocationService = LocationService.shared
        private let apiService: APIService = APIService.shared
        @StateObject var viewModel: MapViewModel
        private var loadedRegions: [MKCoordinateRegion] = [MKCoordinateRegion]()
        
        init(_ parent: MapView, with viewModel: StateObject<MapViewModel>) {
            self.parent = parent
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
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // check if annotation is selected
            // if annotation is selected, the user interaction is disabled
            if mapView.selectedAnnotations.isEmpty {
                // check whether the new region center is outside the last one
                if !loadedRegions.contains(where: { region in
                    region.contains(mapView.region)
                }) {
                    apiService.fetchLocations(coordinates: mapView.centerCoordinate, coordinateRegion: mapView.region) { result in
                        switch result {
                        case .success(let locations):
                            let locationAnnotations = self.mapService.getLocationAnnotations(for: locations)
                            self.mapService.addLocationAnnotations(for: locationAnnotations, to: mapView)
                            self.loadedRegions.append(mapView.region)
                        case .failure(let err):
                            debugPrint("🔴 >>> Error occurred: \(err)")
                        }
                    }
                } else {
                    debugPrint("Region already loaded....")
                }
            }
            // check whether the new locations are already in the map's annotations
        }
        
        func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
            // do something
        }
        
        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
            // do something
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
            // do something
        }
        
        func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
            self.lastRegion = mapView.region
            mapService.toggleUserInteraction(for: mapView)
            let region: MKCoordinateRegion = MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            if let userLocation = locationService.getCoordinates() {
                debugPrint("Requesting route to location...")
                mapService.getDirections(from: userLocation, to: annotation.coordinate) { result in
                    switch result {
                    case .success(let route):
                        self.mapService.drawDirections(for: route, on: mapView)
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                    }
                }
            }
            mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, didDeselect annotation: MKAnnotation) {
            if let region = self.lastRegion {
                mapView.setRegion(region, animated: true)
            }
            mapService.removeDirections(on: mapView)
            mapService.toggleUserInteraction(for: mapView)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LocationAnnotation else { return nil }
            return LocationAnnotationView(annotation: annotation, reuseIdentifier: LocationAnnotationView.reuseId)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            switch overlay {
            case let overlay as MKPolyline:
                return createPolylineRenderer(for: overlay)
            default:
                return MKOverlayRenderer(overlay: overlay)
                
            }
        }
        
        private func createPolylineRenderer(for line: MKPolyline) -> MKPolylineRenderer {
            /**
             Some of the most common customizations for an `MKOverlayRenderer` include customizing drawing settings, such as the
             fill color of an enclosed shape, or the stroke color for the edge of the shape.
             */
            let renderer = MKPolylineRenderer(polyline: line)
            renderer.lineWidth = 2
            renderer.lineDashPattern = [2, 4]
            renderer.strokeColor = .systemGray
            renderer.fillColor = .systemGray
            renderer.alpha = 0.8
            
            return renderer
        }
        
    }

}
