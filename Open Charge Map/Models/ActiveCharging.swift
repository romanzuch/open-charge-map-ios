//
//  ActiveCharging.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 02.09.23.
//

import Foundation

struct PowerValue: Identifiable {
    var id: UUID = UUID()
    let value: Float
    let date: Date
    
    init(for value: Float) {
        self.value = value
        self.date = Date()
    }
}

extension PowerValue: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case value
        case date
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        value = try values.decode(Float.self, forKey: .value)
        date = try values.decode(Date.self, forKey: .date)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(value, forKey: .value)
        try container.encode(date, forKey: .date)
    }
}

struct Transaction: Identifiable {
    var id: UUID = UUID()
    let start: Date
    var powerValues: [PowerValue]
    var isActive: Bool = true
    
    init(time startTime: Date) {
        self.start = startTime
        self.powerValues = []
    }
    
    mutating func stopTransaction() {
        isActive = false
    }
    
}

extension Transaction: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case start
        case powerValues
        case isActive
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        start = try values.decodeIfPresent(Date.self, forKey: .start) ?? Date()
        powerValues = try values.decode([PowerValue].self, forKey: .powerValues)
        isActive = try values.decode(Bool.self, forKey: .isActive)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(start, forKey: .start)
        try container.encode(powerValues, forKey: .powerValues)
        try container.encode(isActive, forKey: .isActive)
    }
}

extension Transaction: RawRepresentable {
    var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }
    init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), let result = try? JSONDecoder().decode(Transaction.self, from: data) else {
            return nil
        }
        self = result
    }
}
