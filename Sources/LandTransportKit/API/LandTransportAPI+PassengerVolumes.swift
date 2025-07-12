//
//  LandTransportAPI+PassengerVolumeByBusStop.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation


public extension LandTransportAPI {
    

    /// Returns tap in and tap out passenger volume by weekdays and
    /// weekends for individual bus stop in zip format (with an enclosed csv).
    ///
    /// This method performs two network requests:
    /// 1. It first fetches a JSON metadata endpoint to retrieve the signed download URL for the latest dataset.
    /// 2. It then downloads the zipped  file from the provided link as `Data`.
    ///
    /// - Returns: The raw zip file data containing passenger volume statistics by bus stop and the file name.
    /// - Throws: An error if the network request fails, the response cannot be decoded,
    ///           or if the expected link to the Zip file is not found.
    ///
    /// - Warning: This is a rate-limited API. Excessive requests may result in a 500 error response.
    func downloadPassengerVolumeByBusStop() async throws -> (Data, String) {
        var request = URLRequest(url: LandTransportEndpoints.passengerVolumeByBusStop.url)
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
    
    
    /// Returns number of trips by weekdays and weekends from origin to
    /// destination bus stops in zip format (with an enclosed CSV).
    ///
    /// This method performs two network requests:
    /// 1. It first fetches a JSON metadata endpoint to retrieve a signed download URL for the latest dataset.
    /// 2. It then downloads the zipped file from the provided link as `Data`.
    ///
    /// - Returns: The raw zip file data containing passenger volume statistics by origin-destination bus stop pairs and the file name.
    /// - Throws: An error if the network request fails, the response cannot be decoded, or if the expected link to the zip file is not found.
    ///
    /// - Warning: This is a rate-limited API. Excessive requests may result in a 500 error response.
    func downloadPassengerVolumeByOriginDestinationBusStop() async throws -> (Data, String) {
        var request = URLRequest(url: LandTransportEndpoints.passengerVolumeByOriginDestinationBusStops.url)
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
    
    /// Downloads tap in and tap out passenger volume data by origin and destination train stations, provided in a ZIP archive (enclosing a CSV file).
    ///
    /// This method performs two network requests:
    /// 1. Fetches a JSON metadata endpoint to retrieve a signed download URL for the latest dataset.
    /// 2. Downloads the ZIP file from the obtained link as `Data`.
    ///
    /// - Returns: A tuple containing the raw ZIP file data with passenger volume statistics by origin-destination train station pairs, and the file name.
    /// - Throws: An error if the network request fails, the response cannot be decoded, or if the expected link to the ZIP file is not found.
    /// 
    /// - Warning: This is a rate-limited API. Excessive requests may result in a 500 error response.
    func downloadPassengerVolumeByOriginDestinationTrainStation() async throws -> (Data, String) {
        var request = URLRequest(url: LandTransportEndpoints.passengerVolumeByOriginDestinationTrainStation.url)
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
    
    
    
    /// Downloads tap in and tap out passenger volume data by train station, provided in a ZIP archive (enclosing a CSV file).
    ///
    /// This method performs two network requests:
    /// 1. Fetches a JSON metadata endpoint to retrieve a signed download URL for the latest dataset.
    /// 2. Downloads the ZIP file from the obtained link as `Data`.
    ///
    /// - Returns: A tuple containing the raw ZIP file data with passenger volume statistics by train station, and the file name.
    /// - Throws: An error if the network request fails, the response cannot be decoded, or if the expected link to the ZIP file is not found.
    ///
    /// - Warning: This is a rate-limited API. Excessive requests may result in a 500 error response.
    func downloadPassengerVolumeByTrainStation() async throws -> (Data, String) {
        var request = URLRequest(url: LandTransportEndpoints.passengerVolumeByTrainStation.url)
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
