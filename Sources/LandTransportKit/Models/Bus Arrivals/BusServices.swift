//
//  BusServices.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 09/07/2025.
//

import Foundation

/// A structure representing a public transport bus service and its upcoming arrivals.
///
/// `Services` encapsulates key information about a bus service, including its unique service number,
/// operating company, and the details for the next three arriving buses at a specific stop.
///
/// - Properties:
///   - id: A unique identifier for the service, equivalent to the service number.
///   - ServiceNo: The unique identifier or route number for the bus service.
///   - Operator: The code or name of the operating company for this service.
///   - NextBus: Information about the next arriving bus for this service.
///   - NextBus2: Information about the second next arriving bus for this service.
///   - NextBus3: Information about the third next arriving bus for this service.
///
/// `Services` conforms to `Codable`, `Hashable`, `Equatable`, and `Identifiable` to enable easy encoding, comparison,
/// and use in collections.
///
/// Usage examples may include displaying upcoming bus arrivals at a stop, sorting services, or fetching and decoding
/// from a network API.
///
///  - seealso: ``LandTransportKit/NextBus``
public struct Services: Codable, Hashable, Equatable, Identifiable, Sendable {
    
    public var id: String {
        ServiceNo
    }
    
    public static func == (lhs: Services, rhs: Services) -> Bool {
        return lhs.ServiceNo == rhs.ServiceNo
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ServiceNo)
    }
    
    public let ServiceNo: String
    public let Operator: String
    public let NextBus: NextBus
    public let NextBus2: NextBus
    public let NextBus3: NextBus
    
    public init(ServiceNo: String, Operator: String, NextBus: NextBus, NextBus2: NextBus, NextBus3: NextBus) {
        self.ServiceNo = ServiceNo
        self.Operator = Operator
        self.NextBus = NextBus
        self.NextBus2 = NextBus2
        self.NextBus3 = NextBus3
    }
}
