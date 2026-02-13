//
//  LandTransportAPI+TrafficFlow.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/02/2026.
//

import Foundation


public extension LandTransportAPI {
    
    /// Downloads the Traffic Flow dataset and returns the decoded payload.
    ///
    /// This call requests the Traffic Flow endpoint, decodes the response to find the
    /// ZIP file link, downloads the ZIP payload, and decodes it into ``TrafficFlowData``.
    ///
    /// - Returns: The decoded ``TrafficFlowData`` payload.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/missingDownloadLink`` if the download link is not found in the response.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    ///
    /// Example usage:
    /// ```swift
    /// let api = LandTransportAPI.shared
    /// await api.configure(apiKey: "YOUR_KEY")
    /// let trafficFlow = try await api.downloadTrafficFlow()
    /// print(trafficFlow)
    /// ```
    func downloadTrafficFlow() async throws -> TrafficFlowData {
        let request = try authenticatedRequest(for: LandTransportEndpoints.trafficFlow.url)
        let decoded = try await performRequest(request, decoding: TrafficFlow.self)
        
        guard let link = decoded.value.first?.Link, let downloadURL = URL(string: link) else {
            throw LandTransportAPIError.missingDownloadLink
        }
        
        let flowData: Data
        let flowResponse: URLResponse
        
        do {
            (flowData, flowResponse) = try await urlSession.data(from: downloadURL)
        } catch let error as URLError {
            throw LandTransportAPIError.networkError(underlying: error)
        }
        
        try checkResponse(flowResponse)
        
        do {
            return try JSONDecoder().decode(TrafficFlowData.self, from: flowData)
        } catch let error as DecodingError {
            throw LandTransportAPIError.decodingFailed(underlying: error)
        }
    }
}
