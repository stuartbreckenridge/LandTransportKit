//
//  LandTransportAPI+CarParkAvailability.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


public extension LandTransportAPI {

    /// Downloads car park availability data from the Land Transport API.
    ///
    /// This method fetches car park availability in batches and accumulates the results, handling pagination
    /// by recursively requesting more data if the downloaded batch size is 500 (the API pagination limit).
    ///
    /// - Parameters:
    ///   - carParks: An array of `CarPark` objects to be appended with newly downloaded car park availability data. Typically, this should be an empty array on the initial call.
    ///   - skip: The number of records to skip in the API request, used for pagination. Defaults to `0`. You usually do not need to specify this parameter directly.
    /// - Returns: An array of all `CarPark` objects fetched from the API, including those passed in `carParks` and all paginated results.
    /// - Throws: An error if the network request fails or decoding the response is unsuccessful.
    /// - Note: The method is asynchronous and may perform multiple recursive network requests if the API returns more records.
    func downloadCarParkAvailability(_ carParks: [CarPark] = [], skip: Int = 0) async throws -> [CarPark] {
        var currentCarParks = carParks
    
        var urlComponents = URLComponents(url: LandTransportEndpoints.carParkAvailability.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "$skip", value: String(skip))]
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let downloadedCarParks = try JSONDecoder().decode(CarParkAvailability.self, from: data).value
        
        currentCarParks.append(contentsOf: downloadedCarParks)
        
        if downloadedCarParks.count == 500 {
            return try await downloadCarParkAvailability(currentCarParks, skip: skip + 500)
        } else {
            return currentCarParks
        }
    }
    
    
}
