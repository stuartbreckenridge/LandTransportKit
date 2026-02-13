//
//  LandTransportAPI+TrafficImages.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    
    /// Downloads the latest traffic images from the Land Transport Authority (LTA) Traffic Images API.
    ///
    /// This asynchronous function sends a request to the LTA Traffic Images endpoint and retrieves an array of ``TrafficImage`` objects,
    /// each representing a traffic camera image with associated metadata.
    ///
    /// - Returns: An array of ``TrafficImage`` objects containing details and URLs for traffic camera images.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let images = try await api.downloadTrafficImages()
    /// ```
    func downloadTrafficImages() async throws -> [TrafficImage] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.trafficImages.url)
        let response = try await performRequest(request, decoding: TrafficImages.self)
        return response.value
    }
}
