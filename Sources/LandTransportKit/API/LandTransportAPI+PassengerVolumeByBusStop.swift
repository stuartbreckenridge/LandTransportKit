//
//  LandTransportAPI+PassengerVolumeByBusStop.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation


public extension LandTransportAPI {
    

    /// Downloads the latest LTA Passenger Volume by Bus Stop dataset in CSV format.
    ///
    /// This method performs two network requests:
    /// 1. It first fetches a JSON metadata endpoint to retrieve the signed download URL for the latest dataset.
    /// 2. It then downloads the CSV file from the provided link.
    ///
    /// - Returns: The raw CSV file data containing passenger volume statistics by bus stop.
    /// - Throws: An error if the network request fails, the response cannot be decoded,
    ///           or if the expected link to the CSV file is not found.
    ///
    /// The `AccountKey` header is added to both requests using the API key provided to `LandTransportAPI`.
    func downloadPassengerVolumeByBusStop() async throws -> Data {
        var request = URLRequest(url: LandTransportEndpoints.passengerVolumeByBusStop.url)
        request.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (jsonData, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(PassengerVolumeByBusStop.self, from: jsonData)
        
        guard let link = decoded.value.first else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        var csvRequest = URLRequest(url: URL(string: link.Link)!)
        csvRequest.addValue(apiKey ?? "", forHTTPHeaderField: "AccountKey")
        
        let (csvData, _) = try await URLSession.shared.data(for: csvRequest)
        return csvData
    }
    
}
