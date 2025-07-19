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



/// A structure representing a real-time traffic camera image and its metadata.
///
/// `TrafficImage` includes information about the camera's unique identifier, geographic location,
/// and a link to the associated image. It is typically used to display or process traffic camera images
/// for a given location.
///
/// Conforms to `Codable` for easy encoding and decoding to and from external data representations,
/// and `Identifiable` for use in lists and data collections.
///
/// - Properties:
///   - id: A unique identifier for the traffic camera, derived from `CameraID`. Used for identification in lists.
///   - CameraID: The unique string identifier of the traffic camera.
///   - Latitude: The latitude coordinate of the camera's physical location.
///   - Longitude: The longitude coordinate of the camera's physical location.
///   - ImageLink: A URL string pointing to the latest available image from this traffic camera.
///   - location: Returns a `CLLocation` instance representing the camera's physical location. Useful for distance and region calculations.
///   - coordinate2D: Returns a `CLLocationCoordinate2D` value for use with mapping frameworks.
public struct TrafficImage: Codable, Identifiable {
    
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
