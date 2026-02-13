//
//  LandTransportAPI+BusRoutes.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads bus route information from the Land Transport API.
    ///
    /// This method retrieves all available ``BusRoute`` records, handling pagination automatically
    /// by iteratively fetching additional pages until all routes are retrieved.
    ///
    /// - Returns: An array of all available ``BusRoute`` objects.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadBusRoutes() async throws -> [BusRoute] {
        try await downloadPaginatedData(
            from: .busRoutes,
            wrapperType: BusRoutes.self,
            valueKeyPath: \.value
        )
    }
    
    /// Downloads planned bus route information from the Land Transport API.
    ///
    /// This method retrieves all available ``PlannedBusRoute`` records from the API in a single request.
    ///
    /// - Returns: An array of ``PlannedBusRoute`` objects representing planned bus routes.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadPlannedBusRoutes() async throws -> [PlannedBusRoute] {
        let request = try authenticatedRequest(for: LandTransportEndpoints.plannedBusRoute.url)
        let response = try await performRequest(request, decoding: PlannedBusRoutes.self)
        return response.value
    }
}
