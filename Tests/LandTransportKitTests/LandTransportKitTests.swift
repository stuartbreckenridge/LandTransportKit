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
        
        @Test("Tests retrieval of bus arrivals for a specific stop")
        func busArrival() async {
            await setup()
            do {
                let arrivals = try await api.getBusArrivals(at: "08057")
                #expect(arrivals.Services.isEmpty == false)
            } catch {
                #expect(Bool(false), "Unexpected error: \(error)")
            }
            
        }
        
    }
    
}
