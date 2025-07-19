//
//  BikeParking.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation
import CoreLocation

internal struct BikeParking: Codable {
    let value: [BikePark]
}


/// A structure representing a bike parking location, including descriptive and geospatial information.
///
/// `BikePark` provides location and property details for a specific public bike parking station.
/// It supports unique identification via its description, geographic location access, and relevant metadata.
///
/// - Properties:
///   - id: The unique identifier for the bike park, derived from its `Description`.
///   - Description: A user-friendly description or name of the bike park.
///   - Latitude: The latitude coordinate of the bike park.
///   - Longitude: The longitude coordinate of the bike park.
///   - RackType: The type of bike rack available at the location.
///   - RackCount: The total number of racks at the location.
///   - ShelterIndicator: Describes whether the bike park is sheltered.
///   - coordinate2D: The Core Location coordinate (latitude/longitude) of the bike park.
///   - location: The full Core Location `CLLocation` of the bike park.
///
/// `BikePark` conforms to `Codable` for easy parsing from data, `Sendable` for concurrency safety,
/// and `Identifiable` for use in lists or UI frameworks.
public struct BikePark: Codable, Sendable, Identifiable {
    
    public var id: String { Description }
    
    public let `Description`: String
    public let Latitude: Double
    public let Longitude: Double
    public let RackType: String
    public let RackCount: Int
    public let ShelterIndicator: String
    
    public var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
    }
    
    public var location: CLLocation {
        CLLocation(latitude: Latitude, longitude: Longitude)
    }
    
}
