//
//  APIError.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation

enum APIError: LocalizedError {
    case noConnection(String)
    case unknown(String)
    case emptyData(String)
    case decodingError(String)
    case connectionStatus(Int)
    
    var errorDescription: String? {
        switch self {
        case .noConnection(let message):
            return NSLocalizedString("No connection error: \(message)", comment: "")
        case .unknown(let message):
            return NSLocalizedString("Unknown error: \(message)", comment: "")
        case .emptyData(let message):
            return NSLocalizedString("Empty data error: \(message)", comment: "")
        case .decodingError(let message):
            return NSLocalizedString("Unknown data format: \(message)", comment: "")
        case .connectionStatus(let code):
            switch code {
            case 404:
                return NSLocalizedString("Error \(404): Not found", comment: "")
            case 500:
                return NSLocalizedString("Error \(code): Server error", comment: "")
            default:
                return NSLocalizedString("Error \(code)", comment: "")
            }
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .noConnection:
            return NSLocalizedString("Please check your internet connection and try again.", comment: "")
        case .unknown:
            return NSLocalizedString("An unknown error occurred. Please try again later.", comment: "")
        case .emptyData:
            return NSLocalizedString("The received data was empty. Please contact support.", comment: "")
        case .decodingError:
            return NSLocalizedString("The received data is in an unknown format. Please contact support.", comment: "")
        case .connectionStatus:
            return NSLocalizedString("Please check your internet connection.", comment: "")
        }
    }
}

