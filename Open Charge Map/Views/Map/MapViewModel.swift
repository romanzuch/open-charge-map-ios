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
    var coordinateRegion: MKCoordinateRegion { get set }
    var showErrorMessage: Bool { get set }
    var error: APIError? { get set }
    func toggleShowErrorMessage()
    func fetchLocations(completion: @escaping ((Result<[Location], APIError>) -> Void))
}

class MapViewModel: ObservableObject, MapVM {
    @Published var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
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
    func fetchLocations(completion: @escaping ((Result<[Location], APIError>) -> Void)) {
        
        self.showErrorMessage = false
        
        guard let _ = locationService.getCoordinates() else {
            completion(.failure(APIError.unknown("No coordinates provided")))
            return
        }
        
        debugPrint("Trying to fetch locations...")
        apiService.fetchLocations(for: coordinateRegion) { result in
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
