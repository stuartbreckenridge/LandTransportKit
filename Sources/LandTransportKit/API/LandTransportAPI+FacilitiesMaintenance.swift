//
//  LandTransportAPI+FacilitiesMaintenance.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation

public extension LandTransportAPI {
    
    
    
    
    
    /// Downloads the latest facilities maintenance data from the Land Transport API.
    ///
    /// This asynchronous function retrieves a list of `LiftMaintenance` items, representing maintenance status for lifts in public transportation facilities.
    ///
    /// - Returns: An array of `LiftMaintenance` objects containing information about ongoing or scheduled maintenance.
    /// - Throws: An error if the network request fails or if decoding the response data fails.
    ///
    /// Example usage:
    /// ```swift
    /// let maintenanceList = try await api.downloadFacilitiesMaintenance()
    /// ```
    func downloadFacilitiesMaintenance() async throws -> [LiftMaintenance] {
        var urlRequest = URLRequest(url: LandTransportEndpoints.facilitiesMaintenance.url)
        urlRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let lifts = try JSONDecoder().decode(FacilitiesMaintenance.self, from: data)
        return lifts.value
    }
    
    
    
    
    
}
