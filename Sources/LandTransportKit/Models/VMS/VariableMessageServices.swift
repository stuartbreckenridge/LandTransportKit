//
//  VariableMessageServices.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation
import CoreLocation

internal struct VariableMessageServices: Codable {
    var value: [TrafficAdvisoryMessage]
}

public struct TrafficAdvisoryMessage: Codable, Identifiable, Sendable {
    
    public var id: String { EquipmentID }
    
    public let EquipmentID: String
    public let Latitude: Double
    public let Longitude: Double
    public let Message: String
    
    public var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: Latitude, longitude: Longitude)
    }
    
    public var location: CLLocation {
        CLLocation(latitude: Latitude, longitude: Longitude)
    }
    
    
}
