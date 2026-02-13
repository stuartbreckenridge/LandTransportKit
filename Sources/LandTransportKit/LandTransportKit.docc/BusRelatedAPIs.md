# Bus Related APIs

@Metadata {
    @PageImage(purpose: icon, source: "bus.png")
    @PageColor(green)
}

Access bus arrival times, routes, services, and stop information.

## Overview

LandTransportKit provides comprehensive access to Singapore's bus network data through four main APIs:

| API | Method | Description |
|-----|--------|-------------|
| Bus Arrivals | ``LandTransportAPI/getBusArrivals(at:serviceNo:)`` | Real-time arrival times |
| Bus Routes | ``LandTransportAPI/downloadBusRoutes()`` | Complete route information |
| Bus Services | ``LandTransportAPI/downloadBusServices()`` | Service details and frequency |
| Bus Stops | ``LandTransportAPI/downloadBusStops()`` | All bus stop locations |

## Bus Arrivals

The bus arrivals API provides real-time estimated arrival times for buses at a specific stop.

### Basic Usage

```swift
import LandTransportKit

// Get arrivals for all services at a stop
let arrivals = try await LandTransportAPI.shared.getBusArrivals(at: "08057")

// Get arrivals for a specific service only
let service106 = try await LandTransportAPI.shared.getBusArrivals(at: "08057", serviceNo: "106")
```

### Working with Arrival Data

The ``BusArrivals`` response contains an array of ``Services-swift.struct`` objects, each representing a bus service at the stop:

```swift
@Observable
final class BusArrivalsViewModel {
    var arrivals: [Services] = []
    var isLoading = false
    var error: String?
    
    func loadArrivals(for stopCode: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await LandTransportAPI.shared.getBusArrivals(at: stopCode)
            arrivals = response.Services
        } catch let apiError as LandTransportAPIError {
            error = apiError.localizedDescription
        } catch {
            error = "Failed to load arrivals"
        }
    }
}
```

### Arrival Time Information

Each service provides up to three ``NextBus`` objects representing the next arriving buses:

```swift
let service = arrivals.Services.first!

// Next three buses
let nextBus = service.NextBus      // First arriving bus
let nextBus2 = service.NextBus2    // Second arriving bus
let nextBus3 = service.NextBus3    // Third arriving bus

// Get arrival time as Date
if let arrivalDate = nextBus.estimatedArrivalDate {
    let formatter = RelativeDateTimeFormatter()
    print("Arriving \(formatter.localizedString(for: arrivalDate, relativeTo: Date()))")
}

// Get bus location
if let location = nextBus.location {
    print("Bus is at: \(location.coordinate.latitude), \(location.coordinate.longitude)")
}

// Check bus load
print("Load: \(nextBus.Load)")  // "SEA" (Seats Available), "SDA" (Standing Available), "LSD" (Limited Standing)
```

## Bus Routes

The bus routes API returns the complete sequence of stops for every bus service.

### Downloading All Routes

```swift
let routes = try await LandTransportAPI.shared.downloadBusRoutes()

// Filter routes for a specific service
let service106Routes = routes.filter { $0.ServiceNo == "106" }

// Get stops in order for direction 1
let direction1Stops = service106Routes
    .filter { $0.Direction == 1 }
    .sorted { $0.StopSequence < $1.StopSequence }

for stop in direction1Stops {
    print("\(stop.StopSequence). \(stop.BusStopCode) - Distance: \(stop.Distance)km")
}
```

### Working with Timing Information

Each ``BusRoute`` includes first and last bus times:

```swift
let route = routes.first!

print("Weekday: \(route.WD_FirstBus) - \(route.WD_LastBus)")
print("Saturday: \(route.SAT_FirstBus) - \(route.SAT_LastBus)")
print("Sunday: \(route.SUN_FirstBus) - \(route.SUN_LastBus)")
```

### Planned Bus Routes

For upcoming route changes, use the planned routes API:

```swift
let plannedRoutes = try await LandTransportAPI.shared.downloadPlannedBusRoutes()

for route in plannedRoutes {
    print("Service \(route.ServiceNo) changes effective: \(route.EffectiveDate)")
}
```

## Bus Services

The bus services API provides details about each bus service including operator, category, and frequency.

### Downloading All Services

```swift
let services = try await LandTransportAPI.shared.downloadBusServices()

// Group by operator
let byOperator = Dictionary(grouping: services) { $0.Operator }
for (operator, operatorServices) in byOperator {
    print("\(operator): \(operatorServices.count) services")
}
```

### Service Details

```swift
let service = services.first { $0.ServiceNo == "106" && $0.Direction == 1 }!

print("Service: \(service.ServiceNo)")
print("Operator: \(service.Operator)")           // "SBST", "SMRT", etc.
print("Category: \(service.Category)")           // "TRUNK", "FEEDER", etc.
print("Origin: \(service.OriginCode)")
print("Destination: \(service.DestinationCode)")

// Frequency information
print("AM Peak: \(service.AM_Peak_Freq)")        // e.g., "08-12" (minutes)
print("AM Off-Peak: \(service.AM_Offpeak_Freq)")
print("PM Peak: \(service.PM_Peak_Freq)")
print("PM Off-Peak: \(service.PM_Offpeak_Freq)")
```

## Bus Stops

The bus stops API returns all bus stop locations in Singapore.

### Downloading All Stops

```swift
let stops = try await LandTransportAPI.shared.downloadBusStops()
print("Total stops: \(stops.count)")  // ~5000 stops
```

### Finding Nearby Stops

Use the built-in location properties to find stops near a location:

```swift
import CoreLocation

let userLocation = CLLocation(latitude: 1.3521, longitude: 103.8198)  // Singapore

let nearbyStops = stops.filter { stop in
    stop.location.distance(from: userLocation) <= 500  // Within 500 meters
}

for stop in nearbyStops.sorted(by: { $0.location.distance(from: userLocation) < $1.location.distance(from: userLocation) }) {
    let distance = stop.location.distance(from: userLocation)
    print("\(stop.Description) (\(stop.BusStopCode)) - \(Int(distance))m")
}
```

### Stop Details

```swift
let stop = stops.first { $0.BusStopCode == "08057" }!

print("Code: \(stop.BusStopCode)")
print("Name: \(stop.Description)")
print("Road: \(stop.RoadName)")

// Get coordinates
if let coordinate = stop.coordinate2D {
    print("Location: \(coordinate.latitude), \(coordinate.longitude)")
}
```

## Complete Example

Here's a complete SwiftUI view that displays bus arrivals with auto-refresh:

```swift
import SwiftUI
import LandTransportKit

struct BusStopView: View {
    let stopCode: String
    
    @State private var arrivals: BusArrivals?
    @State private var isLoading = false
    @State private var error: LandTransportAPIError?
    
    var body: some View {
        List {
            if let arrivals = arrivals {
                Section {
                    Text(arrivals.BusStopCode)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                ForEach(arrivals.Services) { service in
                    BusServiceRow(service: service)
                }
            }
        }
        .overlay {
            if isLoading && arrivals == nil {
                ProgressView()
            }
            
            if let error = error {
                ContentUnavailableView {
                    Label("Error", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(error.localizedDescription)
                } actions: {
                    Button("Retry") {
                        Task { await loadArrivals() }
                    }
                }
            }
        }
        .refreshable {
            await loadArrivals()
        }
        .task {
            await loadArrivals()
        }
        .task(id: "refresh") {
            // Auto-refresh every 30 seconds
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(30))
                await loadArrivals()
            }
        }
    }
    
    private func loadArrivals() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            arrivals = try await LandTransportAPI.shared.getBusArrivals(at: stopCode)
            error = nil
        } catch let apiError as LandTransportAPIError {
            error = apiError
        } catch {
            // Handle unexpected errors
        }
    }
}

struct BusServiceRow: View {
    let service: Services
    
    var body: some View {
        HStack {
            Text(service.ServiceNo)
                .font(.title2.bold())
                .frame(width: 60, alignment: .leading)
            
            Spacer()
            
            HStack(spacing: 16) {
                ArrivalBadge(nextBus: service.NextBus)
                ArrivalBadge(nextBus: service.NextBus2)
                ArrivalBadge(nextBus: service.NextBus3)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ArrivalBadge: View {
    let nextBus: NextBus
    
    var body: some View {
        if nextBus.EstimatedArrival.isEmpty {
            Text("--")
                .foregroundStyle(.secondary)
        } else if let minutes = nextBus.minutesToArrival {
            Text(minutes <= 0 ? "Arr" : "\(minutes)")
                .font(.callout.monospacedDigit())
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(loadColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
    
    private var loadColor: Color {
        switch nextBus.Load {
        case "SEA": return .green
        case "SDA": return .orange
        case "LSD": return .red
        default: return .gray
        }
    }
}
```

## Topics

### Models

- ``BusArrivals``
- ``Services-swift.struct``
- ``NextBus``
- ``BusService``
- ``BusRoute``
- ``PlannedBusRoute``
- ``BusStop``
