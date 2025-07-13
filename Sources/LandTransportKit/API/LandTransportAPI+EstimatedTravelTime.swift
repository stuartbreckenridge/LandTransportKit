//
//  LandTransportAPI+EstimatedTravelTime.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Downloads the estimated travel times for various routes from the Land Transport API.
    ///
    /// This asynchronous function sends a request to the API's estimated travel time endpoint,
    /// decodes the JSON response into an array of `EstimatedTravelTime` objects, and returns them.
    ///
    /// - Returns: An array of `EstimatedTravelTime` representing the current estimated travel times.
    /// - Throws: An error if the network request fails or if decoding the response is unsuccessful.
    ///
    /// Example usage:
    /// ```
    /// let times = try await api.downloadEstimatedTravelTimes()
    /// ```
    func downloadEstimatedTravelTimes() async throws -> [EstimatedTravelTime] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.estimatedTravelTime.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let travelTimes = try JSONDecoder().decode(EstimatedTravelTimes.self, from: data)
        return travelTimes.value
    }
    
}
