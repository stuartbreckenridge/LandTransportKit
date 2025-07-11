//
//  PassengerVolumeByBusStop.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation

internal struct PassengerVolumeByBusStop: Codable, Sendable {
    let value: [DownloadLink]
}


internal struct DownloadLink: Codable, Sendable {
    
    let Link: String
    
}

