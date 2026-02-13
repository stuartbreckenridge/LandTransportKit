//
//  LandTransportAPI+EstimatedTravelTime.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Downloads the estimated travel times for various routes from the Land Transport API.
    ///
    /// This asynchronous function sends a request to the API's estimated travel time endpoint,
    /// decodes the JSON response into an array of ``EstimatedTravelTime`` objects, and returns them.
    ///
    /// - Returns: An array of ``EstimatedTravelTime`` representing the current estimated travel times.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let times = try await api.downloadEstimatedTravelTimes()
    /// ```
    func downloadEstimatedTravelTimes() async throws -> [EstimatedTravelTime] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.estimatedTravelTime.url)
        let response = try await performRequest(request, decoding: EstimatedTravelTimes.self)
        return response.value
    }
}
