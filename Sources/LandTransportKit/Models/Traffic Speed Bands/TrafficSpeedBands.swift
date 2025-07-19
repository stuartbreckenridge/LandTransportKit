//
//  TrafficSpeedBands.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation
import CoreLocation

internal struct TrafficSpeedBands: Codable {
    let value: [TrafficSpeedBand]
}


/// A data structure representing a band of traffic speed information for a specific road segment.
///
/// Each `TrafficSpeedBand` instance describes the traffic conditions for a unique road segment, identified by its `LinkID`.
/// It includes details such as the road name, category, speed band, speed range, and the start and end coordinates of the segment.
///
/// - Properties:
///   - id: A unique identifier for the road segment, derived from `LinkID`.
///   - LinkID: A unique identifier for the road segment.
///   - RoadName: The name of the road associated with this traffic speed band.
///   - RoadCategory: The category or classification of the road (e.g., expressway, arterial).
///   - SpeedBand: An integer representing the predefined speed band for the segment, typically assigned by the traffic data provider.
///   - MinimumSpeed: The minimum speed (in string format) for vehicles on this segment, as defined by the speed band.
///   - MaximumSpeed: The maximum speed (in string format) for vehicles on this segment, as defined by the speed band.
///   - StartLon: The longitude (in string format) for the starting point of the road segment.
///   - StartLat: The latitude (in string format) for the starting point of the road segment.
///   - EndLon: The longitude (in string format) for the ending point of the road segment.
///   - EndLat: The latitude (in string format) for the ending point of the road segment.
///
/// - Computed Properties:
///   - startCoordinate: The geographic coordinate (`CLLocationCoordinate2D`) representing the start location of the segment.
///   - endCoordinate: The geographic coordinate (`CLLocationCoordinate2D`) representing the end location of the segment.
///
/// `TrafficSpeedBand` conforms to `Codable`, `Identifiable`, and `Sendable` for easy encoding/decoding, unique identification, and concurrency safety.
///
/// Example usage:
/// ```swift
/// let band: TrafficSpeedBand = ...
/// let start = band.startCoordinate
/// let end = band.endCoordinate
/// let speedRange = "\(band.MinimumSpeed) - \(band.MaximumSpeed) km/h"
/// ```
public struct TrafficSpeedBand: Codable, Identifiable, Sendable {
    
    public var id: String { LinkID }
    
    public let LinkID: String
    public let RoadName: String
    public let RoadCategory: String
    public let SpeedBand: Int
    public let MinimumSpeed: String
    public let MaximumSpeed: String
    public let StartLon: String
    public let StartLat: String
    public let EndLon: String
    public let EndLat: String
    
    public var startCoordinate: CLLocationCoordinate2D {
        var lat = Double(StartLat)
        var lon = Double(StartLon)
        
        return CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
    }
    
    public var endCoordinate: CLLocationCoordinate2D {
        var lat = Double(EndLat)
        var lon = Double(EndLon)
        
        return CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
    }
    
    
}
