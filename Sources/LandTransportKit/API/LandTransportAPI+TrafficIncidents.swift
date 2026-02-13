//
//  LandTransportAPI+TrafficIncidents.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Downloads current traffic incidents from the Land Transport Authority API.
    ///
    /// This method sends an authenticated request to the Land Transport Authority's "Traffic Incidents" endpoint and decodes the response into an array of ``TrafficIncident`` objects.
    ///
    /// - Returns: An array of ``TrafficIncident`` representing the latest traffic incidents.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - SeeAlso: ``TrafficIncident``, ``LandTransportEndpoints/trafficIncidents``
    func downloadTrafficIncidents() async throws -> [TrafficIncident] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.trafficIncidents.url)
        let response = try await performRequest(request, decoding: TrafficIncidents.self)
        return response.value
    }
}
