//
//  CarParkAvailability.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation
import CoreLocation


/// A structure representing a collection of car park availability data.
///
/// `CarParkAvailability` acts as a container for a list of `CarPark` items,
/// each of which provides information about a specific car park's availability
/// and metadata. This structure is  used as a response model when
/// decoding availability information from the Land Transport Authority API.
///
/// - Properties:
///   - value: An array of `CarPark` instances, each detailing the status and metadata for a car park.
internal struct CarParkAvailability: Codable, Sendable {
    let value: [CarPark]
}


/// A structure representing the availability details and metadata of a specific car park.
///
/// `CarPark` contains identifying and descriptive information about a car park,
/// such as its unique identifier, area, development name, geographic location,
/// number of available lots, lot type, and the managing agency.
///
/// - Properties:
///   - CarParkID: A unique string identifier for the car park.
///   - Area: The district or region where the car park is located.
///   - Development: The development or property name associated with the car park.
///   - Location: A string containing the latitude and longitude (separated by a space) of the car park.
///   - AvailableLots: The current number of available parking lots.
///   - LotType: The type of parking lots available (e.g., "C" for car, "Y" for Motorcycles, "H" for Heavy Vehicles.).
///   - Agency: The agency or organization managing the car park.
///   - coordinate: The computed coordinate (`CLLocationCoordinate2D`) derived from the `Location` property, or `nil` if parsing fails.
///
public struct CarPark: Codable, Sendable {
    
    public let CarParkID: String
    public let Area: String
    public let Development: String
    public let Location: String
    public let AvailableLots: Int
    public let LotType: String
    public let Agency: String
    
    public var coordinate: CLLocationCoordinate2D? {
        guard let latitide = Double(Location.split(separator: " ").first ?? ""), let longitude = Double(Location.split(separator: " ").last ?? "") else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitide, longitude: longitude)
    }
}
