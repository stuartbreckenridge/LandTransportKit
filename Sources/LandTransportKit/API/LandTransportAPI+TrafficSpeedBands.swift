//
//  LandTransportAPI+TrafficSpeedBands.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads all available traffic speed bands from the Land Transport API, handling pagination automatically.
    ///
    /// This method fetches traffic speed bands in batches and accumulates the results using an iterative
    /// approach until all available records are downloaded.
    ///
    /// - Returns: An array of all downloaded ``TrafficSpeedBand`` objects from the API.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadTrafficSpeedBands() async throws -> [TrafficSpeedBand] {
        try await downloadPaginatedData(
            from: .trafficSpeedBands,
            wrapperType: TrafficSpeedBands.self,
            valueKeyPath: \.value
        )
    }
}
