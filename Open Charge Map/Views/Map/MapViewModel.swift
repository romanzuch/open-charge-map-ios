//
//  MapViewModel.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import MapKit
import _MapKit_SwiftUI

protocol MapVM {
    var locations: [Location] { get set }
    var coordinateRegion: MKCoordinateRegion { get set }
    var userTrackingMode: MapUserTrackingMode { get set }
    func changeUserTrackingMode(to mode: MapUserTrackingMode)
    var showErrorMessage: Bool { get set }
    var error: APIError? { get set }
    func toggleShowErrorMessage()
    func fetchLocations()
}

class MapViewModel: ObservableObject, MapVM {
    @Published var locations: [Location] = []
    @Published var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
    @Published var userTrackingMode: MapUserTrackingMode = .follow
    @Published var showErrorMessage: Bool = false
    @Published var error: APIError? = nil
    private let locationService: LocationService = LocationService.shared
    private let apiService: APIService = APIService.shared
    private let notificationService: NotificationService = NotificationService.shared
    
    init() {
        guard let coordinates = locationService.getCoordinates() else { return }
        let mapSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        self.coordinateRegion = MKCoordinateRegion(center: coordinates, span: mapSpan)
    }
}

extension MapViewModel {
    func fetchLocations() {
        self.showErrorMessage = false
        guard let coordinates = locationService.getCoordinates() else {
            return
        }
        debugPrint("Trying to fetch locations...")
        apiService.fetchLocations(
            coordinates: coordinates,
            coordinateRegion: coordinateRegion
        ) { result in
            switch result {
            case .success(let locations):
                DispatchQueue.main.async {
                    self.locations = locations
                }
            case .failure(let error):
                self.showErrorMessage.toggle()
                self.error = error
                self.notificationService.requestNotification(message: error.localizedDescription, title: "Open Charge Map", subtitle: "Fehler beim Abrufen der Stationen")
            }
        }
    }
}

extension MapViewModel {
    func toggleShowErrorMessage() {
        self.showErrorMessage.toggle()
    }
    
    func changeUserTrackingMode(to mode: MapUserTrackingMode) {
        self.userTrackingMode = mode
    }
}
