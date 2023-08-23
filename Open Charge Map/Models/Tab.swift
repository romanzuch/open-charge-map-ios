//
//  Tab.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 23.08.23.
//

import Foundation

enum Tab {
    case Home
    case Map
    case More
    var title: String {
        switch self {
        case .Home:
            return "Home"
        case .Map:
            return ""
        case .More:
            return "More"
        }
    }
}
