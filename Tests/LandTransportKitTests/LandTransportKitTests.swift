//
//  LandTransportKitTests.swift
//  LandTransportKitTests
//
//  Created by Stuart Breckenridge on 30/06/2025.
//

import Testing
import Foundation
@testable import LandTransportKit

struct LandTransportKitTests {
    
    @Suite("Bus Arrival Tests") struct BusArrivalTests {
        
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
                    #expect(arrival.ServiceNo.count > 0)
                    #expect(arrival.Operator.count > 0)
                    if arrival.NextBus.DestinationCode != "" {
                        #expect(arrival.NextBus.EstimatedArrival.count > 0)
                        let formatter = ISO8601DateFormatter()
                        let date = formatter.date(from: arrival.NextBus.EstimatedArrival)
                        #expect(date != nil)
                        #expect(arrival.NextBus.Latitude.count > 0)
                        #expect(arrival.NextBus.Longitude.count > 0)
                        #expect(arrival.NextBus.DestinationCode.count > 0)
                        #expect(arrival.NextBus.Feature == "WAB" || arrival.NextBus.Feature == "")
                        #expect(arrival.NextBus.Monitored == 0 || arrival.NextBus.Monitored == 1)
                        #expect(arrival.NextBus.VisitNumber.count > 0)
                        #expect(arrival.NextBus.Type == "BD" || arrival.NextBus.Type == "DD" || arrival.NextBus.Type == "SD")
                        #expect(arrival.NextBus.coordinate != nil)
                        #expect(arrival.NextBus.coordinate2D != nil)
                        #expect(arrival.NextBus.Load == "LSD" || arrival.NextBus.Load == "SEA" || arrival.NextBus.Load == "SDA")
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
    
    @Suite("Bus Service Test") struct BusServiceTest {
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
        }
    }
    
    @Suite("Passenger Volume By Bus Stop Test")
    struct PassengerVolumeByBusStopTest {
        let api = LandTransportAPI.shared
        
        @Test("Set the API key")
        func setup() async {
            let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
            #expect(apiKey.count > 0)
            await api.configure(apiKey: apiKey)
        }
        
        @Test("Get Passenger Volume and Validate Zip filename")
        func getPassengerVolumeByBusStop() async throws {
            await setup()
            do  {
                let (data, filename) = try await api.downloadPassengerVolumeByBusStop()
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
    
}
