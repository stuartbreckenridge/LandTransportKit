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
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/missingDownloadLink`` if the download link is not found in the response.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - Warning: This is a rate-limited API. Excessive requests may result in a rate limit error.
    func downloadPassengerVolumeByBusStop() async throws -> (Data, String) {
        try await downloadPassengerVolumeData(from: .passengerVolumeByBusStop)
    }
    
    
    /// Returns number of trips by weekdays and weekends from origin to
    /// destination bus stops in zip format (with an enclosed CSV).
    ///
    /// This method performs two network requests:
    /// 1. It first fetches a JSON metadata endpoint to retrieve a signed download URL for the latest dataset.
    /// 2. It then downloads the zipped file from the provided link as `Data`.
    ///
    /// - Returns: The raw zip file data containing passenger volume statistics by origin-destination bus stop pairs and the file name.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/missingDownloadLink`` if the download link is not found in the response.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - Warning: This is a rate-limited API. Excessive requests may result in a rate limit error.
    func downloadPassengerVolumeByOriginDestinationBusStop() async throws -> (Data, String) {
        try await downloadPassengerVolumeData(from: .passengerVolumeByOriginDestinationBusStops)
    }
    
    /// Downloads tap in and tap out passenger volume data by origin and destination train stations, provided in a ZIP archive (enclosing a CSV file).
    ///
    /// This method performs two network requests:
    /// 1. Fetches a JSON metadata endpoint to retrieve a signed download URL for the latest dataset.
    /// 2. Downloads the ZIP file from the obtained link as `Data`.
    ///
    /// - Returns: A tuple containing the raw ZIP file data with passenger volume statistics by origin-destination train station pairs, and the file name.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/missingDownloadLink`` if the download link is not found in the response.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    /// 
    /// - Warning: This is a rate-limited API. Excessive requests may result in a rate limit error.
    func downloadPassengerVolumeByOriginDestinationTrainStation() async throws -> (Data, String) {
        try await downloadPassengerVolumeData(from: .passengerVolumeByOriginDestinationTrainStation)
    }
    
    
    /// Downloads tap in and tap out passenger volume data by train station, provided in a ZIP archive (enclosing a CSV file).
    ///
    /// This method performs two network requests:
    /// 1. Fetches a JSON metadata endpoint to retrieve a signed download URL for the latest dataset.
    /// 2. Downloads the ZIP file from the obtained link as `Data`.
    ///
    /// - Returns: A tuple containing the raw ZIP file data with passenger volume statistics by train station, and the file name.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/missingDownloadLink`` if the download link is not found in the response.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// - Warning: This is a rate-limited API. Excessive requests may result in a rate limit error.
    func downloadPassengerVolumeByTrainStation() async throws -> (Data, String) {
        try await downloadPassengerVolumeData(from: .passengerVolumeByTrainStation)
    }
    
    // MARK: - Private Helper
    
    /// Internal helper method to download passenger volume data from any passenger volume endpoint.
    ///
    /// - Parameter endpoint: The endpoint to fetch data from.
    /// - Returns: A tuple containing the ZIP file data and the filename.
    /// - Throws: ``LandTransportAPIError`` for various failure conditions.
    private func downloadPassengerVolumeData(from endpoint: LandTransportEndpoints) async throws -> (Data, String) {
        let request = try authenticatedRequest(for: endpoint.url)
        let decoded = try await performRequest(request, decoding: PassengerVolume.self)
        
        guard let link = decoded.value.first?.Link, let downloadURL = URL(string: link) else {
            throw LandTransportAPIError.missingDownloadLink
        }
        
        let zipData: Data
        let zipResponse: URLResponse
        
        do {
            (zipData, zipResponse) = try await urlSession.data(from: downloadURL)
        } catch let error as URLError {
            throw LandTransportAPIError.networkError(underlying: error)
        }
        
        try checkResponse(zipResponse)
        
        let filename = downloadURL.lastPathComponent
        return (zipData, filename)
    }
}
