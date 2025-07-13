//
//  LandTransportAPI+TaxiStands.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    
    /// Downloads the list of taxi stands from the Land Transport API.
    ///
    /// This asynchronous function sends a request to the taxi stands endpoint using the configured API key.
    /// It decodes the received JSON data into an array of `TaxiStand` objects.
    ///
    /// - Returns: An array of `TaxiStand` objects representing the available taxi stands.
    /// - Throws: An error if the network request fails or if the response cannot be decoded.
    func downloadTaxiStands() async throws -> [TaxiStand] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.taxiStands.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let taxis = try JSONDecoder().decode(TaxiStands.self, from: data)
        return taxis.value
    }
    
    
}
