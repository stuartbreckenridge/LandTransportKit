//
//  BusRoute.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation

/// A struct representing a collection of bus routes as returned by the Land Transport Authority (LTA) API.
///
/// - Parameters:
///   - value: An array of `BusRoute` entries, where each entry contains details of a specific bus route stop, including service number, operator, direction, stop sequence, and scheduled bus timings.
internal struct BusRoutes: Codable, Sendable {
    
    let value: [BusRoute]
    
}

/// A struct representing a collection of planned bus routes as returned by the Land Transport Authority (LTA) API.
///
/// - Parameters:
///   - value: An array of `PlannedBusRoute` entries, where each entry contains details for a specific planned bus route stop, including service number, operator, direction, stop sequence, scheduled bus timings, and the effective date for the planned change.
///
/// - Note: The data in this struct typically represents upcoming or future changes to bus routes, and is to be used for planned route information only.
internal struct PlannedBusRoutes: Codable, Sendable {
    
    let value: [PlannedBusRoute]
    
}


/// A struct representing a single bus route stop entry as returned from the Land Transport Authority (LTA) API.
///
/// - Parameters:
///   - ServiceNo: The unique identifier for the bus service number (e.g., "12", "NR7").
///   - Operator: The code of the bus service operator (e.g., "SBST", "SMRT").
///   - Direction: The direction in which the bus travels (1 or 2), loop services only have 1 direction.
///   - StopSequence: The position of the stop in the route sequence (starting from 1).
///   - BusStopCode: The unique code for the bus stop.
///   - Distance: The distance (in kilometers) from the starting point to this stop.
///   - WD_FirstBus: The scheduled first bus departure time on weekdays (format: "HHMM", e.g., "0600").
///   - WD_LastBus: The scheduled last bus departure time on weekdays (format: "HHMM", e.g., "2330").
///   - SAT_FirstBus: The scheduled first bus departure time on Saturdays.
///   - SAT_LastBus: The scheduled last bus departure time on Saturdays.
///   - SUN_FirstBus: The scheduled first bus departure time on Sundays and public holidays.
///   - SUN_LastBus: The scheduled last bus departure time on Sundays and public holidays.
public struct BusRoute: Codable, Sendable, Identifiable {
    
    public var id: String {
        "\(ServiceNo)-\(BusStopCode)-\(Direction)"
    }
    
    public let ServiceNo: String
    public let `Operator`: String
    public let Direction: Int
    public let StopSequence: Int
    public let BusStopCode: String
    public let Distance: Double
    public let WD_FirstBus: String
    public let WD_LastBus: String
    public let SAT_FirstBus: String
    public let SAT_LastBus: String
    public let SUN_FirstBus: String
    public let SUN_LastBus: String
    
}



/// A struct representing a single planned bus route stop entry as returned from the Land Transport Authority (LTA) API, typically used for upcoming or future route changes.
///
/// - Parameters:
///   - ServiceNo: The unique identifier for the bus service number (e.g., "12", "NR7").
///   - Operator: The code of the bus service operator (e.g., "SBST", "SMRT").
///   - Direction: The direction in which the bus travels (1 or 2), loop services only have 1 direction.
///   - StopSequence: The position of the stop in the route sequence (starting from 1).
///   - BusStopCode: The unique code for the bus stop.
///   - Distance: The distance (in kilometers) from the starting point to this stop.
///   - WD_FirstBus: The scheduled first bus departure time on weekdays (format: "HHMM", e.g., "0600").
///   - WD_LastBus: The scheduled last bus departure time on weekdays (format: "HHMM", e.g., "2330").
///   - SAT_FirstBus: The scheduled first bus departure time on Saturdays.
///   - SAT_LastBus: The scheduled last bus departure time on Saturdays.
///   - SUN_FirstBus: The scheduled first bus departure time on Sundays and public holidays.
///   - SUN_LastBus: The scheduled last bus departure time on Sundays and public holidays.
///   - EffectiveDate: The date from which this planned route entry becomes active (format: "YYYY-MM-DD").
///
/// - Note: Data to be released only ON/AFTER the Effective Date.
public struct PlannedBusRoute: Codable, Sendable, Identifiable {
    
    public var id: String {
        "\(ServiceNo)-\(BusStopCode)-\(Direction)"
    }
    
    public let ServiceNo: String
    public let `Operator`: String
    public let Direction: Int
    public let StopSequence: Int
    public let BusStopCode: String
    public let Distance: Double
    public let WD_FirstBus: String
    public let WD_LastBus: String
    public let SAT_FirstBus: String
    public let SAT_LastBus: String
    public let SUN_FirstBus: String
    public let SUN_LastBus: String
    public let EffectiveDate: String
}
