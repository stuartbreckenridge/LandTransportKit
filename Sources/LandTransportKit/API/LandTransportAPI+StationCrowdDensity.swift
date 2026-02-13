//
//  LandTransportAPI+StationCrowdDensity.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation


/// `TrainLines` is an enumeration representing the various train and LRT lines.
/// 
/// Each case corresponds to a specific MRT or LRT line. The enum includes both 
/// abbreviation codes and human-readable descriptions for each line.
/// 
/// - Cases:
///   - `ccl`: Circle Line
///   - `cel`: Circle Line Extension
///   - `cgl`: Changi Extension
///   - `dtl`: Downtown Line
///   - `ewl`: East West Line
///   - `nel`: North East Line
///   - `nsl`: North South Line
///   - `bpl`: Bukit Panjang LRT
///   - `slrt`: Sengkang LRT
///   - `plrt`: Punggol LRT
///   - `tel`: Thomson-East Coast Line
///
/// Use the `code` property to get the line's abbreviation and `description` for a
/// human-readable name.
public enum TrainLines: CaseIterable, Sendable {
    case ccl         // Circle Line
    case cel         // Circle Line Extension
    case cgl         // Changi Extension
    case dtl         // Downtown Line
    case ewl         // East West Line
    case nel         // North East Line
    case nsl         // North South Line
    case bpl         // Bukit Panjang LRT
    case slrt        // Sengkang LRT
    case plrt        // Punggol LRT
    case tel         // Thomson-East Coast Line

    /// The abbreviation code for the train line.
    public var code: String {
        switch self {
        case .ccl:  return "CCL"
        case .cel:  return "CEL"
        case .cgl:  return "CGL"
        case .dtl:  return "DTL"
        case .ewl:  return "EWL"
        case .nel:  return "NEL"
        case .nsl:  return "NSL"
        case .bpl:  return "BPL"
        case .slrt: return "SLRT"
        case .plrt: return "PLRT"
        case .tel:  return "TEL"
        }
    }

    /// The description of the train line.
    public var description: String {
        switch self {
        case .ccl:  return "Circle Line"
        case .cel:  return "Circle Line Extension (BayFront, Marina Bay)"
        case .cgl:  return "Changi Extension (Expo, Changi Airport)"
        case .dtl:  return "Downtown Line"
        case .ewl:  return "East West Line"
        case .nel:  return "North East Line"
        case .nsl:  return "North South Line"
        case .bpl:  return "Bukit Panjang LRT"
        case .slrt: return "Sengkang LRT"
        case .plrt: return "Punggol LRT"
        case .tel:  return "Thomson-East Coast Line"
        }
    }
}


public extension LandTransportAPI {
    
    /// Downloads the real-time crowd density data for a specific train or LRT line.
    ///
    /// This asynchronous function retrieves crowd density information for all stations on the specified line.
    /// The data is fetched from the Land Transport Authority's real-time endpoint and decoded into an array of ``RealTimeDensity`` values.
    ///
    /// - Parameter line: The ``TrainLines`` case representing the MRT or LRT line to fetch crowd density data for.
    ///
    /// - Returns: An array of ``RealTimeDensity`` objects, each representing real-time crowd density for a station on the specified line.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadRealTimeDensity(for line: TrainLines) async throws -> [RealTimeDensity] {
        var urlComponents = URLComponents(url: LandTransportEndpoints.stationCrowdDensityRealTime.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "TrainLine", value: line.code)]
        
        guard let url = urlComponents?.url else {
            throw LandTransportAPIError.invalidURL
        }
        
        let request = try authenticatedRequest(for: url)
        let response = try await performRequest(request, decoding: StationCrowdDensityRealTime.self)
        return response.value
    }
    
    /// Downloads the forecast crowd density data for a specific train or LRT line.
    ///
    /// This asynchronous function retrieves forecasted crowd density information for all stations on the specified line.
    /// The data is fetched from the Land Transport Authority's forecast endpoint and decoded into an array of ``ForecastDensity`` values.
    ///
    /// - Parameter line: The ``TrainLines`` case representing the MRT or LRT line to fetch forecast crowd density data for.
    ///
    /// - Returns: An array of ``ForecastDensity`` objects, each representing forecasted crowd density for a station on the specified line.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not configured.
    /// - Throws: ``LandTransportAPIError/invalidURL`` if the URL cannot be constructed.
    /// - Throws: ``LandTransportAPIError/rateLimited`` if the request is rate limited.
    /// - Throws: ``LandTransportAPIError/networkError(underlying:)`` if a network error occurs.
    /// - Throws: ``LandTransportAPIError/decodingFailed(underlying:)`` if the response cannot be decoded.
    func downloadForecastDensity(for line: TrainLines) async throws -> [ForecastDensity] {
        var urlComponents = URLComponents(url: LandTransportEndpoints.stationCrowdDensityForecast.url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "TrainLine", value: line.code)]
        
        guard let url = urlComponents?.url else {
            throw LandTransportAPIError.invalidURL
        }
        
        let request = try authenticatedRequest(for: url)
        let response = try await performRequest(request, decoding: StationCrowdDensityForecast.self)
        return response.value
    }
}
