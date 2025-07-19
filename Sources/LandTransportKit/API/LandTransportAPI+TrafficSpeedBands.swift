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
    /// - Parameters:
    ///   - bands: An array of `TrafficSpeedBand` objects to start with. This is primarily for recursion and can usually be left as the default empty array.
    ///   - skip: The number of records to skip for pagination. This is primarily for internal use and can usually be left as the default value of `0`.
    ///
    /// - Returns: An array of all downloaded `TrafficSpeedBand` objects from the API.
    ///
    /// - Throws: An error if the network request fails or if decoding the response fails.
    ///
    /// This method will recursively fetch traffic speed bands in batches of 500 until all available records are downloaded.
    func downloadTrafficSpeedBands(_ bands: [TrafficSpeedBand] = [], skip: Int = 0) async throws -> [TrafficSpeedBand] {
        var currentBands = bands
    
        var urlComponents = URLComponents(url: LandTransportEndpoints.trafficSpeedBands.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "$skip", value: String(skip))]
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let downloadedBands = try JSONDecoder().decode(TrafficSpeedBands.self, from: data).value
        
        currentBands.append(contentsOf: downloadedBands)
        
        if downloadedBands.count == 500 {
            return try await downloadTrafficSpeedBands(currentBands, skip: skip + 500)
        } else {
            return currentBands
        }
    }
    
    
}
