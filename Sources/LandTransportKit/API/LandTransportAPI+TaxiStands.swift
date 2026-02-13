//
//  LandTransportAPI+TaxiStands.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Downloads the list of taxi stands from the Land Transport API.
    ///
    /// This asynchronous function sends a request to the taxi stands endpoint using the configured API key.
    /// It decodes the received JSON data into an array of ``TaxiStand`` objects.
    ///
    /// - Returns: An array of ``TaxiStand`` objects representing the available taxi stands.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadTaxiStands() async throws -> [TaxiStand] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.taxiStands.url)
        let response = try await performRequest(request, decoding: TaxiStands.self)
        return response.value
    }
}
