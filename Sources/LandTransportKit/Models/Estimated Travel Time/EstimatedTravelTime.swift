//
//  EstimatedTravelTime.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

internal struct EstimatedTravelTimes: Codable, Sendable {
    let value: [EstimatedTravelTime]
}


/// A model representing the estimated travel time for a specific route segment.
///
/// Use this structure to access information about the estimated travel duration between two points on a transport route.
///
/// - Parameters:
///   - Name: The name of the expressway (e.g. "AYE").
///   - Direction: The direction code associated with this segment (typically `1` for east-to-west, south-to-north, `2` for west-to-east, north-to-south).
///   - FarEndPoint: The final end point of this whole expressway in current direction of travel
///   - StartPoint: The starting location for this travel segment.
///   - EndPoint: The ending location for this travel segment.
///   - EstTime: The estimated travel time between `StartPoint` and `EndPoint`, in minutes.
public struct EstimatedTravelTime: Codable, Sendable {
    
    public let Name: String
    public let Direction: Int
    public let FarEndPoint: String
    public let StartPoint: String
    public let EndPoint: String
    public let EstTime: Int
    
}
