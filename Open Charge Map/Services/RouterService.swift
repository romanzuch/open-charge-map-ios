//
//  RouterService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 23.08.23.
//

import Foundation

class RouterService: ObservableObject {
    @Published var currentTab: Tab = .Home
}

extension RouterService {
    func switchTab(to newTab: Tab) {
        self.currentTab = newTab
    }
}
