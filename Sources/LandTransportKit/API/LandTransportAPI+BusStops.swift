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
    /// This method paginates through the API endpoint, fetching bus stops in batches of up to 500 at a time,
    /// and accumulates them into a single array. It will recursively request further batches until no more results are available.
    ///
    /// - Parameters:
    ///   - busStops: An array of `BusStop` objects to accumulate results. This is used internally for recursion and should not be set when calling from outside.
    ///   - skip: The number of records to skip for pagination. This is used internally for recursion and should not be set when calling from outside.
    /// - Returns: An array of all `BusStop` objects retrieved from the API.
    /// - Throws: An error if the data could not be fetched or decoded.
    /// - Note: This method is asynchronous and must be called with `await`.
    func downloadBusStops(_ busStops: [BusStop] = [], skip: Int = 0) async throws -> [BusStop] {
        var stops = busStops
        var urlComponents = URLComponents(url: LandTransportEndpoints.busStops.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "$skip", value: String(skip))]
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(BusStops.self, from: data)
        stops.append(contentsOf: decodedData.value)
        if decodedData.value.count == 500 {
            return try await downloadBusStops(stops, skip: skip + 500)
        } else {
            return stops
        }
    }
    
    
}
