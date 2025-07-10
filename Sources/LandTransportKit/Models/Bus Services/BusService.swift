//
//  BusService.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 10/07/2025.
//

import Foundation


/// A collection of public bus services.
///
/// This structure represents the decoded result of a list of bus services, typically returned from a transport-related API.
/// Each element in the `value` array is a `BusService` containing detailed information about a specific bus route.
///
/// - Note: This type conforms to `Codable` and `Sendable`.
///
/// Example usage:
/// ```swift
/// let busServices: BusServices = // decoded from JSON
/// print(busServices.value.count)
/// ```
///
/// - SeeAlso: `BusService`
internal struct BusServices: Codable, Sendable {
    
    let value: [BusService]
    
}

/// A public bus service.
///
/// This structure encapsulates information about a specific bus route, including its service number, operator, direction, route category, origin and destination codes, as well as frequency details for different time periods. Each property corresponds to a field typically provided by the Land Transport API.
///
/// - Properties:
///   - ServiceNo: The unique identifier or number for the bus service.
///   - Operator: The name of the operating company or authority for the bus service.
///   - Direction: The direction or variant of the bus route (e.g., "1" for forward, "2" for return).
///   - Category: The category of the bus service (e.g., "TRUNK", "FEEDER").
///   - OriginCode: The code representing the starting bus stop of the service.
///   - DestinationCode: The code representing the final bus stop of the service.
///   - AM_Peak_Freq: The scheduled frequency of the service during the morning peak period.
///   - AM_Offpeak_Freq: The scheduled frequency during the morning off-peak period.
///   - PM_Peak_Freq: The scheduled frequency during the afternoon/evening peak period.
///   - PM_Offpeak_Freq: The scheduled frequency during the afternoon/evening off-peak period.
///   - LoopDesc: Description of the loop or deviation, if applicable; otherwise, an empty string.
///
/// - Note: This type conforms to `Codable` for encoding and decoding, and `Sendable` for safe use in concurrent contexts.
///
/// Example usage:
/// ```swift
/// let busService: BusService = // decoded from JSON
/// print(busService.ServiceNo)
/// ```
public struct BusService: Codable, Sendable, Identifiable {
    
    public var id: String { ServiceNo }
    
    let ServiceNo: String
    let `Operator`: String
    let Direction: String
    let Category: String
    let OriginCode: String
    let DestinationCode: String
    let AM_Peak_Freq: String
    let AM_Offpeak_Freq: String
    let PM_Peak_Freq: String
    let PM_Offpeak_Freq: String
    let LoopDesc: String
}
