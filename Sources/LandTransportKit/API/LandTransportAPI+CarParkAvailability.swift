//
//  LandTransportAPI+CarParkAvailability.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


public extension LandTransportAPI {

    /// Downloads car park availability data from the Land Transport API.
    ///
    /// This method fetches car park availability in batches and accumulates the results,
    /// handling pagination automatically using an iterative approach.
    ///
    /// - Returns: An array of all ``CarPark`` objects fetched from the API.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - Note: The method is asynchronous and may perform multiple network requests if the API returns more records.
    func downloadCarParkAvailability() async throws -> [CarPark] {
        try await downloadPaginatedData(
            from: .carParkAvailability,
            wrapperType: CarParkAvailability.self,
            valueKeyPath: \.value
        )
    }
}
