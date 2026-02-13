//
//  LandTransportAPI+BusServices.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 10/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads bus services from the Land Transport API.
    ///
    /// This method fetches all available bus services from the API, handling pagination automatically
    /// by iteratively requesting additional data until all services have been retrieved.
    ///
    /// - Returns: An array of all available ``BusService`` objects retrieved from the API.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadBusServices() async throws -> [BusService] {
        try await downloadPaginatedData(
            from: .busServices,
            wrapperType: BusServices.self,
            valueKeyPath: \.value
        )
    }
}
