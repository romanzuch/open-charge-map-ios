//
//  MapError.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 21.08.23.
//

import Foundation

enum MapError: LocalizedError {
    case noRoute(String)
    
    var errorDescription: String? {
        switch self {
        case .noRoute(let message):
            return NSLocalizedString("No routes received: \(message)", comment: "")
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noRoute:
            return NSLocalizedString("Please try again.", comment: "")
        }
    }
}
