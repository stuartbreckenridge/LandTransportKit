//
//  LandTransportAPI+BusServices.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 10/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads bus services from the Land Transport API.
    ///
    /// - Parameters:
    ///   - busServices: An array of `BusService` objects to which newly fetched services will be appended. Defaults to an empty array. This parameter is used internally for recursive accumulation of paged results and is not typically provided by callers.
    ///   - skip: The offset used for paginated requests. Defaults to `0`. This parameter is used internally for recursive paging and is not typically provided by callers.
    ///
    /// - Returns: An array of all available `BusService` objects retrieved from the API.
    ///
    /// - Throws: An error if the network request fails or the response data cannot be decoded.
    ///
    /// This method fetches bus services from the API, handling paging automatically by recursively requesting additional data until all services have been retrieved (when fewer than 500 results are returned in a single page).
    func downloadBusServices(_ busServices: [BusService] = [], skip: Int = 0) async throws -> [BusService] {
        var services = busServices
        var urlComponents = URLComponents(url: LandTransportEndpoints.busServices.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "$skip", value: String(skip))]
        
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode([BusService].self, from: data)
        services.append(contentsOf: decodedData)
        if decodedData.count == 500 {
            return try await downloadBusServices(services, skip: skip + 500)
        } else {
            return services
        }
    }
    
    
    
}
