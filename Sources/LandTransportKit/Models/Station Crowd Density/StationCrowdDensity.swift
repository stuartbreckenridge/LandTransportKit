//
//  StationCrowdDensity.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation

internal struct StationCrowdDensityRealTime: Codable {
    let value: [RealTimeDensity]
}

internal struct StationCrowdDensityForecast: Codable {
    let value: [ForecastDensity]
}


/// A structure representing real-time crowd density information for a station.
///
/// This structure provides details about the current crowd level at a specific station
/// within a given time window. It conforms to `Codable`, `Identifiable`, and `Sendable` protocols
/// for easy serialization, identification, and concurrency safety.
///
/// - Properties:
///   - Station: The name or code of the station.
///   - StartTime: The ISO 8601-formatted string representing when the crowd density measurement started.
///   - EndTime: The ISO 8601-formatted string representing when the crowd density measurement ended.
///   - CrowdLevel: The description or categorization of the crowd density (e.g., "l", "m", "h",  "NA").
///
/// - Note: The `id` property for identification is derived from the `Station` field.
public struct RealTimeDensity: Codable, Identifiable, Sendable {
    
    public var id: String { Station }
    
    public let Station: String
    public let StartTime: String
    public let EndTime: String
    public let CrowdLevel: String
    
}



/// A structure representing forecasted crowd density information for a group of stations on a specific date.
///
/// This structure provides the forecasted crowd density levels for multiple stations for a given date.
/// Each station includes detailed interval data with associated crowd level forecasts.
/// The structure conforms to `Codable`, `Identifiable`, and `Sendable` for serialization, identification,
/// and concurrency safety.
///
/// - Properties:
///   - Date: The date (in `String` format, typically ISO 8601) for which crowd density forecasts apply.
///   - Stations: An array of `Station` objects, each representing a station and its interval-based crowd level forecasts.
///
/// - Note: The `id` property used for identification is derived from the `Date` field.
public struct ForecastDensity: Codable, Identifiable, Sendable {
    
    public var id: String { Date }
    
    public let Date: String
    public let Stations: [Station]
    
}


/// A structure representing a station with its forecasted crowd density interval.
///
/// This structure describes a station and its associated forecast interval for crowd density.
/// It conforms to `Codable`, `Sendable`, and `Identifiable` for easy encoding, concurrency safety,
/// and unique identification.
///
/// - Properties:
///   - Station: The name or code of the station.
///   - Interval: The `ForecastInterval` structure containing interval-specific crowd level forecasts.
///
/// - Note: The `id` property for identification is derived from the `Station` field.
public struct Station: Codable, Sendable, Identifiable {
    
    public var id: String { Station }
    
    public let Station: String
    public let Interval: ForecastInterval
    
}

/// A structure representing a forecast interval for crowd density at a station.
///
/// This structure encapsulates the time interval and the forecasted crowd level for a station.
/// It conforms to `Codable`, `Sendable`, and `Identifiable` to support encoding, concurrency safety, and unique identification.
///
/// - Properties:
///   - Start: The start time of the forecast interval, represented as an ISO 8601-formatted `String`.
///   - CrowdLevel: The forecasted crowd density for the interval (e.g., "l", "m", "h", "NA").
///
/// - Note: The `id` property, used for identification, is derived from the `Start` field.
public struct ForecastInterval: Codable, Sendable, Identifiable {
    
    public var id: String { Start }
    
    public let Start: String
    public let CrowdLevel: String
    
}
