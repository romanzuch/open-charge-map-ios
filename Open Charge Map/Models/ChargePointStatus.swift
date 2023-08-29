//
//  ChargePointStatus.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 28.08.23.
//

import Foundation
import SwiftUI

enum ChargePointStatus {
    case available
    case occupied
    case broken
    case unknown
    
    var statusColor: Color {
        switch self {
        case .available:
            return .green
        case .occupied:
            return .gray
        case .broken:
            return .red
        case .unknown:
            return .orange
        }
    }
    
    var title: String {
        switch self {
        case .available:
            return "Verfügbar"
        case .occupied:
            return "Belegt"
        case .broken:
            return "Defekt"
        case .unknown:
            return "Unbekannt"
        }
    }
}
