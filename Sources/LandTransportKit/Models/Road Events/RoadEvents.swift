//
//  RoadEvents.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

/// A container for an array of `RoadEvent` events.
///
/// `RoadEvents` is used to decode and represent a list of road opening events as provided by the external data source.
/// Each event in the `value` array contains detailed information about a specific road opening/works, including timing, location, and responsible department.
///
/// - Properties:
///   - value: An array of `RoadEvent` items, each representing a scheduled or current road opening or road works event.
internal struct RoadEvents: Codable, Sendable {
    let value: [RoadEvent]
}

/// A structure representing a road opening event.
///
/// `RoadEvent` provides details about a scheduled or current road opening or road works, including
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
public struct RoadEvent: Codable, Sendable, Identifiable {
    
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
