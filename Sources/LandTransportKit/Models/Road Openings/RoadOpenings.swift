//
//  RoadOpenings.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

/// A container for an array of `RoadOpening` events.
/// 
/// `RoadOpenings` is used to decode and represent a list of road opening events as provided by the external data source.
/// Each event in the `value` array contains detailed information about a specific road opening, including timing, location, and responsible department.
/// 
/// - Properties:
///   - value: An array of `RoadOpening` items, each representing a scheduled or current road opening event.
internal struct RoadOpenings: Codable, Sendable {
    let value: [RoadOpening]
}

/// A structure representing a road opening event.
///
/// `RoadOpening` provides details about a scheduled or current road opening, including
/// event identifiers, date range, responsible department, affected road, and additional information.
///
/// - Note: All properties mirror the fields provided by the external data source.
///
/// - Properties:
///   - id: The unique identifier for the event. Derived from `EventID`.
///   - EventID: The unique event identifier as provided by the source.
///   - StartDate: The start date of the road opening event, formatted as a string.
///   - EndDate: The end date of the road opening event, formatted as a string.
///   - SvcDept: Department or company performing this road work
///   - RoadName: The name of the road affected by the opening.
///   - Other: Additional details or notes about the event.
public struct RoadOpening: Codable, Sendable, Identifiable {
    
    public var id: String {
        EventID
    }
    
    public let EventID: String
    public let StartDate: String
    public let EndDate: String
    public let SvcDept: String
    public let RoadName: String
    public let Other: String
}
