# Getting Started

Get up and running with LandTransportKit in your app.

@Metadata {
    @PageColor(blue)
}

## Overview

LandTransportKit provides access to Singapore's Land Transport Authority (LTA) DataMall API through the ``LandTransportAPI`` actor. This guide walks you through the initial setup and your first API call.

## Prerequisites

Before using LandTransportKit, you need to obtain an API key from the Land Transport Authority:

1. Visit the [LTA DataMall API Request Page](https://datamall.lta.gov.sg/content/datamall/en/request-for-api.html)
2. Fill out the registration form
3. You'll receive your API key via email

## Installation

Add LandTransportKit to your project using Swift Package Manager:

```swift
dependencies: [
    .package(url: "https://github.com/stuartbreckenridge/LandTransportKit.git", from: "0.9.0")
]
```

## Configuration

Configure the API with your key as early as possible during app launch, ideally in your `App` struct or `AppDelegate`.

### SwiftUI Example

```swift
import SwiftUI
import LandTransportKit

@main
struct MyTransportApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await LandTransportAPI.shared.configure(apiKey: "YOUR_API_KEY")
                }
        }
    }
}
```

### UIKit Example

```swift
import UIKit
import LandTransportKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Task {
            await LandTransportAPI.shared.configure(apiKey: "YOUR_API_KEY")
        }
        
        return true
    }
}
```

> Important: Never commit your API key to source control. Use environment variables, a secrets manager, or a configuration file excluded from version control.

## Making Your First Request

Once configured, you can start making API requests. Here's a complete example that fetches bus arrival times:

```swift
import SwiftUI
import LandTransportKit

struct BusArrivalsView: View {
    @State private var arrivals: BusArrivals?
    @State private var errorMessage: String?
    
    let busStopCode = "08057"  // Orchard Blvd
    
    var body: some View {
        List {
            if let arrivals = arrivals {
                ForEach(arrivals.Services) { service in
                    HStack {
                        Text("Bus \(service.ServiceNo)")
                            .font(.headline)
                        Spacer()
                        if let minutes = service.NextBus.minutesToArrival {
                            Text("\(minutes) min")
                        } else {
                            Text("--")
                        }
                    }
                }
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else {
                ProgressView("Loading...")
            }
        }
        .navigationTitle("Bus Arrivals")
        .task {
            await loadArrivals()
        }
    }
    
    private func loadArrivals() async {
        do {
            arrivals = try await LandTransportAPI.shared.getBusArrivals(at: busStopCode)
        } catch let error as LandTransportAPIError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }
    }
}
```

## Error Handling

LandTransportKit uses a dedicated ``LandTransportAPIError`` enum for error handling. Always handle potential errors when making API calls:

```swift
do {
    let stops = try await LandTransportAPI.shared.downloadBusStops()
    // Use stops...
} catch LandTransportAPIError.noAPIKey {
    // API key not configured - call configure(apiKey:) first
} catch LandTransportAPIError.rateLimited {
    // Too many requests - wait before retrying
} catch LandTransportAPIError.networkError(let underlying) {
    // Network issue - check connectivity
    print("Network error: \(underlying.localizedDescription)")
} catch {
    // Other errors
    print("Error: \(error.localizedDescription)")
}
```

For more details on error handling, see <doc:ErrorHandling>.

## Next Steps

Now that you're set up, explore the specific API categories:

- <doc:BusRelatedAPIs> - Bus arrivals, routes, services, and stops
- <doc:TaxiRelatedAPIs> - Taxi availability and stands
- <doc:TrafficRelatedAPIs> - Traffic images, incidents, and speed bands
- <doc:TrainRelatedAPIs> - Train service alerts and station crowd density
- <doc:FacilitiesAPIs> - Car parks, bike parking, and more
