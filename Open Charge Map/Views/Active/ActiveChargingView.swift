//
//  ActiveChargingView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 31.08.23.
//

import SwiftUI

struct ActiveChargingView: View {
    
    var location: Location
    @StateObject private var viewModel: ActiveChargingViewModel
    
    init(with location: Location) {
        self.location = location
        self._viewModel = StateObject(wrappedValue: ActiveChargingViewModel(location: location))
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
                    InformationPill(icon: "clock", text: "00:25", size: .medium, geo: geo)
                    VStack {
                    InformationPill(icon: "bolt", text: "0,57", size: .small, geo: geo)
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
            }
            .padding()
        }
    }
}

struct ActiveChargingView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChargingView(with: MockService.shared.getLocations()![0])
    }
}
