//
//  ChargePoint.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation

struct Location: Codable, Identifiable {
    let id: UUID = UUID()
    var properties: LocationProperties
    
    enum CodingKeys: CodingKey {
        case properties
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.properties = try container.decode(LocationProperties.self, forKey: .properties)
    }
}

struct LocationProperties: Codable {
    var id: Int
    var status: Status
    var connections: [ChargePointConnection]
    var address: LocationAddress
    var locationOperator: LocationOperator
    
    enum CodingKeys: String, CodingKey {
        case id, status, connections, address
        case locationOperator = "operator"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(Status.self, forKey: .status)
        self.connections = try container.decode([ChargePointConnection].self, forKey: .connections)
        self.address = try container.decode(LocationAddress.self, forKey: .address)
        self.locationOperator = try container.decode(LocationOperator.self, forKey: .locationOperator)
    }
}

struct Status: Codable {
    var operational: Bool
    var selectable: Bool
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.operational = try container.decode(Bool.self, forKey: .operational)
        self.selectable = try container.decode(Bool.self, forKey: .selectable)
    }
}

struct ChargePointConnection: Codable, Identifiable {
    var id: Int
    var type: ChargePointConnectionType
    var status: Status
    var power: Float?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.type = try container.decode(ChargePointConnectionType.self, forKey: .type)
        self.status = try container.decode(Status.self, forKey: .status)
        self.power = try container.decodeIfPresent(Float.self, forKey: .power)
    }
}

struct ChargePointConnectionType: Codable {
    var id: Int
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "titleOfficial"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
}

extension ChargePointConnectionType: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}

struct LocationAddress: Codable {
    var id: Int
    var title: String
    var street: String
    var city: String
    var postcode: String
    var country: String
    var lat: Float
    var lng: Float
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.street = try container.decode(String.self, forKey: .street)
        self.city = try container.decode(String.self, forKey: .city)
        self.postcode = try container.decode(String.self, forKey: .postcode)
        self.country = try container.decode(String.self, forKey: .country)
        self.lat = try container.decode(Float.self, forKey: .lat)
        self.lng = try container.decode(Float.self, forKey: .lng)
    }
}

struct LocationOperator: Codable {
    var id: Int
    var website: String?
    var title: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.website = try container.decodeIfPresent(String.self, forKey: .website)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
