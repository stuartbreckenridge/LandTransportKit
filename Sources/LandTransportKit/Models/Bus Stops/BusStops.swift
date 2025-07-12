//
//  BusStops.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation
import CoreLocation

/// Represents a collection of bus stop locations.
/// 
/// This structure encapsulates a list of individual `BusStop` entries,
/// each containing identifying and descriptive information about a specific bus stop.
/// 
/// - Properties:
///   - stops: An array of `BusStop` representing the locations included in this set.
internal struct BusStops: Codable, Sendable {
    public let value: [BusStop]
}


/// Represents a single bus stop location, containing identifying and descriptive information.
///
/// Use this structure to store and convey the details of a bus stop, such as its unique code,
/// road location, descriptive name, and geographical coordinates.
///
/// - Properties:
///   - BusStopCode: The unique identifier assigned to this bus stop (e.g., "01012").
///   - RoadName: The name of the road where the bus stop is situated (e.g., "Orchard Road").
///   - Description: A short name or description of the bus stop (e.g., "Lucky Plaza").
///   - Latitude: The latitude coordinate of the bus stop's location.
///   - Longitude: The longitude coordinate of the bus stop's location.
///   - location: Returns the location as a `CLLocation` object.
///   - coordinate2D: Returns the location as a `CLLocationCoordinate2D` value.
public struct BusStop: Codable, Sendable {
    
    let BusStopCode: String
    let RoadName: String
    let `Description`: String
    let Latitude: Double
    let Longitude: Double
    
    var location: CLLocation {
        return CLLocation(latitude: Latitude, longitude: Longitude)
    }
    
    var coordinate2D: CLLocationCoordinate2D? {
        return CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
    }
    
}
