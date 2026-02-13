//
//  LandTransportAPI+FaultyTrafficLights.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Retrieves a list of currently reported faulty traffic lights.
    ///
    /// This asynchronous function fetches the latest faulty traffic light reports from the Land Transport API.
    /// The request includes the configured API key and returns the parsed list of ``FaultyTrafficLight`` items.
    ///
    /// - Returns: An array of ``FaultyTrafficLight`` instances representing faulty or reported traffic lights.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let lights = try await api.downloadFaultyTrafficLights()
    /// ```
    func downloadFaultyTrafficLights() async throws -> [FaultyTrafficLight] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.faultyTrafficLights.url)
        let response = try await performRequest(request, decoding: FaultyTrafficLights.self)
        return response.value
    }
}
