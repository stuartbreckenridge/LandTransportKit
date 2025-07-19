//
//  LandTransportAPI+TrafficIncidents.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    
    
    /// Downloads current traffic incidents from the Land Transport Authority API.
    ///
    /// This method sends an authenticated request to the Land Transport Authority's "Traffic Incidents" endpoint and decodes the response into an array of `TrafficIncident` objects.
    ///
    /// - Returns: An array of `TrafficIncident` representing the latest traffic incidents.
    /// - Throws: An error if the request fails or if the response data cannot be decoded.
    /// - Note: The request includes the API key via the "AccountKey" HTTP header, if set.
    /// - SeeAlso: `TrafficIncident`, `LandTransportEndpoints.trafficIncidents`
    func downloadTrafficIncidents() async throws -> [TrafficIncident] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.trafficIncidents.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let trafficIncidents = try JSONDecoder().decode(TrafficIncidents.self, from: data)
        return trafficIncidents.value
    }
    
    
}
