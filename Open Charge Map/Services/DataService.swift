//
//  DataService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 25.08.23.
//

import Foundation

class DataService {
    static let shared: DataService = DataService()
    func getMinPower(for connections: [ChargePointConnection]) -> Int {
        let validConnections = connections.compactMap { $0.power }
        return Int(validConnections.min() ?? 0.0)
    }
    func getMaxPower(for connections: [ChargePointConnection]) -> Float? {
        let validConnections = connections.compactMap { $0.power }
        return validConnections.max()
    }
    func getConnectionTypes(for connections: [ChargePointConnection]) -> [ChargePointConnectionType] {
        let availableConnectionTypes = Set(connections.map { $0.type })
        return Array(availableConnectionTypes)
    }
    func getAvailableConnections(for connections: [ChargePointConnection]) -> Int {
        let availableConnections = connections.compactMap { $0.status.operational == true }
        let count = availableConnections.reduce(0) { (result, element) in
            return element == true ? result + 1 : result
        }
        return count
    }
}
