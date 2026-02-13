//
//  LandTransportAPI+FacilitiesMaintenance.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Downloads the latest facilities maintenance data from the Land Transport API.
    ///
    /// This asynchronous function retrieves a list of ``LiftMaintenance`` items, representing maintenance status for lifts in public transportation facilities.
    ///
    /// - Returns: An array of ``LiftMaintenance`` objects containing information about ongoing or scheduled maintenance.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```swift
    /// let maintenanceList = try await api.downloadFacilitiesMaintenance()
    /// ```
    func downloadFacilitiesMaintenance() async throws -> [LiftMaintenance] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.facilitiesMaintenance.url)
        let response = try await performRequest(request, decoding: FacilitiesMaintenance.self)
        return response.value
    }
}
