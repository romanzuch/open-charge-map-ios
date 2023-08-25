//
//  Data.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation

struct DataType: Codable {
    var locations: [Location]
    
    enum CodingKeys: String, CodingKey {
        case locations = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.locations = try container.decode([Location].self, forKey: .locations)
    }
}
