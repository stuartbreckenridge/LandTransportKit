//
//  LandTransportAPI+BikeParking.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    
    /// Retrieves a list of bike park locations near the specified coordinates within a given radius.
    ///
    /// - Parameters:
    ///   - lat: The latitude coordinate for the center of the search area.
    ///   - long: The longitude coordinate for the center of the search area.
    ///   - radius: The search radius in kilometers (default is 0.5 km).
    /// - Returns: An array of `BikePark` objects found within the specified area.
    /// - Throws: An error if the network request fails or if decoding the response fails.
    /// - Note: The API key must be set for authentication, or the request will fail.
    /// - Availability: Async only.
    func getBikeParks(near lat: Double, long: Double, radius: Double = 0.5) async throws -> [BikePark] {
        var urlComponents = URLComponents(url: LandTransportEndpoints.bikeParking.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "Lat", value: String(lat)),
            URLQueryItem(name: "Long", value: String(long)),
            URLQueryItem(name: "Dist", value: String(radius))
        ]
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(BikeParking.self, from: data)
        return decodedData.value
    }
    
    
    
    
    
}
