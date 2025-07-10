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
    /// This method retrieves all available `BusRoute` records, handling pagination automatically
    /// by recursively fetching additional pages if necessary. You can optionally pass in a list of
    /// previously downloaded routes and a skip value to continue retrieving from where you left off.
    ///
    /// - Parameters:
    ///   - routes: An array of `BusRoute` objects that have already been downloaded (used for pagination). Defaults to an empty array.
    ///   - skip: The number of records to skip for pagination. Defaults to 0. This parameter is used internally for recursive paging and is not typically provided by callers.
    /// - Returns: An array of all available `BusRoute` objects.
    /// - Throws: An error if the network request or JSON decoding fails.
    func downloadBusRoutes(_ routes: [BusRoute] = [], skip: Int = 0) async throws -> [BusRoute] {
        var downloadedRoutes = routes
        var urlComponents = URLComponents(url: LandTransportEndpoints.busRoutes.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "$skip", value: String(skip))]
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(BusRoutes.self, from: data)
        downloadedRoutes.append(contentsOf: decodedData.value)
        if decodedData.value.count == 500 {
            return try await downloadBusRoutes(downloadedRoutes, skip: skip + 500)
        } else {
            return downloadedRoutes
        }
    }
    
}
