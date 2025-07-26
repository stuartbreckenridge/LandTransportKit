//
//  NextBus.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 09/07/2025.
//

import Foundation
import CoreLocation

/// Represents the next arriving bus's predicted details.
///
/// `NextBus` contains information about an upcoming bus service, including its current location,
/// estimated time of arrival, and operational characteristics.
///
/// - Note: This structure is used to reflect the state of a real-time public bus as reported by the API.
///
/// Properties:
/// - `OriginCode`: The code identifying the bus's origin stop.
/// - `DestinationCode`: The code identifying the bus's destination stop.
/// - `EstimatedArrival`: The predicted arrival time at the queried stop, formatted as an ISO 8601 string.
/// - `Latitude`: The latitude of the bus's real-time position.
/// - `Longitude`: The longitude of the bus's real-time position.
/// - `VisitNumber`: The number of stops the bus has visited on its route (as a string).
/// - `Load`: A string describing the current occupancy level of the bus (e.g., "SEA" for seats available, "SDA" for standing available, "LSD" for limited standing).
/// - `Feature`: Describes special features of the bus (e.g., "WAB" for wheelchair-accessible bus).
/// - `Type`: The type of bus (e.g., "SD" for single deck, "DD" for double deck, "BD" for bendy).
/// - `Monitored`: Indicates whether the bus is currently being monitored in real-time (1 for yes, 0 for no (arrival estimate is based on schedule)).
///
/// Computed Properties:
/// - `location`: The bus's location as a `CLLocation` object.
/// - `coordinate2D`: The bus's location as a `CLLocationCoordinate2D` value.
public struct NextBus: Codable, Sendable, Identifiable {
    
    public var id = UUID()
    
    public let OriginCode: String
    public let DestinationCode: String
    public let EstimatedArrival: String
    public let Latitude: String
    public let Longitude: String
    public let VisitNumber: String
    public let Load: String
    public let Feature: String
    public let `Type`: String
    public let Monitored: Int
    
    public var location: CLLocation? {
        if let lat = Double(Latitude), let lon = Double(Longitude) {
            return CLLocation(latitude: lat, longitude: lon)
        }
        return nil
    }
    
    public var coordinate2D: CLLocationCoordinate2D? {
        if let lat = Double(Latitude), let lon = Double(Longitude) {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        return nil
    }

}
