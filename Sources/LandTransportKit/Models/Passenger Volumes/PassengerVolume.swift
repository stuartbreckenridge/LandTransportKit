//
//  PassengerVolume.swift
//  LandTransportKit
//
//  Created by Stuart Breckenridge on 11/07/2025.
//

import Foundation

/// A structure representing a passenger volume dataset, typically used for public transportation analytics.
/// 
/// This type is `Codable` and `Sendable`, making it suitable for use in concurrency contexts
/// and for serialization/deserialization from external data sources (such as JSON).
///
/// - Properties:
///   - value: An array of `DownloadLink` objects, each representing a downloadable resource
///            (such as a file or API endpoint) containing passenger volume information.
internal struct PassengerVolume: Codable, Sendable {
    let value: [DownloadLink]
}


/// A structure representing a downloadable resource link, commonly used in datasets to reference
/// files or API endpoints related to passenger volume or other analytics data.
///
/// This type is `Codable` and `Sendable`, enabling seamless use in concurrent tasks and
/// efficient serialization/deserialization with formats such as JSON.
///
/// - Properties:
///   - Link: A `String` containing the URL or endpoint of the downloadable resource. The property
///           name adheres to the external data source's field naming conventions.
internal struct DownloadLink: Codable, Sendable {
    let Link: String
}

