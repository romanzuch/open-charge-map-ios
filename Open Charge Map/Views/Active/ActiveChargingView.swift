//
//  ActiveChargingView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 31.08.23.
//

import SwiftUI

struct ActiveChargingView: View {
    
    var location: Location
    var connection: ChargePointConnection
    @StateObject private var viewModel: ActiveChargingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(with location: Location, for connection: ChargePointConnection) {
        self.location = location
        self.connection = connection
        self._viewModel = StateObject(wrappedValue: ActiveChargingViewModel(connection: connection))
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 8) {
                HStack {
                    Text("Aktiver Ladevorgang")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.bottom, 48)
                HStack {
                    InformationPill(icon: "clock", text: viewModel.timerString, size: .medium, geo: geo)
                    VStack {
                        InformationPill(icon: "bolt", text: String(format: "%.2f", viewModel.power/3600), size: .small, geo: geo)
                    InformationPill(icon: "eurosign", text: "0,57€", size: .small, geo: geo)
                    }
                }
                if viewModel.isRoamingLocation() {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                        Spacer()
                        Text("Bei Roaming-Ladevorgängen erhalten wir unter Umständen keine aktuellen Daten vom Anbieter. Aus diesem Grund können wir den genauen Preis erst nach Ablauf des Ladevorgangs ermitteln.")
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.orange)
                            .boxShadow()
                    }
                }
                Spacer()
                Button {
                    viewModel.stopTransaction { result in
                        switch result {
                        case .success(let success):
                            presentationMode.wrappedValue.dismiss()
                        case .failure(let failure):
                            debugPrint(failure)
                        }
                    }
                } label: {
                    Text("Beenden")
                }

            }
            .padding()
        }
    }
}

struct ActiveChargingView_Previews: PreviewProvider {
    static let location: Location = MockService.shared.getLocations()![0]
    static let connection: ChargePointConnection = location.properties.connections[0]
    static var previews: some View {
        ActiveChargingView(with: location, for: connection)
    }
}
