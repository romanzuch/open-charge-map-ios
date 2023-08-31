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
        Text(location.properties.address.street)
    }
}

struct ActiveChargingView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveChargingView(with: MockService.shared.getLocations()![0])
    }
}
