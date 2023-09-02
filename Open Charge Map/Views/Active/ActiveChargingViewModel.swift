//
//  ActiveChargingViewModel.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 02.09.23.
//

import Foundation

class ActiveChargingViewModel: ObservableObject {
    var location: Location
    
    init(location: Location) {
        self.location = location
    }
}

extension ActiveChargingViewModel {
    func isRoamingLocation() -> Bool {
        return true
    }
}
