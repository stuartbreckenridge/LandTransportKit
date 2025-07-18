//
//  FaultyTrafficLights.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation

internal struct FaultyTrafficLights: Codable, Sendable {
    let value: [FaultyTrafficLight]
}


/// A representation of a single faulty traffic light event as reported by the system.
///
/// `FaultyTrafficLight` includes details about a particular incident or scheduled maintenance
/// affecting a traffic light. All properties are mapped from remote data and represented as strings,
/// with computed properties for conversion and classification.
///
/// - Properties:
///   - AlarmID: The unique identifier for the specific alarm or event.
///   - NodeID: The identifier of the node (traffic light) affected.
///   - Type: The type or category of the fault (e.g., "4" — Blackout, "13" — Flashing Yellow).
///   - StartDate: The date and time when the fault or maintenance started, as a string in "YYYY-MM-DD HH:MM:SS.ms" format (Asia/Singapore time zone).
///   - EndDate: The date and time when the fault or maintenance ended (for maintenance), as a string in "YYYY-MM-DD HH:MM:SS.ms" format (Asia/Singapore time zone). If empty, indicates an ongoing incident.
///   - Message: A human-readable description of the fault or scheduled maintenance.
///
/// - Computed Properties:
///   - iso8601StartDate: The parsed start date as a `Date` object, or `nil` if unavailable or invalid.
///   - iso8601EndDate: The parsed end date as a `Date` object, or `nil` if unavailable or invalid.
///   - isScheduledMaintenance: Returns `true` if the incident is a scheduled maintenance (based on whether `EndDate` is not empty), or `false` otherwise.
///
///  - Note: Not all `Type`s of incident are documented. The API may return "2" for `Type` but the `Message` returned will be `(13/7)11:03 Black Out at Woodlands Avenue 6/Woodlands Drive 65 Junction.`
public struct FaultyTrafficLight: Codable, Sendable {
    public  let AlarmID: String
    public  let NodeID: String
    public  let `Type`: String
    public  let StartDate: String
    public  let EndDate: String
    public  let Message: String
    
    public var iso8601StartDate: Date? {
        if StartDate.isEmpty {
            return nil
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
            formatter.timeZone = TimeZone(identifier: "Asia/Singapore")
            return formatter.date(from: StartDate)
        }
    }
    
    public var iso8601EndDate: Date? {
        if EndDate.isEmpty {
            return nil
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
            formatter.timeZone = TimeZone(identifier: "Asia/Singapore")
            return formatter.date(from: EndDate)
        }
    }
    
    public var isScheduledMaintenance: Bool {
        return !EndDate.isEmpty
    }
    
}
