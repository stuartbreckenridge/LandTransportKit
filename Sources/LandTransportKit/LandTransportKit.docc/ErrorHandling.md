# Error Handling

@Metadata {
    @PageColor(red)
}

Handle errors gracefully when using LandTransportKit APIs.

## Overview

LandTransportKit provides a dedicated ``LandTransportAPIError`` enum for precise error handling. All API methods throw errors that can be caught and handled appropriately in your app.

## Error Types

The ``LandTransportAPIError`` enum includes the following cases:

| Error | Description |
|-------|-------------|
| ``LandTransportAPIError/noAPIKey`` | API key not configured |
| ``LandTransportAPIError/invalidURL`` | URL construction failed |
| ``LandTransportAPIError/rateLimited`` | Too many requests |
| ``LandTransportAPIError/httpError(statusCode:message:)`` | HTTP error response |
| ``LandTransportAPIError/decodingFailed(underlying:)`` | JSON decoding error |
| ``LandTransportAPIError/networkError(underlying:)`` | Network connectivity issue |
| ``LandTransportAPIError/missingDownloadLink`` | Download link not found |

## Basic Error Handling

Always wrap API calls in a do-catch block:

```swift
import LandTransportKit

func loadBusArrivals(stopCode: String) async {
    do {
        let arrivals = try await LandTransportAPI.shared.getBusArrivals(at: stopCode)
        // Handle success
        print("Found \(arrivals.Services.count) services")
    } catch {
        // Handle error
        print("Error: \(error.localizedDescription)")
    }
}
```

## Handling Specific Errors

For more granular error handling, catch specific ``LandTransportAPIError`` cases:

```swift
func loadData() async {
    do {
        let stops = try await LandTransportAPI.shared.downloadBusStops()
        // Success
    } catch LandTransportAPIError.noAPIKey {
        // API key not configured
        showAlert("Please configure your API key in Settings")
        
    } catch LandTransportAPIError.rateLimited {
        // Too many requests
        showAlert("Please wait a moment before trying again")
        
    } catch LandTransportAPIError.networkError(let urlError) {
        // Network issue
        if urlError.code == .notConnectedToInternet {
            showAlert("No internet connection")
        } else {
            showAlert("Network error: \(urlError.localizedDescription)")
        }
        
    } catch LandTransportAPIError.httpError(let statusCode, let message) {
        // HTTP error
        showAlert("Server error (\(statusCode)): \(message ?? "Unknown")")
        
    } catch LandTransportAPIError.decodingFailed(let decodingError) {
        // JSON parsing failed
        print("Decoding error: \(decodingError)")
        showAlert("Failed to parse server response")
        
    } catch {
        // Unexpected error
        showAlert("An unexpected error occurred")
    }
}
```

## No API Key Error

The ``LandTransportAPIError/noAPIKey`` error is thrown when you attempt to make an API call without first configuring your API key:

```swift
// This will throw LandTransportAPIError.noAPIKey
let stops = try await LandTransportAPI.shared.downloadBusStops()

// Fix: Configure the API key first
await LandTransportAPI.shared.configure(apiKey: "YOUR_API_KEY")
let stops = try await LandTransportAPI.shared.downloadBusStops()
```

### Best Practice

Configure your API key at app launch to avoid this error:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await LandTransportAPI.shared.configure(apiKey: Config.apiKey)
                }
        }
    }
}
```

## Rate Limiting

Some LTA APIs have rate limits. When you exceed the limit, the API returns a ``LandTransportAPIError/rateLimited`` error. This is particularly common with:

- Passenger Volume APIs
- Traffic Flow API

### Handling Rate Limits

```swift
func downloadWithRetry() async {
    var attempts = 0
    let maxAttempts = 3
    
    while attempts < maxAttempts {
        do {
            let data = try await LandTransportAPI.shared.downloadTrafficFlow()
            // Success
            return
        } catch LandTransportAPIError.rateLimited {
            attempts += 1
            if attempts < maxAttempts {
                // Wait before retrying (exponential backoff)
                let delay = UInt64(pow(2.0, Double(attempts))) * 1_000_000_000
                try? await Task.sleep(nanoseconds: delay)
            } else {
                showAlert("Service is busy. Please try again later.")
            }
        } catch {
            showAlert("Error: \(error.localizedDescription)")
            return
        }
    }
}
```

## Network Errors

Network errors occur when the device can't reach the server. The ``LandTransportAPIError/networkError(underlying:)`` case wraps the underlying `URLError`:

```swift
do {
    let taxis = try await LandTransportAPI.shared.downloadTaxiAvailability()
} catch LandTransportAPIError.networkError(let urlError) {
    switch urlError.code {
    case .notConnectedToInternet:
        showOfflineMessage()
    case .timedOut:
        showTimeoutMessage()
    case .cannotFindHost, .cannotConnectToHost:
        showServerUnreachableMessage()
    default:
        showGenericNetworkError()
    }
}
```

## HTTP Errors

HTTP errors indicate the server returned an error status code:

```swift
do {
    let alerts = try await LandTransportAPI.shared.downloadTrainServiceAlerts()
} catch LandTransportAPIError.httpError(let statusCode, let message) {
    switch statusCode {
    case 401:
        showAlert("Invalid API key")
    case 403:
        showAlert("Access forbidden")
    case 404:
        showAlert("Resource not found")
    case 500...599:
        showAlert("Server error. Please try again later.")
    default:
        showAlert("Error \(statusCode): \(message ?? "Unknown")")
    }
}
```

## Decoding Errors

Decoding errors occur when the API response doesn't match the expected format:

```swift
do {
    let stops = try await LandTransportAPI.shared.downloadBusStops()
} catch LandTransportAPIError.decodingFailed(let decodingError) {
    // Log the error for debugging
    print("Decoding failed: \(decodingError)")
    
    // Show user-friendly message
    showAlert("Unable to read data from server")
}
```

## SwiftUI Error Handling Pattern

Here's a recommended pattern for handling errors in SwiftUI views:

```swift
import SwiftUI
import LandTransportKit

struct DataView: View {
    @State private var data: [BusStop] = []
    @State private var error: LandTransportAPIError?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                ProgressView("Loading...")
            } else if let error = error {
                errorView(for: error)
            } else {
                dataList
            }
        }
        .task {
            await loadData()
        }
    }
    
    private var dataList: some View {
        List(data, id: \.id) { stop in
            Text(stop.Description)
        }
    }
    
    @ViewBuilder
    private func errorView(for error: LandTransportAPIError) -> some View {
        ContentUnavailableView {
            Label(errorTitle(for: error), systemImage: errorIcon(for: error))
        } description: {
            Text(error.localizedDescription)
        } actions: {
            Button("Try Again") {
                Task { await loadData() }
            }
        }
    }
    
    private func errorTitle(for error: LandTransportAPIError) -> String {
        switch error {
        case .noAPIKey:
            return "Not Configured"
        case .rateLimited:
            return "Too Many Requests"
        case .networkError:
            return "Connection Error"
        default:
            return "Error"
        }
    }
    
    private func errorIcon(for error: LandTransportAPIError) -> String {
        switch error {
        case .noAPIKey:
            return "key.slash"
        case .rateLimited:
            return "clock.badge.exclamationmark"
        case .networkError:
            return "wifi.slash"
        default:
            return "exclamationmark.triangle"
        }
    }
    
    private func loadData() async {
        isLoading = true
        error = nil
        defer { isLoading = false }
        
        do {
            data = try await LandTransportAPI.shared.downloadBusStops()
        } catch let apiError as LandTransportAPIError {
            error = apiError
        } catch {
            // Convert unexpected errors
            self.error = .networkError(underlying: URLError(.unknown))
        }
    }
}
```

## Error Logging

For production apps, consider logging errors for debugging:

```swift
import os.log

let logger = Logger(subsystem: "com.myapp", category: "API")

func loadData() async {
    do {
        let data = try await LandTransportAPI.shared.downloadBusStops()
        logger.info("Loaded \(data.count) bus stops")
    } catch let error as LandTransportAPIError {
        logger.error("API error: \(error.localizedDescription)")
        // Handle error...
    } catch {
        logger.error("Unexpected error: \(error.localizedDescription)")
        // Handle error...
    }
}
```

## Testing Error Handling

You can create a custom `LandTransportAPI` instance with a mock `URLSession` to test error handling:

```swift
import XCTest
@testable import LandTransportKit

class ErrorHandlingTests: XCTestCase {
    
    func testNoAPIKeyError() async {
        // Create an instance without configuring API key
        let api = LandTransportAPI(urlSession: URLSession.shared)
        
        do {
            _ = try await api.downloadBusStops()
            XCTFail("Expected noAPIKey error")
        } catch LandTransportAPIError.noAPIKey {
            // Expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
```

## Summary

Following these error handling practices ensures your app:

1. **Provides meaningful feedback** - Users understand what went wrong
2. **Handles edge cases** - Network issues, rate limits, etc.
3. **Fails gracefully** - App doesn't crash on errors
4. **Enables debugging** - Errors are logged for investigation

## Topics

### Error Types

- ``LandTransportAPIError``
- ``LandTransportAPIError/noAPIKey``
- ``LandTransportAPIError/invalidURL``
- ``LandTransportAPIError/rateLimited``
- ``LandTransportAPIError/httpError(statusCode:message:)``
- ``LandTransportAPIError/decodingFailed(underlying:)``
- ``LandTransportAPIError/networkError(underlying:)``
- ``LandTransportAPIError/missingDownloadLink``
