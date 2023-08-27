//
//  DetailsView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 26.08.23.
//

import SwiftUI

struct DetailsView: View {
    
    var location: Location
    @StateObject private var viewModel: DetailsViewModel = DetailsViewModel()
    
    init(for location: Location) {
        self.location = location
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(location.properties.connections.count) Ladesäulen")
                                .font(.caption2)
                            Text("·")
                            ForEach(viewModel.getConnectionTypes(for: location), id: \.self) { connection in
                                Text(connection)
                                    .font(.caption2)
                            }
                        }
                        viewModel.getAddressText(for: location)
                            .fontWeight(.semibold)
                        HStack {
                            Group {
                                viewModel.getAvailablePlugsText(for: location)
                                    .font(.caption)
                                Text("·")
                                Text("\(String(format: "%.2f", viewModel.getDistance(for: location) ?? 0.0)) km")
                                    .font(.caption)
                            }
                            Spacer()
                            Text("max. \(String(format: "%.2f", viewModel.getMaxPower(for: location) ?? 0.0)) kW")
                                .font(.caption)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .frame(width: geo.size.width - 48, height: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 8).fill(.ultraThinMaterial)
                    }
                }
                .frame(width: geo.size.width, height: nil)
                    .navigationTitle(location.properties.address.street)
            }
            }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        if let locations = MockService.shared.getLocations() {
            let location: Location = locations[0]
            DetailsView(for: location)
        }
    }
}
