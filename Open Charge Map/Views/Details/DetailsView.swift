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
                    // MARK: - Basic location information
                    // this includes, number of plugs, type of plugs, address, availability, distance and max. charging power
                    basicDetails
                    // MARK: - Location connections
                    // this includes a list of all connections, their connection type, max. charging power, pricing and availability
                    connections
                    // MARK: - Additional location information
                    // this includes important information, service lines, pricing information and many more
                    others
                    // MARK: - Support information
                    support
                }
            }
            .edgesIgnoringSafeArea(.bottom)
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
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 8).fill(Color("offprimary"))
                .boxShadow()
        }
        .padding(8)
    }
    
    var connections: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Anschlüsse")
                .font(.title2)
                .fontWeight(.bold)
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
        .padding(4)
    }
    
    var others: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Weiteres")
                .font(.title2)
                .fontWeight(.bold)
            operatorInfo
            Divider()
            
            Text("Gebühren und Hinweise").fontWeight(.semibold)
                .padding(.top, 8)
            
            HStack {
                Image(ChargePointConnector.type2.icon)
                    .resizable()
                    .padding(.horizontal, 4)
                    .frame(width: 56, height: 48, alignment: .center)
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Text("Type 2")
                        .fontWeight(.bold)
                    Text("Preis je AC kWh: 0,57€ mit Blockiergebühr*")
                        .font(.footnote)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color("offprimary"))
                    .boxShadow()
            }
            
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .renderingMode(.template)
                    .foregroundColor(.white)
                Spacer()
                Text("Diese Ladestation erlaubt nicht das Beenden von Ladevorgängen über die App.")
                    .font(.footnote)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.orange)
                    .boxShadow()
            }
            
            HStack {
                Image(systemName: "info.circle.fill")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                Spacer().frame(width: 24)
                Text("Die angezeigten Preise gelten unabhängig von den Betreiber-Informationen bei der Verwendung der App. Alle Preise inkl. gesetzlicher MwSt.")
                    .font(.footnote)
            }
            .padding()
            
            HStack {
                Image(systemName: "info.circle.fill")
                    .renderingMode(.template)
                    .foregroundColor(.orange)
                Spacer().frame(width: 24)
                VStack(alignment: .leading) {
                    Text("* Bitte unsere Blockiergebühr beachten:")
                    Text("DC: Ab 240 Minuten 0,10€ pro Minute")
                    Text("AC: Ab 240 Minuten 0,10€ pro Minute")
                    Text("Maximal: bis 12,00€")
                }.font(.footnote)
            }
            .padding(.horizontal)
        }
        .padding(8)
    }
    
    var operatorInfo: some View {
        VStack(spacing: 8) {
            Text("Betreiber").fontWeight(.semibold)
            Text(location.properties.locationOperator.title)
        }
    }
    
    var support: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Hilfe & Support")
                .font(.title2)
                .fontWeight(.bold)
            Text("Betreiber: \(location.properties.locationOperator.title)")
                .font(.footnote)
                .padding(.bottom, 12)
            HStack {
                Text("Rufen Sie bei Problemen mit der Ladestation den Betreiber direkt an.")
                    .font(.footnote)
                Spacer()
                Button {
                    viewModel.callServiceLine(for: location) { result in
                        switch result {
                        case .success(let url):
                            UIApplication.shared.open(url)
                        case .failure(let error):
                            debugPrint(error.localizedDescription)
                            debugPrint(location.properties.locationOperator.phonePrimary)
                        }
                    }
                } label: {
                    Image(systemName: "phone")
                }
                .buttonStyle(.plain)
                .foregroundColor(.orange)
                .padding()
                .background {
                    Circle().fill(Color("offprimary"))
                }
            }
            .padding(.bottom, 24)
            HStack {
                Spacer()
                viewModel.getOperatorWebsite(for: location)
                Spacer()
            }
        }
        .padding()
        .background {
            Rectangle()
                .fill(.orange)
        }
        .padding(.top)
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
