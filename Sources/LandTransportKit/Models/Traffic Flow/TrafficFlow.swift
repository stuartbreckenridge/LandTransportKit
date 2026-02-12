//
//  TrafficFlow.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/02/2026.
//

import Foundation



/// Represents a traffic flow dataset response containing download links.
///
/// Use this type to decode the traffic flow API response and access the
/// available download URLs.
internal struct TrafficFlow: Codable, Sendable {
    let value: [DownloadLink]
}

/// A decoded traffic flow dataset with update time and metrics.
///
/// This mirrors the top-level payload provided by the traffic flow dataset API.
public struct TrafficFlowData: Codable, Sendable {
    
    /// The timestamp indicating when the dataset was last updated.
    public let LastUpdatedDate: String
    /// The collection of per-link traffic flow metrics.
    public let Value: [TrafficFlowMetrics]
    
}

/// Traffic flow metrics for a single road link in the dataset.
///
/// The property names mirror the API payload and are intentionally cased
/// to match the upstream keys.
///
/// Example decoding a single metric:
///
/// ```swift
/// let metric = metrics[0]
/// print(metric.RoadName)
/// ```
public struct TrafficFlowMetrics: Codable, Sendable {
    /// The unique identifier for the road link.
    public let LinkID: String
    /// The date the metric applies to, as provided by the API.
    public let Date: String
    /// The hour of the day for the observation, as provided by the API.
    public let HourOfDate: String
    /// The traffic volume for the link and hour.
    public let Volume: String
    /// The longitude of the link start coordinate.
    public let StartLon: String
    /// The latitude of the link start coordinate.
    public let StartLat: String
    /// The longitude of the link end coordinate.
    public let EndLon: String
    /// The latitude of the link end coordinate.
    public let EndLat: String
    /// The name of the road for the link.
    public let RoadName: String
    /// The road category for the link.
    public let RoadCat: String
    
}
