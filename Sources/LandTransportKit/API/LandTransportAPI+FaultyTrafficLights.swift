//
//  LandTransportAPI+FaultyTrafficLights.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Retrieves a list of currently reported faulty traffic lights.
    ///
    /// This asynchronous function fetches the latest faulty traffic light reports from the Land Transport API.
    /// The request includes the configured API key and returns the parsed list of `FaultyTrafficLight` items.
    ///
    /// - Returns: An array of `FaultyTrafficLight` instances representing faulty or reported traffic lights.
    /// - Throws: An error if the network request fails or if the data cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let lights = try await api.downloadFaultyTrafficLights()
    /// ```
    func downloadFaultyTrafficLights() async throws -> [FaultyTrafficLight] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.faultyTrafficLights.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let lights = try JSONDecoder().decode(FaultyTrafficLights.self, from: data)
        return lights.value
    }
}
