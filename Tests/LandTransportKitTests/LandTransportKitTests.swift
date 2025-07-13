//
//  LandTransportKitTests.swift
//  LandTransportKitTests
//
//  Created by Stuart Breckenridge on 30/06/2025.
//

import Testing
import Foundation
import CoreLocation
@testable import LandTransportKit

struct LandTransportKitTests {
    
    @Suite("Bus Arrival Tests")
    struct BusArrivalTests {
        
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Tests retrieval of bus arrivals for a specific stop.")
        func busArrival() async {
            await setup()
            do {
                let arrivals = try await api.getBusArrivals(at: "08057")
                #expect(arrivals.Services.count >= 0)
                if arrivals.Services.count > 0 {
                    let arrival = arrivals.Services[0]
                    #expect(arrival.id == arrival.ServiceNo)
                    
                    if !arrival.NextBus.EstimatedArrival.isEmpty {
                        if let coord = arrival.NextBus.coordinate2D {
                            #expect(coord.latitude == Double(arrival.NextBus.Latitude))
                            #expect(coord.longitude == Double(arrival.NextBus.Longitude))
                        }
                        
                        if let location = arrival.NextBus.location {
                            #expect(location.coordinate.latitude == Double(arrival.NextBus.Latitude))
                            #expect(location.coordinate.longitude == Double(arrival.NextBus.Longitude))
                        }
                    }
                }
            } catch {
                #expect(Bool(false), "Unexpected error: \(error)")
            }
        }
        
        @Test("Test retrieval of bus arrivals for a specific stop and service.")
        func busArrivalWithServiceID() async {
            await setup()
            do {
                let arrivals = try await api.getBusArrivals(at: "08057", serviceNo: "106")
                #expect(arrivals.Services.count >= 0)
                if arrivals.Services.count > 0 {
                    #expect(arrivals.Services[0].ServiceNo == "106")
                }
            } catch {
                #expect(Bool(false), "Unexpected error: \(error)")
            }
        }
        
    }
    
    @Suite("Bus Service Test")
    struct BusServiceTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Bus Services")
        func getBusServices() async throws {
            await setup()
            let services = try await api.downloadBusServices()
            #expect(services.count > 0)
        }
        
    }
    
    @Suite("Bus Route Test")
    struct BusRouteTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Bus Routes")
        func getBusRoutes() async throws {
            await setup()
            let routes = try await api.downloadBusRoutes()
            #expect(routes.count > 0)
        }
    }
    
    @Suite("Bus Stop Test")
    struct BusStopTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Bus Stops")
        func getBusStops() async throws {
            await setup()
            let stops = try await api.downloadBusStops()
            #expect(stops.count > 0)
            let stop = stops[0]
            #expect(stop.coordinate2D?.latitude == stop.Latitude)
            #expect(stop.coordinate2D?.longitude == stop.Longitude)
            #expect(stop.location.coordinate.latitude == stop.Latitude)
            #expect(stop.location.coordinate.longitude == stop.Longitude)
        }
    }
    
    @Suite("Passenger Volume Tests")
    struct PassengerVolumeTests {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get passenger volume by bus stop, validate file name.")
        func getPassengerVolumeByBusStop() async throws {
            await setup()
            do  {
                let (_, filename) = try await api.downloadPassengerVolumeByBusStop()
                #expect(filename.hasSuffix(".zip"))
            } catch (let e as URLError) {
                if e.userInfo["Reason"] as! String == "Rate Limited" {
                    print("Let this pass due to rate limiting.")
                }
            } catch {
                #expect(Bool(false))
            }
        }
        
        @Test("Get passenger volume by origin/destination bus stop, validate file name.")
        func getPassengerVolumeByOriginDestinationBusStop() async throws {
            await setup()
            do  {
                let (_, filename) = try await api.downloadPassengerVolumeByOriginDestinationBusStop()
                #expect(filename.hasSuffix(".zip"))
            } catch (let e as URLError) {
                if e.userInfo["Reason"] as! String == "Rate Limited" {
                    print("Let this pass due to rate limiting.")
                }
            } catch {
                #expect(Bool(false))
            }
        }
        
        @Test("Get passenger volume by train station, validate file name.")
        func getPassengerVolumeByTrainStation() async throws {
            await setup()
            do  {
                let (_, filename) = try await api.downloadPassengerVolumeByTrainStation()
                #expect(filename.hasSuffix(".zip"))
            } catch (let e as URLError) {
                if e.userInfo["Reason"] as! String == "Rate Limited" {
                    print("Let this pass due to rate limiting.")
                }
            } catch {
                #expect(Bool(false))
            }
        }
        
        @Test("Get passenger volume by origin/destination train station, validate file name.")
        func getPassengerVolumeByOriginDestinationTrainStation() async throws {
            await setup()
            do  {
                let (_, filename) = try await api.downloadPassengerVolumeByOriginDestinationTrainStation()
                #expect(filename.hasSuffix(".zip"))
            } catch (let e as URLError) {
                if e.userInfo["Reason"] as! String == "Rate Limited" {
                    print("Let this pass due to rate limiting.")
                }
            } catch {
                #expect(Bool(false))
            }
        }
        
    }
    
    @Suite("Taxi Tests")
    struct TaxiAvailabiltyTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Available Taxis")
        func getAvailableTaxis() async throws {
            await setup()
            let taxis = try await api.downloadTaxiAvailability()
            #expect(taxis.count > 0)
            let taxi = taxis.first!
            #expect(taxi.coordinate2D.latitude == taxi.Latitude)
            #expect(taxi.coordinate2D.longitude == taxi.Longitude)
            #expect(taxi.location.coordinate.latitude == taxi.Latitude)
            #expect(taxi.location.coordinate.longitude == taxi.Longitude)
        }
        
        @Test("Get Taxi Stands")
        func getTaxiStands() async throws {
            await setup()
            let stands = try await api.downloadTaxiStands()
            #expect(stands.count > 0)
            let stand = stands.first!
            #expect(stand.coordinate2D.latitude == stand.Latitude)
            #expect(stand.coordinate2D.longitude == stand.Longitude)
            #expect(stand.location.coordinate.latitude == stand.Latitude)
            #expect(stand.location.coordinate.longitude == stand.Longitude)
        }
        
    }
    
    @Suite("Train Tests")
    struct TrainServiceTests {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Train Service Stats")
        func getTrainServiceAlerts() async throws {
            await setup()
            let alert = try await api.downloadTrainServiceAlerts()
            #expect(alert.Status == 1 || alert.Status == 2)
        }
        
    }
    
    @Suite("Car Park Tests")
    struct CarParkTests {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Car Park Availability")
        func getCarParkAvailability() async throws {
            await setup()
            let carparks = try await api.downloadCarParkAvailability()
            #expect(carparks.count > 0)
            carparks.forEach { cp in
                #expect(cp.coordinate != nil)
            }
        }
        
    }
    
    @Suite("Estimated Travel Time")
    struct TravelTimeTests {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Travel Time Estimate Tests")
        func getTravelTime() async throws {
            await setup()
            let times = try await api.downloadEstimatedTravelTimes()
            #expect(times.count > 0)
        }
        
    }
    
    @Suite("Faulty Traffic Lights")
    struct TrafficLightTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Traffic Light Tests")
        func getFaultyTrafficLight() async throws {
            await setup()
            let faults = try await api.downloadFaultyTrafficLights()
            #expect(faults.count >= 0)
            if faults.count > 0 {
                let fault = faults[0]
                if fault.StartDate.isEmpty {
                    #expect(fault.iso8601StartDate == nil)
                } else {
                    #expect(fault.iso8601StartDate != nil)
                }
                if fault.EndDate.isEmpty {
                    #expect(fault.iso8601EndDate == nil)
                } else {
                    #expect(fault.iso8601EndDate != nil)
                }
                if fault.EndDate.isEmpty {
                    #expect(fault.isScheduledMaintenance == false)
                } else {
                    #expect(fault.isScheduledMaintenance == true)
                }
            }
        }
        
    }
    
    @Suite("Road Openings Tests")
    struct RoadOpeningsTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Road Openings Test")
        func getRoadOpening() async throws {
            await setup()
            let openings = try await api.downloadRoadOpenings()
            #expect(openings.count >= 0)
            let opening = openings[0]
            #expect(opening.id == opening.EventID)
        }
        
    }
     
}
