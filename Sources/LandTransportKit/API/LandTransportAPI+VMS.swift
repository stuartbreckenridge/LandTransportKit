//
//  LandTransportAPI+VMS.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads all current traffic advisory messages from the Variable Message Services (VMS) API endpoint.
    ///
    /// This asynchronous method makes a network request to the Land Transport VMS endpoint, decodes the response,
    /// and returns an array of ``TrafficAdvisoryMessage`` objects.
    ///
    /// - Returns: An array of ``TrafficAdvisoryMessage`` representing the latest traffic advisories.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let advisories = try await api.downloadTrafficAdvisories()
    /// ```
    func downloadTrafficAdvisories() async throws -> [TrafficAdvisoryMessage] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.vms.url)
        let response = try await performRequest(request, decoding: VariableMessageServices.self)
        return response.value
    }
}
