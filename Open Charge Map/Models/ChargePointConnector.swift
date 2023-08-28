//
//  ChargePointConnector.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 28.08.23.
//

import Foundation

enum ChargePointConnector {
    case type2
    case ccs
    case chademo
    
    var title: String {
        switch self {
        case .type2:
            return "Type 2"
        case .ccs:
            return "Type 2 CCS"
        case .chademo:
            return "CHAdeMO"
        }
    }
    
    var icon: String {
        switch self {
        case .type2:
            return "ev-plug-type2"
        case .ccs:
            return "ev-plug-ccs2"
        case .chademo:
            return "ev-plug-chademo"
        }
    }
}
