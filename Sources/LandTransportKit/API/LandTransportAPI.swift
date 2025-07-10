//
//  LandTransportAPI.swift
//  LandTransportAPI
//
//  Created by Stuart Breckenridge on 30/06/2025.
//

import Foundation

public actor LandTransportAPI {
    
    public static let shared = LandTransportAPI()
    
    /// The API key used for authenticating requests to the Land Transport API.
    ///
    /// - Note: This property is set by calling ``configure(apiKey:)``. It must be non-nil before making API requests that require authentication.
    /// - Important: Store the API key securely and avoid exposing it in client-side code or public repositories.
    internal var apiKey: String?
    
    
    /// Configures the LandTransportAPI instance with the provided API key.
    ///
    /// Call this method before making any API requests to ensure the API key is included in network calls.
    ///
    /// - Parameter apiKey: The API key string provided for authenticating requests to the Land Transport API.
    ///
    /// - Important: This method must be called before attempting to use other API functionality.
    public func configure(apiKey: String) async {
        self.apiKey = apiKey
    }
    
    private init() { }
    
    

    
    
}
