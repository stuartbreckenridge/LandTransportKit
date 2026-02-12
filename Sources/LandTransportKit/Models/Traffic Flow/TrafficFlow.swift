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
