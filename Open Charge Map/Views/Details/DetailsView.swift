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
            ScrollView {
                VStack(alignment: .leading) {
                    basicDetails
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8).fill(Color("offprimary"))
                                .boxShadow()
                        }
                        .padding(8)
                    connections
                    others
                        .padding()
                }
            }
            .navigationTitle(location.properties.address.street)
        }
    }
    
    var basicDetails: some View {
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
    }
    
    var connections: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anschlüsse")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            HStack {
                Spacer()
                VStack {
                    ForEach(location.properties.connections, id: \.id) { connection in
                        NavigationLink {
                            Text("Laden")
                        } label: {
                            HStack {
                                Image(viewModel.getConnector(for: connection.type).icon)
                                    .resizable()
                                    .padding(.horizontal, 4)
                                    .frame(width: 56, height: 48, alignment: .center)
                                    .foregroundColor(viewModel.getConnectionStatus(for: connection).statusColor)
                                Spacer()
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(viewModel.getConnector(for: connection.type).title)
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    HStack {
                                        Text("max. \(viewModel.getConnectionPower(for: connection)) kW")
                                            .font(.caption)
                                        Text("·")
                                        Text("ab 0,57€/kWh")
                                            .font(.caption)
                                    }
                                }
                                VStack(alignment: .trailing, spacing: 8) {
                                    Text(viewModel.getConnectionStatus(for: connection).title)
                                        .font(.caption)
                                        .foregroundColor(viewModel.getConnectionStatus(for: connection).statusColor)
                                        .fontWeight(viewModel.getConnectionStatus(for: connection) == ChargePointStatus.available ? .bold : .regular)
                                    Image(systemName: "chevron.forward")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
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
                Spacer()
            }
        }
    }
    
    var others: some View {
        VStack(alignment: .leading) {
            Text("Weiteres")
                .font(.title3)
                .fontWeight(.bold)
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                Spacer()
                Text("Diese Ladestation erlaubt nicht das Beenden von Ladevorgängen über die App.")
                    .font(.caption)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.orange)
                    .boxShadow()
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
