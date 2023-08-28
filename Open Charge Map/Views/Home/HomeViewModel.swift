//
//  HomeViewModel.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 23.08.23.
//

import Foundation
import MapKit

class HomeViewModel: ObservableObject {
    private let apiService: APIService = APIService.shared
    private let locationService: LocationService = LocationService.shared
    @Published var loadingProxResults: Bool = false
    @Published var locationProxResult: Result<[Location], APIError> = .failure(.unknown("Unbekannter Fehler"))
    
    func fetchLocations() {
        self.loadingProxResults = true
        if let userLocation = locationService.getCoordinates() {
            let userRegion = MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)) // the span will be a fixed value for now
            apiService.fetchLocations(for: userRegion) { result in
                switch result {
                case .success(let locations):
                    DispatchQueue.main.async {
                        self.loadingProxResults = false
                        self.locationProxResult = .success(locations)
                    }
                case .failure(let error):
                    debugPrint("error: \(error)")
                    DispatchQueue.main.async {
                        self.loadingProxResults = false
                        if let locations = MockService.shared.getLocations() {
                            self.locationProxResult = .success(locations)
                        }
                    }
                }
            }
        }
    }
}
