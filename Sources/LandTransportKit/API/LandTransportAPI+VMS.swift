//
//  LandTransportAPI+VMS.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


public extension LandTransportAPI {
    
    
    
    /// Downloads all current traffic advisory messages from the Variable Message Services (VMS) API endpoint.
    ///
    /// This asynchronous method makes a network request to the Land Transport VMS endpoint, decodes the response,
    /// and returns an array of `TrafficAdvisoryMessage` objects.
    ///
    /// - Returns: An array of `TrafficAdvisoryMessage` representing the latest traffic advisories.
    /// - Throws: An error if the network request fails or if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```
    /// let advisories = try await api.downloadTrafficAdvisories()
    /// ```
    func downloadTrafficAdvisories() async throws -> [TrafficAdvisoryMessage] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.vms.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let advisories = try JSONDecoder().decode(VariableMessageServices.self, from: data)
        return advisories.value
    }
    
    
    
    
}
