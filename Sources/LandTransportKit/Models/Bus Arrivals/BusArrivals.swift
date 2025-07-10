//
//  BusArrivals.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 30/06/2025.
//

import Foundation

/// A structure representing bus arrival information for a specific bus stop.
///
/// `BusArrivals` encapsulates the bus stop code and a list of services providing arrival information
/// for each service at the specified stop. This structure is commonly used to parse and represent
/// data the bus arrival API.
///
/// - Parameters:
///   - BusStopCode: The unique identifier for the bus stop.
///   - Services: An array of `Services` representing the individual bus services and their arrival details for this stop.
///
/// Example usage:
/// ```swift
/// let arrivals = BusArrivals(BusStopCode: "12345", Services: [/* ... */])
/// ```
/// - seealso: ``LandTransportKit/Services``
public struct BusArrivals: Codable, Sendable {
    
    public let BusStopCode: String
    public let Services: [Services]

}




