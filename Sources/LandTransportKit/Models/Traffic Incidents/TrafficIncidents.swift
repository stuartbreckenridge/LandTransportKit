//
//  TrafficIncidents.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

internal struct TrafficIncidents: Codable {
    let value: [TrafficIncident]
}


public struct TrafficIncident: Codable, Identifiable {
    
    public var id: String { "\(Latitude)" + "_" + "\(Longitude)" + "_" + \(`Type`)"  }
    
    public let `Type`: String
    public let Latitude: Double
    public let Longitude: Double
    public let Message: String
    
}
