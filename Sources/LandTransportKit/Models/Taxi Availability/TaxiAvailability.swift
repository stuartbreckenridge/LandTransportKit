//
//  TaxiAvailability.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 12/07/2025.
//

import Foundation
import CoreLocation

internal struct Taxis: Codable, Sendable {
    let value: [TaxiAvailability]
}


/// A structure representing the availability and location of a single taxi.
///
/// Use this type to describe the latitude and longitude coordinates of taxis retrieved from the taxi availability endpoint.
/// Conforms to both `Codable` for easy encoding/decoding and `Sendable` for concurrency safety.
///
/// - Properties:
///   - Latitude: The latitude coordinate of the taxi.
///   - Longitude: The longitude coordinate of the taxi.
///
/// - Computed Properties:
///   - coordinate2D: A `CLLocationCoordinate2D` value representing the taxi's location.
///   - location: A `CLLocation` object representing the taxi's geographic position.
public struct TaxiAvailability: Codable, Sendable {
    
    public let Latitude: Double
    public let Longitude: Double
    
    public var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
    }
    
    public var location: CLLocation {
        CLLocation(latitude: Latitude, longitude: Longitude)
    }

}
