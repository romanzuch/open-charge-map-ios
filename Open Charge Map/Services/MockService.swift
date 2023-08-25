//
//  MockService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 25.08.23.
//

import Foundation

class MockService {
    static let shared: MockService = MockService()
    func getLocations() -> [Location]? {
        if let url = Bundle.main.url(forResource: "locationTestData", withExtension: "json") {
            do {
                let decoder: JSONDecoder = JSONDecoder()
                let data: Data = try Data(contentsOf: url)
                let jsonData = try decoder.decode(DataType.self, from: data)
                return jsonData.locations
            } catch {
                debugPrint("error occured.")
            }
        }
        return nil
    }
}
