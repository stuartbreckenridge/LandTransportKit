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
    case busStops
    case passengerVolumeByBusStop
    case passengerVolumeByOriginDestinationBusStops
    case passengerVolumeByOriginDestinationTrainStation
    case passengerVolumeByTrainStation
    case taxiAvailability
    case taxiStands
    case trainServiceAlerts
    
    var url: URL {
        switch self {
        case .busArrivals:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/v3/BusArrival")!
        case .busServices:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/BusServices")!
        case .busRoutes:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/BusRoutes")!
        case .busStops:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/BusStops")!
        case .passengerVolumeByBusStop:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/Bus")!
        case .passengerVolumeByOriginDestinationBusStops:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/ODBus")!
        case .passengerVolumeByOriginDestinationTrainStation:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/ODTrain")!
        case .passengerVolumeByTrainStation:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/Train")!
        case .taxiAvailability:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/Taxi-Availability")!
        case .taxiStands:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/TaxiStands")!
        case .trainServiceAlerts:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/TrainServiceAlerts")!
        }
    }
}
