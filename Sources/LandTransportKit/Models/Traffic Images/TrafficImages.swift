//
//  TrafficImages.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation
import CoreLocation

internal struct TrafficImages: Codable {
    let value: [TrafficImage]
}



/// A type that models a real-time traffic camera image and its associated metadata.
///
/// The `TrafficImage` structure provides a representation of a traffic camera,
/// including its unique identifier, geographic location, and a link to the most
/// recently available image from the camera. This type is suitable for use in
/// applications that display or process real-time traffic camera imagery.
///
/// - Note: This object conforms to `Codable`, enabling encoding and decoding
///   from JSON or similar representations. It also conforms to `Identifiable`
///   (using camera ID as its unique identifier) and `Sendable` for safe use
///   in concurrent contexts.
///
/// - Properties:
///   - id: A unique identifier for the traffic camera, derived from `CameraID`.
///   - CameraID: The unique string identifier of the traffic camera.
///   - Latitude: The latitude coordinate of the camera's physical location.
///   - Longitude: The longitude coordinate of the camera's physical location.
///   - ImageLink: A URL string pointing to the latest available image from this traffic camera.
///   - location: A computed property returning a `CLLocation` instance for the camera's location.
///   - coordinate2D: A computed property returning a `CLLocationCoordinate2D` for mapping frameworks.
///
/// - Usage:
///   Use `TrafficImage` to represent, display, or interact with
///   live traffic camera images and their metadata.
///
public struct TrafficImage: Codable, Identifiable, Sendable {
    
    public var id: String { CameraID }
    
    public let CameraID: String
    public let Latitude: Double
    public let Longitude: Double
    public let ImageLink: String
    
    public var location: CLLocation {
        CLLocation(latitude: Latitude, longitude: Longitude)
    }
    
    public var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
    }
    
    
}
