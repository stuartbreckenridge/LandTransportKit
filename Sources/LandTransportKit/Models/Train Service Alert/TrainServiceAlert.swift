//
//  TrainServiceAlert.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 13/07/2025.
//

import Foundation


/// Represents a container for train service alert information.
///
/// This struct is used to decode responses containing train service alert details,
/// encapsulating a single `TrainServiceAlert` as its value. It conforms to both `Codable`
/// and `Sendable` protocols for safe data transfer and concurrency support.
///
/// - Note: This type is intended for internal use within the module.
///
/// - Properties:
///   - value: The detailed train service alert, represented by a `TrainServiceAlert` object.
internal struct TrainServiceAlerts: Codable, Sendable {
    var value: TrainServiceAlert
}


/// Represents a train service alert with detailed information about affected segments and messages.
///
/// `TrainServiceAlert` is used to model the status of a train service, including which segments are affected
/// and any associated alert messages. It conforms to both `Codable` and `Sendable` protocols for safe decoding,
/// encoding, and concurrency support.
///
/// - Properties:
///   - Status: An integer indicating the current status of the train service (e.g.,  1 — normal, 2 — disrupted).
///   - AffectedSegments: An array of `AffectedSegment` objects that describe which parts of the train network are impacted.
///   - Message: An array of `AlertMessage` objects that provide additional details, explanations, or notices about the alert.
///
/// - Note:
///   This API relies on the static master list of Train Station Codes, Train Line Codes  and Train Shuttle
///   Service Direction which can be obtained on DataMall Portal. The Train Station Codes and Train Line Codes files are under Public Transport  section.  The Train Shuttle Service Direction information can be found in Train Line Codes  file.
///
///   During train unavailability, following attributes will be mandatory.
///     - Status
///     - Line in ``AffectedSegment``
///     - Direction in ``AffectedSegment``
///     - Stations in ``AffectedSegment``
///
///   Each line that is affected will be published as separate clusters within the single API response.
///   Refer to sample output in the [LTA User Guide](https://datamall.lta.gov.sg/content/dam/datamall/datasets/LTA_DataMall_API_User_Guide.pdf?ref=public_apis&utm_medium=website) Annex C for reference.
///
///   -  ^Free MRT Shuttle services will ferry commuters from station to station along the affected
///   stretch (see ``AffectedSegment/FreeMRTShuttle``).
///   - *There are scenarios which MRT Shuttle services do not run along the affected  stretch but along
///   four predefined areas in both directions (see ``AffectedSegment/MRTShuttleDirection``).
///     - Bouna Vista, Clementi, Jurong East and Boon Lay
///     - Woodlands, Yishun, Ang Mo Kio, Bishan
///     - Paya Lebar, Bedok, Tampines
///     - Jurong East, Choa Chu Kang
///     - “|” delimiter to denote an interchange station
///     - “;” delimiter to denote end of an area
public struct TrainServiceAlert: Codable, Sendable {
    public let Status: Int
    public let AffectedSegments: [AffectedSegment]
    public let Message: [AlertMessage]
}

/// Represents a segment of a train line affected by a service alert.
///
/// `AffectedSegment` models the specific details about a portion of the train network that is impacted by a service alert,
/// including line information, direction, and available alternative transport.
///
/// - Properties:
///   - Line: The name of the affected train line (e.g., "TEL")
///   - Direction: The direction of travel that is affected (e.g., "Both" or "towards <station_name>").
///   - Stations: A comma-separated list or range of station names that are affected within the segment.
///   - FreePublicBus: A comma-separated list indicating the list of affected stations where free boarding onto normal public bus services are available.
///   - FreeMRTShuttle: IA comma-separated list indicating the list of affected stations where free MRT shuttle servers are available.
///   - MRTShuttleDirection: The direction of the free MRT shuttle service, if available (e.g., "Both" or "towards <station_name>").
public struct AffectedSegment: Codable, Sendable {
    public let Line: String
    public let Direction: String
    public let Stations: String
    public let FreePublicBus: String
    public let FreeMRTShuttle: String
    public let MRTShuttleDirection: String
}


/// Represents a message associated with a train service alert.
///
/// `AlertMessage` models detailed explanations, notices, or updates regarding a train service disruption or alert.
/// Each message provides context or guidance to passengers, often including the time it was created.
///
/// - Properties:
///   - Content: The textual content of the alert message, providing details or instructions to passengers.
///   - CreatedDate: String representing the date and time the message was created.
public struct AlertMessage: Codable, Sendable {
    public let Content: String
    public let CreatedDate: String
}
