//
//  File.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/02/2026.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads the Traffic Flow ZIP file and returns the raw data and filename.
    ///
    /// This call requests the Traffic Flow endpoint, decodes the response to find the
    /// ZIP file link, then downloads the ZIP payload.
    ///
    /// - Returns: A tuple containing the ZIP `Data` and the downloaded filename.
    /// - Throws: `URLError` if the request fails, if the response is rate-limited, or if
    ///   the ZIP link is missing.
    func downloadTrafficFlow() async throws -> (Data, String) {
        var request = URLRequest(url: LandTransportEndpoints.trafficFlow.url)
        request.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (jsonData, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 500 {
                // Rate limited requests throw a 500 error.
                throw URLError.init(.cannotLoadFromNetwork, userInfo: ["Reason" : "Rate Limited"])
            }
        }
        let decoded = try JSONDecoder().decode(PassengerVolume.self, from: jsonData)
        
        guard let link = decoded.value.first?.Link else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        let zipRequest = URLRequest(url: URL(string: link)!)
        
        let (zipData, _) = try await URLSession.shared.data(for: zipRequest)
        
        return (zipData, zipRequest.url!.lastPathComponent)
    }
    
}
