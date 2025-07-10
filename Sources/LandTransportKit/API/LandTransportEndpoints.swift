//
//  LandTransportEndpoints.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 09/07/2025.
//

import Foundation

enum LandTransportEndpoints {
    case busArrivals
    
    var url: URL {
        switch self {
        case .busArrivals:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/v3/BusArrival")!
        }
    }
}
