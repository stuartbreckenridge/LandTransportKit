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
    ///
    /// - Returns: An array of ``BikePark`` objects found within the specified area.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - Availability: Async only.
    func getBikeParks(near lat: Double, long: Double, radius: Double = 0.5) async throws -> [BikePark] {
        var urlComponents = URLComponents(url: LandTransportEndpoints.bikeParking.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [
            URLQueryItem(name: "Lat", value: String(lat)),
            URLQueryItem(name: "Long", value: String(long)),
            URLQueryItem(name: "Dist", value: String(radius))
        ]
        
        guard let url = urlComponents?.url else {
            throw LandTransportAPIError.invalidURL
        }
        
        let request = try authenticatedRequest(for: url)
        let response = try await performRequest(request, decoding: BikeParking.self)
        return response.value
    }
}
