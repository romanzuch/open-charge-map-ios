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
                DispatchQueue.main.async {
                    self.loadingProxResults = false
                    self.locationProxResult = result
                }
            }
        }
    }
}
