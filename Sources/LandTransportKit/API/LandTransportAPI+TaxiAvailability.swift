//
//  LandTransportAPI+TaxiAvailability.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Retrieves the current locations of available taxis.
    ///
    /// This asynchronous method fetches taxi availability data from the
    /// Land Transport Authority's API endpoint. The response includes the
    /// coordinates of all available taxis at the time of the request.
    ///
    /// - Returns: An array of ``TaxiAvailability`` representing each available taxi's location.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadTaxiAvailability() async throws -> [TaxiAvailability] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.taxiAvailability.url)
        let response = try await performRequest(request, decoding: Taxis.self)
        return response.value
    }
}
