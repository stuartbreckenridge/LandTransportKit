//
//  TrafficIncidents.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

internal struct TrafficIncidents: Codable {
    let value: [TrafficIncident]
}


/// A structure representing a single traffic incident reported by Land Transport.
/// 
/// This structure conforms to `Codable`, `Identifiable`, and `Sendable`, and is used to
/// encapsulate information about a reported traffic incident, including its type, location, and description.
///
/// - Properties:
///   - id: A unique identifier for the incident, composed of its latitude and longitude.
///   - Type: The category or nature of the traffic incident (e.g., accident, roadwork).
///   - Latitude: The geographical latitude where the incident occurred.
///   - Longitude: The geographical longitude where the incident occurred.
///   - Message: A descriptive message providing details about the incident.
///
public struct TrafficIncident: Codable, Identifiable, Sendable {
    
    public var id: String { "\(Latitude)" + "_" + "\(Longitude)" }
    
    public let `Type`: String
    public let Latitude: Double
    public let Longitude: Double
    public let Message: String
    
}
