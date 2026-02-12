//
//  File.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/02/2026.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads the Traffic Flow dataset and returns the decoded payload.
    ///
    /// This call requests the Traffic Flow endpoint, decodes the response to find the
    /// ZIP file link, downloads the ZIP payload, and decodes it into `TrafficFlowData`.
    ///
    /// - Returns: The decoded `TrafficFlowData` payload.
    /// - Throws: `URLError` if the request fails, if the response is rate-limited, or if
    ///   the ZIP link is missing.
    ///
    /// Example usage:
    /// ```swift
    /// let api = LandTransportAPI(apiKey: "YOUR_KEY")
    /// let trafficFlow = try await api.downloadTrafficFlow()
    /// print(trafficFlow)
    /// ```
    func downloadTrafficFlow() async throws -> TrafficFlowData {
        var request = URLRequest(url: LandTransportEndpoints.trafficFlow.url)
        request.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (jsonData, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 500 {
                // Rate limited requests throw a 500 error.
                throw URLError.init(.cannotLoadFromNetwork, userInfo: ["Reason" : "Rate Limited"])
            }
        }
        let decoded = try JSONDecoder().decode(TrafficFlow.self, from: jsonData)
        
        guard let link = decoded.value.first?.Link else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        let flowDataRequest = URLRequest(url: URL(string: link)!)
        
        let (flowData, _) = try await URLSession.shared.data(for: flowDataRequest)
        
        return try JSONDecoder().decode(TrafficFlowData.self, from: flowData)
    }
    
}
