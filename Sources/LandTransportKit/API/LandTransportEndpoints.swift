//
//  LandTransportEndpoints.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 09/07/2025.
//

import Foundation

enum LandTransportEndpoints {
    case busArrivals
    case busServices
    case busRoutes
    
    var url: URL {
        switch self {
        case .busArrivals:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/v3/BusArrival")!
        case .busServices:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/BusServices")!
        case .busRoutes:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/BusRoutes")!
        }
    }
}
