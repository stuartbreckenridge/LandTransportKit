//
//  LandTransportAPI+BusArrivals.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 10/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    /// Retrieves bus arrival information for a specific bus stop.
    ///
    /// - Parameters:
    ///   - stopId: The unique identifier for the bus stop (Bus Stop Code) to fetch arrival information for.
    ///   - serviceNo: (Optional) The specific bus service number to filter arrivals by. If `nil`, arrivals for all services at the stop are returned.
    ///
    /// - Returns: A ``BusArrivals`` object containing the arrival information for the specified stop and/or service.
    ///
    /// - Throws: An error if the network request fails or the response cannot be decoded.
    ///
    /// - Precondition: You must call ``configure(apiKey:)`` with a valid API key before using this method.
    ///
    /// - Note: This method performs a network request to the Land Transport API and should be called from an asynchronous context.
    func getBusArrivals(at stopId: String, serviceNo: String? = nil) async throws -> BusArrivals {
        var urlComponents = URLComponents(url: LandTransportEndpoints.busArrivals.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "BusStopCode", value: stopId)]
        if serviceNo != nil {
            urlComponents?.queryItems?.append(URLQueryItem(name: "ServiceNo", value: serviceNo!))
        }
        var urlRequest = URLRequest(url: urlComponents!.url!)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let decodedData = try JSONDecoder().decode(BusArrivals.self, from: data)
        return decodedData
    }
    
    
    
}
