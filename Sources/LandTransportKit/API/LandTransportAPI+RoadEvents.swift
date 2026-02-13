//
//  LandTransportAPI+RoadOpenings.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads the current list of road openings from the Land Transport API.
    ///
    /// This asynchronous function fetches road opening data from the endpoint specified, decodes the response into an array of ``RoadEvent`` objects,
    /// and returns the result.
    ///
    /// - Returns: An array of ``RoadEvent`` values representing the current road openings.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadRoadOpenings() async throws -> [RoadEvent] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.roadOpenings.url)
        let response = try await performRequest(request, decoding: RoadEvents.self)
        return response.value
    }
    
    
    /// Downloads the current list of road works from the Land Transport API.
    ///
    /// This asynchronous function fetches road works data from the endpoint specified, decodes the response into an array of ``RoadEvent`` objects,
    /// and returns the result.
    ///
    /// - Returns: An array of ``RoadEvent`` values representing the current road works.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadRoadWorks() async throws -> [RoadEvent] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.roadWorks.url)
        let response = try await performRequest(request, decoding: RoadEvents.self)
        return response.value
    }
}
