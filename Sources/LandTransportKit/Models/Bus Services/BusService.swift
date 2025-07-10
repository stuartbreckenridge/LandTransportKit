//
//  BusService.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 10/07/2025.
//

import Foundation

/// A representation of a public bus service.
///
/// `BusService` contains key information about a specific bus route, including its operator,
/// direction, category, origin and destination, and frequency details for peak and off-peak times.
///
/// - Properties:
///   - id: A unique identifier for the bus service, using the service number.
///   - ServiceNo: The service number identifying the bus route.
///   - Operator: The operator responsible for running the bus service.
///   - Direction: The direction of the service (e.g., 1 or 2).
///   - Category: The category of the service (e.g., "Express", "Trunk").
///   - OriginCode: The code representing the starting point of the service.
///   - DestinationCode: The code representing the end point of the service.
///   - AM_Peak_Freq: The service frequency during the morning peak period (typically in minutes).
///   - AM_Offpeak_Freq: The frequency during the morning off-peak period.
///   - PM_Peak_Freq: The frequency during the evening peak period.
///   - PM_Offpeak_Freq: The frequency during the evening off-peak period.
///   - LoopDesc: A description of the loop, if the service operates in a loop.
public struct BusService: Codable, Sendable {
    
    var id: String { ServiceNo }
    
    let ServiceNo: String
    let `Operator`: String
    let Direction: String
    let Category: String
    let OriginCode: String
    let DestinationCode: String
    let AM_Peak_Freq: String
    let AM_Offpeak_Freq: String
    let PM_Peak_Freq: String
    let PM_Offpeak_Freq: String
    let LoopDesc: String
    
}
