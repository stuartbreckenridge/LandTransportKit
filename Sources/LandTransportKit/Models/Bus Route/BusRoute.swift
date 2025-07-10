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


/// A struct representing a single bus route stop entry as returned from the Land Transport Authority (LTA) API.
///
/// - Parameters:
///   - ServiceNo: The unique identifier for the bus service number (e.g., "12", "NR7").
///   - Operator: The code of the bus service operator (e.g., "SBST", "SMRT").
///   - Direction: The direction of the bus route (typically 1 or 2 for two-way routes).
///   - StopSequence: The position of the stop in the route sequence (starting from 1).
///   - BusStopCode: The unique code for the bus stop.
///   - Distance: The distance (in kilometers) from the starting point to this stop.
///   - WD_FirstBus: The scheduled first bus departure time on weekdays (format: "HHMM", e.g., "0600").
///   - WD_LastBus: The scheduled last bus departure time on weekdays (format: "HHMM", e.g., "2330").
///   - SAT_FirstBus: The scheduled first bus departure time on Saturdays.
///   - SAT_LastBus: The scheduled last bus departure time on Saturdays.
///   - SUN_FirstBus: The scheduled first bus departure time on Sundays and public holidays.
///   - SUN_LastBus: The scheduled last bus departure time on Sundays and public holidays.
public struct BusRoute: Codable, Sendable {
    
    let ServiceNo: String
    let `Operator`: String
    let Direction: Int
    let StopSequence: Int
    let BusStopCode: String
    let Distance: Double
    let WD_FirstBus: String
    let WD_LastBus: String
    let SAT_FirstBus: String
    let SAT_LastBus: String
    let SUN_FirstBus: String
    let SUN_LastBus: String
    
}
