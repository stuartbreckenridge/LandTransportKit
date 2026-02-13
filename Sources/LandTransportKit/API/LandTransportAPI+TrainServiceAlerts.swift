//
//  LandTransportAPI+TrainServiceAlerts.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Downloads the latest train service alerts from the Land Transport API.
    ///
    /// This asynchronous function sends a network request to the train service alerts endpoint and decodes the response into a ``TrainServiceAlert`` object.
    ///
    /// - Returns: A ``TrainServiceAlert`` representing the current train service alerts.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```swift
    /// do {
    ///     let alerts = try await api.downloadTrainServiceAlerts()
    ///     // Handle alerts
    /// } catch {
    ///     // Handle error
    /// }
    /// ```
    func downloadTrainServiceAlerts() async throws -> TrainServiceAlert {
        let request = try authenticatedRequest(for: LandTransportEndpoints.trainServiceAlerts.url)
        let response = try await performRequest(request, decoding: TrainServiceAlerts.self)
        return response.value
    }
}
