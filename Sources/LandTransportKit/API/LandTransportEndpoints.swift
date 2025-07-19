//
//  LandTransportEndpoints.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 09/07/2025.
//

import Foundation

enum LandTransportEndpoints {
    case bikeParking
    case busArrivals
    case busServices
    case busRoutes
    case busStops
    case carParkAvailability
    case estimatedTravelTime
    case facilitiesMaintenance
    case faultyTrafficLights
    case passengerVolumeByBusStop
    case passengerVolumeByOriginDestinationBusStops
    case passengerVolumeByOriginDestinationTrainStation
    case passengerVolumeByTrainStation
    case roadOpenings
    case roadWorks
    case stationCrowdDensityRealTime
    case stationCrowdDensityForecast
    case taxiAvailability
    case taxiStands
    case trainServiceAlerts
    case trafficImages
    case trafficIncidents
    case trafficSpeedBands
    case vms
    
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
        case .carParkAvailability:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/CarParkAvailabilityv2")!
        case .estimatedTravelTime:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/EstTravelTimes")!
        case .faultyTrafficLights:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/FaultyTrafficLights")!
        case .passengerVolumeByBusStop:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/Bus")!
        case .passengerVolumeByOriginDestinationBusStops:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/ODBus")!
        case .passengerVolumeByOriginDestinationTrainStation:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/ODTrain")!
        case .passengerVolumeByTrainStation:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PV/Train")!
        case .roadOpenings:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/RoadOpenings")!
        case .roadWorks:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/RoadWorks")!
        case .taxiAvailability:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/Taxi-Availability")!
        case .taxiStands:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/TaxiStands")!
        case .trainServiceAlerts:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/TrainServiceAlerts")!
        case .trafficImages:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/Traffic-Imagesv2")!
        case .trafficIncidents:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/TrafficIncidents")!
        case .trafficSpeedBands:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/v3/TrafficSpeedBands")!
        case .vms:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/VMS")!
        case .bikeParking:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/BicycleParkingv2")!
        case .facilitiesMaintenance:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/v2/FacilitiesMaintenance")!
        case .stationCrowdDensityRealTime:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PCDRealTime")!
        case .stationCrowdDensityForecast:
            return URL(string: "https://datamall2.mytransport.sg/ltaodataservice/PCDForecast")!
        }
    }
}
