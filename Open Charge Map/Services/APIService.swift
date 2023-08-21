//
//  APIService.swift
//  Open Charge Map
//
//  Created by Roman Zuchowski on 19.08.23.
//

import Foundation
import Combine
import CoreLocation
import MapKit

protocol APIHandler {
    
    var output: String { get set }
    var distance: String { get set }
    var isoCode: String { get set }
    var count: Int { get set }
    var distanceUnit: String { get set }
    func buildRequest(coordinates: CLLocationCoordinate2D, coordinateRegion: MKCoordinateRegion) -> URLRequest
    func fetchLocations(coordinates: CLLocationCoordinate2D, coordinateRegion: MKCoordinateRegion, completion: @escaping (Result<[Location], APIError>) -> Void)
    
}

class APIService: APIHandler {
    
    var output: String = "json"
    var distance: String = "1"
    var isoCode: String = "DE"
    var count: Int = 10
    var distanceUnit: String = "km"
    
    static let shared: APIService = APIService()
    private let mapService: MapService = MapService.shared
    
    func buildRequest(coordinates: CLLocationCoordinate2D, coordinateRegion: MKCoordinateRegion) -> URLRequest {
        
        var components = URLComponents(string: "http://localhost:9999/locations")!
        
        components.queryItems = [
            URLQueryItem(name: "output", value: self.output),
            URLQueryItem(name: "countrycode", value: self.isoCode),
            URLQueryItem(name: "distance", value: String(mapService.calculateDiagonalKilometers(coordinateRegion))), //String(mapService.calculateDiagonalKilometers(coordinateRegion))
            URLQueryItem(name: "lat", value: String(coordinates.latitude)),
            URLQueryItem(name: "lng", value: String(coordinates.longitude)),
            URLQueryItem(name: "count", value: "\(self.count)"),
            URLQueryItem(name: "distanceUnit", value: self.distanceUnit),
        ]
        
        var request = URLRequest(url: components.url!)
        request.addValue("Open Street Map Express", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    func fetchLocations(coordinates: CLLocationCoordinate2D, coordinateRegion: MKCoordinateRegion, completion: @escaping (Result<[Location], APIError>) -> Void) {
        let request = self.buildRequest(coordinates: coordinates, coordinateRegion: coordinateRegion)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                debugPrint(">>>>> status code: \(httpResponse.statusCode)")
                switch httpResponse.statusCode {
                case 304, 200:
                    debugPrint("Success!")
                    break
                case 404:
                    completion(.failure(APIError.connectionStatus(404)))
                    return
                case 500:
                    completion(.failure(APIError.connectionStatus(500)))
                    return
                default:
                    completion(.failure(APIError.connectionStatus(httpResponse.statusCode)))
                    return
                }
            } else {
                debugPrint(">>>>> No status code found...")
            }
            
            if let error = error {
                completion(.failure(.noConnection(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.emptyData("Keine Daten erhalten")))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Data.self, from: data)
                completion(.success(data.locations))
            } catch let decodingError {
                completion(.failure(.unknown(decodingError.localizedDescription)))
            }
        }.resume()
    }
}
