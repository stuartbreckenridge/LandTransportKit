//
//  TrainServiceAlert.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


internal struct TrainServiceAlerts: Codable, Sendable {
    var value: TrainServiceAlert
}


public struct TrainServiceAlert: Codable, Sendable {
    public let Status: Int
    public let AffectedSegments: [AffectedSegment]
    public let Message: [AlertMessage]
}

public struct AffectedSegment: Codable, Sendable {
    public let Line: String
    public let Direction: String
    public let Stations: String
    public let FreePublicBus: String
    public let FreeMRTShuttle: String
    public let MRTShuttleDirection: String
}


public struct AlertMessage: Codable, Sendable {
    public let Content: String
    public let CreatedDate: String
}
