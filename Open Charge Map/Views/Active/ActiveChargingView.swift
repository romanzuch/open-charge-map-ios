//
//  ActiveChargingView.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 31.08.23.
//

import SwiftUI

struct ActiveChargingView: View {
    
    var location: Location
    
    init(with location: Location) {
        self.location = location
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Text("Aktiver Ladevorgang")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.bottom, 48)
            HStack {
                InformationPill(icon: "eurosign", text: "0,12€", subTitle: "Geschätzter Preis", size: .small)
                InformationPill(icon: "clock", text: "00:20", subTitle: "Dauer", size: .small)
                InformationPill(icon: "eurosign", text: "0,57€", subTitle: "Preis pro kWh", size: .small)
            }
            Spacer()
        }
        .padding()
    }
}

struct ActiveChargingView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChargingView(with: MockService.shared.getLocations()![0])
    }
}
