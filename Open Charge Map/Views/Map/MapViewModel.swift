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
    var showErrorMessage: Bool { get set }
    var error: APIError? { get set }
    func toggleShowErrorMessage()
    func fetchLocations(coordinates: CLLocationCoordinate2D, coordinateRegion: MKCoordinateRegion, completion: @escaping ((Result<[Location], APIError>) -> Void))
}

class MapViewModel: ObservableObject, MapVM {
    @Published var showErrorMessage: Bool = false
    @Published var error: APIError? = nil
    private let locationService: LocationService = LocationService.shared
    private let apiService: APIService = APIService.shared
    private let notificationService: NotificationService = NotificationService.shared
}

extension MapViewModel {
    func fetchLocations(coordinates: CLLocationCoordinate2D, coordinateRegion: MKCoordinateRegion, completion: @escaping ((Result<[Location], APIError>) -> Void)) {
        
        self.showErrorMessage = false
        
        debugPrint("Trying to fetch locations...")
        apiService.fetchLocations(
            coordinates: coordinates,
            coordinateRegion: coordinateRegion
        ) { result in
            switch result {
            case .success(let locations):
                completion(.success(locations))
            case .failure(let error):
                self.showErrorMessage.toggle()
                self.error = error
                self.notificationService.requestNotification(message: error.localizedDescription, title: "Open Charge Map", subtitle: "Fehler beim Abrufen der Stationen")
                completion(.failure(.emptyData("No data fetched.")))
            }
        }
    }
}

extension MapViewModel {
    func toggleShowErrorMessage() {
        self.showErrorMessage.toggle()
    }
}
