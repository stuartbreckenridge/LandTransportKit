//
//  LandTransportAPI+BusStops.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads the complete list of bus stops from the Land Transport API.
    ///
    /// This method paginates through the API endpoint, fetching bus stops in batches,
    /// and accumulates them into a single array. It uses an iterative approach to avoid
    /// potential stack overflow issues with large datasets.
    ///
    /// - Returns: An array of all ``BusStop`` objects retrieved from the API.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - Note: This method is asynchronous and must be called with `await`.
    func downloadBusStops() async throws -> [BusStop] {
        try await downloadPaginatedData(
            from: .busStops,
            wrapperType: BusStops.self,
            valueKeyPath: \.value
        )
    }
}
