//
//  TaxiStands.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//


import Foundation
import CoreLocation


/// Represents a collection of taxi stand locations.
///
/// A `TaxiStands` instance encapsulates an array of `TaxiStand` objects,
/// each detailing information about individual taxi stands such as their
/// unique codes, geographic coordinates, accessibility status, and more.
/// This structure is typically used to decode responses from APIs providing
/// batch information about multiple taxi stands.
///
/// - Properties:
///   - value: An array of `TaxiStand` items, each representing a taxi stand's details.
internal struct TaxiStands: Codable, Sendable {
    let value: [TaxiStand]
}


/// Represents a taxi stand location with associated details.
///
/// A `TaxiStand` encapsulates information such as its unique code, name, geographic
/// location (latitude and longitude), accessibility status, ownership, and type.
///
/// - Properties:
///   - TaxiCode: The unique identifier for the taxi stand.
///   - Latitude: The latitude coordinate of the taxi stand.
///   - Longitude: The longitude coordinate of the taxi stand.
///   - Bfa: Barrier-Free Accessibility (BFA) indicator for the taxi stand.
///   - Ownership: The entity or organization that owns or manages the taxi stand.
///   - Type: The type or classification of the taxi stand.
///   - Name: The human-readable name of the taxi stand.
///   - location: A computed property returning the taxi stand's location as a `CLLocation`.
///   - coordinate2D: A computed property returning the taxi stand's coordinate as a `CLLocationCoordinate2D`.
public struct TaxiStand: Codable, Sendable {
    public let TaxiCode: String
    public let Latitude: Double
    public let Longitude: Double
    public let Bfa: String
    public let Ownership: String
    public let `Type`: String
    public let Name: String
    
    public var location: CLLocation {
        CLLocation(latitude: Latitude, longitude: Longitude)
    }
    
    public var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
    }
    
}
