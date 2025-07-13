//
//  LandTransportAPI+RoadOpenings.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads the current list of road openings from the Land Transport API.
    ///
    /// This asynchronous function fetches road opening data from the endpoint specified, decodes the response into an array of `RoadOpening` objects,
    /// and returns the result.
    ///
    /// - Throws: An error if the network request fails or if decoding the response data fails.
    /// - Returns: An array of `RoadOpening` values representing the current road openings.
    func downloadRoadOpenings() async throws -> [RoadEvent] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.roadOpenings.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let openings = try JSONDecoder().decode(RoadEvents.self, from: data)
        return openings.value
    }
    
    
    /// Downloads the current list of road works from the Land Transport API.
    ///
    /// This asynchronous function fetches road works data from the endpoint specified, decodes the response into an array of `RoadEvent` objects,
    /// and returns the result.
    ///
    /// - Throws: An error if the network request fails or if decoding the response data fails.
    /// - Returns: An array of `RoadEvent` values representing the current road works.
    func downloadRoadWorks() async throws -> [RoadEvent] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.roadWorks.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let openings = try JSONDecoder().decode(RoadEvents.self, from: data)
        return openings.value
    }
    
    
}
