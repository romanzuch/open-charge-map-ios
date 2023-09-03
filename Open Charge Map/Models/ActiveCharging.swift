//
//  ActiveCharging.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 02.09.23.
//

import Foundation

struct PowerValue: Identifiable {
    let id: UUID = UUID()
    let value: Float
    let date: Date
    
    init(for value: Float) {
        self.value = value
        self.date = Date()
    }
}
