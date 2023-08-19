//
//  MapView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
    @State private var userTrackingMode: MapUserTrackingMode = MapUserTrackingMode.follow
    @StateObject private var vm: MapViewModel = MapViewModel()
    private let mapService: MapService = MapService.shared
    
    var body: some View {
        Map(
            coordinateRegion: $coordinateRegion,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: $userTrackingMode,
            annotationItems: vm.locations,
            annotationContent: { location in
                MapMarker(
                    coordinate: mapService.getCoordinatesFromAddress(address: location.properties.address),
                    tint: mapService.getTintFromStatus(location.properties.status)
                )
            }
        )
        .edgesIgnoringSafeArea(.top)
        .alert(
            isPresented: $vm.showErrorMessage,
            error: vm.error,
            actions: { error in
                Button("OK", role: .cancel) {
                    vm.toggleShowErrorMessage()
                }
                Button("Nochmal") {
                    vm.fetchLocations()
                }
            },
            message: { error in
                Text(error.recoverySuggestion ?? "An unknown error occurred")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        )
        .onAppear {
            if (vm.locations.isEmpty) {
                vm.fetchLocations()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
