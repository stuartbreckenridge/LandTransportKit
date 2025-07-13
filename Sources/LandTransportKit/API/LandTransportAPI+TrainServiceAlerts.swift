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
    /// This asynchronous function sends a network request to the train service alerts endpoint and decodes the response into an array of `TrainServiceAlert` objects.
    ///
    /// - Returns: An array of `TrainServiceAlert` representing the current train service alerts.
    /// - Throws: An error of type `URLError` if the network request fails, or a decoding error if the response cannot be parsed.
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
        var urlRequest = URLRequest(url: LandTransportEndpoints.trainServiceAlerts.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let alerts = try JSONDecoder().decode(TrainServiceAlerts.self, from: data)
        return alerts.value
    }
    
    
}
