//
//  FacilitiesMaintenance.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 19/07/2025.
//

import Foundation

internal struct FacilitiesMaintenance: Codable {
    let value: [LiftMaintenance]
}


/// Represents the maintenance status of a lift at a train station.
///
/// `LiftMaintenance` provides information about a specific lift at a particular station,
/// including its line, unique identifiers, and description. 
/// This struct is typically used to track maintenance activities or provide 
/// up-to-date lift information to end users.
///
/// - Note: The `id` property is a combination of the `StationCode` and `LiftDesc`.
///
/// Properties:
///   - Line: The train line on which the station is located.
///   - StationCode: The unique code identifying the station.
///   - StationName: The full name of the station.
///   - LiftID: The unique identifier for the lift at this station.
///   - LiftDesc: A description of the lift, often indicating its location or purpose.
///
/// - Warning: `LiftID` is not guaranteed to be populated.
public struct LiftMaintenance: Codable, Sendable, Identifiable {
    
    public var id: String { StationCode + "_" + LiftDesc }
    
    public let Line: String
    public let StationCode: String
    public let StationName: String
    public let LiftID: String
    public let LiftDesc: String
    
}
