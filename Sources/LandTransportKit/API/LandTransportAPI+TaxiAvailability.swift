//
//  LandTransportAPI+TaxiAvailability.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    /// Retrieves the current locations of available taxis.
    ///
    /// This asynchronous method fetches taxi availability data from the
    /// Land Transport Authority's API endpoint. The response includes the
    /// coordinates of all available taxis at the time of the request.
    ///
    /// - Returns: An array of `TaxiAvailability` representing each available taxi's location.
    /// - Throws: An error if the network request fails or the response cannot be decoded.
    ///
    /// The request uses the `AccountKey` HTTP header for authentication.
    func downloadTaxiAvailability() async throws -> [TaxiAvailability] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.taxiAvailability.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let taxis = try JSONDecoder().decode(Taxis.self, from: data)
        return taxis.value
    }
    
    
}
