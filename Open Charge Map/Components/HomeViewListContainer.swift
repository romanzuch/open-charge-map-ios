//
//  HomeViewListContainer.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 25.08.23.
//

import SwiftUI
import MapKit

struct HomeViewListContainer: View {
    
    @Binding var result: Result<[Location], APIError>
    @Binding var isLoading: Bool
    private let dataService: DataService = DataService.shared
    private let mapService: MapService = MapService.shared
    @EnvironmentObject private var router: RouterService
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    
    init(with result: Binding<Result<[Location], APIError>>, isLoading: Binding<Bool>) {
        self._result = result
        self._isLoading = isLoading
    }
    
    var body: some View {
        switch isLoading {
        case true:
            Text("Lädt...")
        case false:
            switch result {
            case .success(let locations):
                if locations.isEmpty {
                    HStack {
                        Spacer()
                        Text("Es wurden keine Stationen in der Nähe gefunden.").font(.caption2)
                        Spacer()
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("In der Nähe").fontWeight(.bold)
                        ForEach(locations, id: \.properties.id) { location in
                            NavigationLink {
                                DetailsView(for: location)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(location.properties.address.street).fontWeight(.semibold)
                                        HStack(spacing: 4) {
                                            Text("ab \(dataService.getMinPower(for: location.properties.connections)) kW")
                                            Text("·")
                                            Text("\(String(format: "%.2f", (mapService.getDistance(from: location) ?? 0.0)).replacingOccurrences(of: ".", with: ",")) km")
                                            Text("·")
                                            ForEach(dataService.getConnectionTypes(for: location.properties.connections), id: \.hashValue) { connection in
                                                Text(connection.title)
                                            }
                                        }
                                    }
                                    .font(.caption2)
                                    Spacer()
                                    Image(systemName: "chevron.forward")
                                }
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color("offprimary"))
                                        .boxShadow()
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            case .failure(let error):
                VStack(alignment: .leading) {
                    Text("In der Nähe").fontWeight(.bold)
                    HStack {
                        Spacer()
                        ErrorView(error: error)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct HomeViewListContainer_Previews: PreviewProvider {
    static var previews: some View {
        let locations: [Location] = MockService.shared.getLocations() ?? [] // Populate with actual location data if needed
        let error: APIError = APIError.emptyData("")
        let result: Binding<Result<[Location], APIError>> = Binding.constant(.success(locations))
        HomeViewListContainer(with: result, isLoading: .constant(false))
    }
}
