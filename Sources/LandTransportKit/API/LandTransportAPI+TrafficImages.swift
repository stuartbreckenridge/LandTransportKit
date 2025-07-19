//
//  LandTransportAPI+TrafficImages.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    
    /// Downloads the latest traffic images from the Land Transport Authority (LTA) Traffic Images API.
    ///
    /// This asynchronous function sends a request to the LTA Traffic Images endpoint and retrieves an array of `TrafficImage` objects,
    /// each representing a traffic camera image with associated metadata.
    ///
    /// - Returns: An array of `TrafficImage` objects containing details and URLs for traffic camera images.
    /// - Throws: An error if the network request fails or the data cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let images = try await api.downloadTrafficImages()
    /// ```
    func downloadTrafficImages() async throws -> [TrafficImage] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.trafficImages.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let trafficImages = try JSONDecoder().decode(TrafficImages.self, from: data)
        return trafficImages.value
    }
    
}
