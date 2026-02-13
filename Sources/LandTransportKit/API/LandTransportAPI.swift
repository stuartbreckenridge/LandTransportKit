//
//  LandTransportAPI.swift
//  LandTransportAPI
//
//  Created by Stuart Breckenridge on 30/06/2025.
//

import Foundation
import os.log

// MARK: - Constants

/// Internal constants used throughout the LandTransportKit API.
internal enum APIConstants {
    /// The HTTP header field name for the API key.
    static let accountKeyHeader = "AccountKey"
    
    /// The number of records returned per page by paginated endpoints.
    static let paginationLimit = 500
    
    /// The query parameter name for pagination offset.
    static let skipParameter = "$skip"
}

// MARK: - Error Types

/// Errors that can occur when using the LandTransportKit API.
///
/// Use this enum to handle specific error conditions when making API requests.
/// Each case provides detailed information about what went wrong.
public enum LandTransportAPIError: LocalizedError, Sendable {
    /// The API key has not been configured. Call ``LandTransportAPI/configure(apiKey:)`` before making requests.
    case noAPIKey
    
    /// The URL could not be constructed from the provided parameters.
    case invalidURL
    
    /// The API request was rate limited. Wait before retrying.
    case rateLimited
    
    /// The HTTP response indicated an error.
    /// - Parameters:
    ///   - statusCode: The HTTP status code returned by the server.
    ///   - message: An optional message describing the error.
    case httpError(statusCode: Int, message: String?)
    
    /// The response data could not be decoded.
    /// - Parameter underlying: The underlying decoding error.
    case decodingFailed(underlying: DecodingError)
    
    /// A network error occurred.
    /// - Parameter underlying: The underlying URL error.
    case networkError(underlying: URLError)
    
    /// The expected download link was not found in the API response.
    case missingDownloadLink
    
    public var errorDescription: String? {
        switch self {
        case .noAPIKey:
            return "API key not configured. Call configure(apiKey:) before making requests."
        case .invalidURL:
            return "Failed to construct a valid URL for the request."
        case .rateLimited:
            return "The API request was rate limited. Please wait before retrying."
        case .httpError(let statusCode, let message):
            if let message = message {
                return "HTTP error \(statusCode): \(message)"
            }
            return "HTTP error \(statusCode)"
        case .decodingFailed(let underlying):
            return "Failed to decode response: \(underlying.localizedDescription)"
        case .networkError(let underlying):
            return "Network error: \(underlying.localizedDescription)"
        case .missingDownloadLink:
            return "The expected download link was not found in the API response."
        }
    }
}

// MARK: - LandTransportAPI

public actor LandTransportAPI {
    
    public static let shared = LandTransportAPI()
    
    /// The API key used for authenticating requests to the Land Transport API.
    ///
    /// - Note: This property is set by calling ``configure(apiKey:)``. It must be non-nil before making API requests that require authentication.
    /// - Important: Store the API key securely and avoid exposing it in client-side code or public repositories.
    internal var apiKey: String?
    
    /// The URL session used for making network requests.
    ///
    /// By default, this uses `URLSession.shared`. You can provide a custom session
    /// for testing or to configure custom timeout/cache policies.
    internal let urlSession: URLSession
    
    /// Logger for debugging API operations.
    private let logger = Logger(subsystem: "com.landtransport.kit", category: "API")
    
    /// Configures the LandTransportAPI instance with the provided API key.
    ///
    /// Call this method before making any API requests to ensure the API key is included in network calls.
    ///
    /// - Parameter apiKey: The API key string provided for authenticating requests to the Land Transport API.
    ///
    /// - Important: This method must be called before attempting to use other API functionality.
    public func configure(apiKey: String) async {
        self.apiKey = apiKey
        logger.debug("API key configured")
    }
    
    private init() {
        self.urlSession = URLSession.shared
    }
    
    /// Creates a new LandTransportAPI instance with a custom URL session.
    ///
    /// Use this initializer for testing or when you need custom network configuration.
    ///
    /// - Parameter urlSession: The URL session to use for network requests.
    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // MARK: - Internal Helpers
    
    /// Validates that the API key has been configured.
    ///
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not set.
    /// - Returns: The configured API key.
    internal func validateAPIKey() throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty else {
            logger.error("API key not configured")
            throw LandTransportAPIError.noAPIKey
        }
        return apiKey
    }
    
    /// Creates an authenticated URL request for the given URL.
    ///
    /// - Parameter url: The URL for the request.
    /// - Throws: ``LandTransportAPIError/noAPIKey`` if the API key is not set.
    /// - Returns: A configured URLRequest with the API key header.
    internal func authenticatedRequest(for url: URL) throws -> URLRequest {
        let key = try validateAPIKey()
        var request = URLRequest(url: url)
        request.addValue(key, forHTTPHeaderField: APIConstants.accountKeyHeader)
        return request
    }
    
    /// Checks the HTTP response for errors and rate limiting.
    ///
    /// - Parameter response: The URL response to check.
    /// - Throws: ``LandTransportAPIError/rateLimited`` or ``LandTransportAPIError/httpError(statusCode:message:)`` if applicable.
    internal func checkResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 500:
            // LTA API returns 500 for rate limiting
            logger.warning("Rate limited by API")
            throw LandTransportAPIError.rateLimited
        default:
            logger.error("HTTP error: \(httpResponse.statusCode)")
            throw LandTransportAPIError.httpError(statusCode: httpResponse.statusCode, message: nil)
        }
    }
    
    /// Performs a network request and decodes the response.
    ///
    /// - Parameters:
    ///   - request: The URL request to perform.
    ///   - type: The type to decode the response into.
    /// - Throws: ``LandTransportAPIError`` for various failure conditions.
    /// - Returns: The decoded response.
    internal func performRequest<T: Decodable>(_ request: URLRequest, decoding type: T.Type) async throws -> T {
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch let error as URLError {
            logger.error("Network error: \(error.localizedDescription)")
            throw LandTransportAPIError.networkError(underlying: error)
        }
        
        try checkResponse(response)
        
        do {
            return try JSONDecoder().decode(type, from: data)
        } catch let error as DecodingError {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw LandTransportAPIError.decodingFailed(underlying: error)
        }
    }
    
    /// Downloads paginated data from an endpoint using iterative requests.
    ///
    /// This method fetches data in batches and accumulates results until all pages are retrieved.
    /// It uses an iterative approach to avoid potential stack overflow with recursive calls.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint to fetch data from.
    ///   - wrapperType: The wrapper type that contains the `value` array.
    ///   - valueKeyPath: The key path to extract the array from the wrapper.
    /// - Throws: ``LandTransportAPIError`` for various failure conditions.
    /// - Returns: An array of all items from all pages.
    internal func downloadPaginatedData<Wrapper: Decodable, Item>(
        from endpoint: LandTransportEndpoints,
        wrapperType: Wrapper.Type,
        valueKeyPath: KeyPath<Wrapper, [Item]>
    ) async throws -> [Item] {
        var allItems: [Item] = []
        var skip = 0
        
        while true {
            var urlComponents = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = [URLQueryItem(name: APIConstants.skipParameter, value: String(skip))]
            
            guard let url = urlComponents?.url else {
                throw LandTransportAPIError.invalidURL
            }
            
            let request = try authenticatedRequest(for: url)
            let wrapper = try await performRequest(request, decoding: wrapperType)
            let items = wrapper[keyPath: valueKeyPath]
            
            allItems.append(contentsOf: items)
            logger.debug("Downloaded \(items.count) items (total: \(allItems.count))")
            
            if items.count < APIConstants.paginationLimit {
                break
            }
            
            skip += APIConstants.paginationLimit
        }
        
        return allItems
    }
}
