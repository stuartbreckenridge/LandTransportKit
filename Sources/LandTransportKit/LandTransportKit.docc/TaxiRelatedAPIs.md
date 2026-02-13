# Taxi Related APIs

@Metadata {
    @PageColor(yellow)
}

Access real-time taxi availability and taxi stand locations.

## Overview

LandTransportKit provides two taxi-related APIs:

| API | Method | Description |
|-----|--------|-------------|
| Taxi Availability | ``LandTransportAPI/downloadTaxiAvailability()`` | Real-time locations of available taxis |
| Taxi Stands | ``LandTransportAPI/downloadTaxiStands()`` | All taxi stand locations |

## Taxi Availability

The taxi availability API returns the current locations of all available taxis in Singapore. This data is updated frequently and provides a real-time snapshot of taxi positions.

### Basic Usage

```swift
import LandTransportKit

let taxis = try await LandTransportAPI.shared.downloadTaxiAvailability()
print("Available taxis: \(taxis.count)")
```

### Finding Nearby Taxis

Use CoreLocation to find taxis near a specific location:

```swift
import CoreLocation
import LandTransportKit

func findNearbyTaxis(near location: CLLocation, radius: CLLocationDistance = 1000) async throws -> [TaxiAvailability] {
    let allTaxis = try await LandTransportAPI.shared.downloadTaxiAvailability()
    
    return allTaxis.filter { taxi in
        taxi.location.distance(from: location) <= radius
    }.sorted { taxi1, taxi2 in
        taxi1.location.distance(from: location) < taxi2.location.distance(from: location)
    }
}

// Usage
let myLocation = CLLocation(latitude: 1.2838, longitude: 103.8591) // Marina Bay
let nearbyTaxis = try await findNearbyTaxis(near: myLocation)
print("Found \(nearbyTaxis.count) taxis within 1km")
```

### Displaying Taxis on a Map

```swift
import SwiftUI
import MapKit
import LandTransportKit

struct TaxiMapView: View {
    @State private var taxis: [TaxiAvailability] = []
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    
    var body: some View {
        Map(position: $position) {
            ForEach(taxis, id: \.id) { taxi in
                Marker("Taxi", systemImage: "car.fill", coordinate: taxi.coordinate2D)
                    .tint(.yellow)
            }
        }
        .task {
            await loadTaxis()
        }
        .refreshable {
            await loadTaxis()
        }
    }
    
    private func loadTaxis() async {
        do {
            taxis = try await LandTransportAPI.shared.downloadTaxiAvailability()
        } catch {
            print("Error loading taxis: \(error)")
        }
    }
}
```

### Taxi Location Properties

Each ``TaxiAvailability`` object provides convenient location accessors:

```swift
let taxi = taxis.first!

// As CLLocation (useful for distance calculations)
let location = taxi.location
let distanceToMe = location.distance(from: myLocation)

// As CLLocationCoordinate2D (useful for MapKit)
let coordinate = taxi.coordinate2D
print("Taxi at: \(coordinate.latitude), \(coordinate.longitude)")

// Raw values
print("Latitude: \(taxi.Latitude)")
print("Longitude: \(taxi.Longitude)")
```

## Taxi Stands

The taxi stands API returns all official taxi stand locations in Singapore.

### Basic Usage

```swift
let stands = try await LandTransportAPI.shared.downloadTaxiStands()
print("Total taxi stands: \(stands.count)")
```

### Finding Nearby Stands

```swift
import CoreLocation

func findNearbyStands(near location: CLLocation, limit: Int = 5) async throws -> [TaxiStand] {
    let allStands = try await LandTransportAPI.shared.downloadTaxiStands()
    
    return allStands
        .sorted { stand1, stand2 in
            stand1.location.distance(from: location) < stand2.location.distance(from: location)
        }
        .prefix(limit)
        .map { $0 }
}
```

### Taxi Stand Details

```swift
let stand = stands.first!

print("Name: \(stand.Name)")
print("Type: \(stand.Type)")           // "Stand" or "Stop"
print("Owner: \(stand.Ownership)")     // "LTA" or other
print("Status: \(stand.Status)")       // "Yes" if operational

// Location
let coordinate = stand.coordinate2D
print("Location: \(coordinate.latitude), \(coordinate.longitude)")
```

### Filtering by Type

```swift
// Get only taxi stands (not stops)
let standsOnly = stands.filter { $0.Type == "Stand" }

// Get operational stands only
let operationalStands = stands.filter { $0.Status == "Yes" }
```

## Complete Example

Here's a complete SwiftUI view that shows nearby taxis and taxi stands:

```swift
import SwiftUI
import MapKit
import CoreLocation
import LandTransportKit

struct TaxiFinderView: View {
    @State private var taxis: [TaxiAvailability] = []
    @State private var stands: [TaxiStand] = []
    @State private var isLoading = false
    @State private var showStands = true
    @State private var showTaxis = true
    
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 1.2903, longitude: 103.8520),
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        )
    )
    
    var body: some View {
        Map(position: $position) {
            if showTaxis {
                ForEach(taxis, id: \.id) { taxi in
                    Marker("Available Taxi", systemImage: "car.fill", coordinate: taxi.coordinate2D)
                        .tint(.yellow)
                }
            }
            
            if showStands {
                ForEach(stands, id: \.id) { stand in
                    Marker(stand.Name, systemImage: "mappin", coordinate: stand.coordinate2D)
                        .tint(.blue)
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            VStack {
                Toggle("Taxis", isOn: $showTaxis)
                Toggle("Stands", isOn: $showStands)
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding()
        }
        .overlay(alignment: .bottom) {
            HStack {
                Label("\(taxis.count) taxis", systemImage: "car.fill")
                Spacer()
                Label("\(stands.count) stands", systemImage: "mappin")
            }
            .padding()
            .background(.regularMaterial)
        }
        .task {
            await loadData()
        }
        .refreshable {
            await loadData()
        }
    }
    
    private func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        async let taxiTask = LandTransportAPI.shared.downloadTaxiAvailability()
        async let standsTask = LandTransportAPI.shared.downloadTaxiStands()
        
        do {
            let (loadedTaxis, loadedStands) = try await (taxiTask, standsTask)
            taxis = loadedTaxis
            stands = loadedStands
        } catch {
            print("Error: \(error)")
        }
    }
}
```

## Topics

### Models

- ``TaxiAvailability``
- ``TaxiStand``
