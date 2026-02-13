# Facilities & Other APIs

@Metadata {
    @PageColor(teal)
}

Access car park availability, bike parking, travel times, and more.

## Overview

LandTransportKit provides access to various facility and utility APIs:

| API | Method | Description |
|-----|--------|-------------|
| Car Park Availability | ``LandTransportAPI/downloadCarParkAvailability()`` | Real-time parking lot counts |
| Bike Parking | ``LandTransportAPI/getBikeParks(near:long:radius:)`` | Bicycle parking locations |
| Estimated Travel Time | ``LandTransportAPI/downloadEstimatedTravelTimes()`` | Highway travel times |
| Faulty Traffic Lights | ``LandTransportAPI/downloadFaultyTrafficLights()`` | Traffic light issues |
| Road Events | ``LandTransportAPI/downloadRoadOpenings()`` / ``LandTransportAPI/downloadRoadWorks()`` | Road works and openings |
| Facilities Maintenance | ``LandTransportAPI/downloadFacilitiesMaintenance()`` | Lift maintenance info |
| Passenger Volume | Various methods | Historical ridership data |

## Car Park Availability

The car park availability API provides real-time information about parking lot availability across Singapore.

### Basic Usage

```swift
import LandTransportKit

let carParks = try await LandTransportAPI.shared.downloadCarParkAvailability()
print("Total car parks: \(carParks.count)")
```

> Note: This is a paginated endpoint. The API automatically fetches all pages.

### Car Park Details

```swift
let carPark = carParks.first!

print("ID: \(carPark.CarParkID)")
print("Area: \(carPark.Area)")
print("Development: \(carPark.Development)")
print("Available Lots: \(carPark.AvailableLots)")
print("Lot Type: \(carPark.LotType)")   // "C" = Cars, "Y" = Motorcycles, "H" = Heavy Vehicles
print("Agency: \(carPark.Agency)")      // "HDB", "LTA", "URA"

// Get location
if let coordinate = carPark.coordinate {
    print("Location: \(coordinate.latitude), \(coordinate.longitude)")
}
```

### Finding Nearby Car Parks

```swift
import CoreLocation

func findNearbyCarParks(near location: CLLocation, radius: CLLocationDistance = 500) async throws -> [CarPark] {
    let allCarParks = try await LandTransportAPI.shared.downloadCarParkAvailability()
    
    return allCarParks
        .filter { carPark in
            guard let coordinate = carPark.coordinate else { return false }
            let carParkLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            return carParkLocation.distance(from: location) <= radius
        }
        .sorted { cp1, cp2 in
            guard let coord1 = cp1.coordinate, let coord2 = cp2.coordinate else { return false }
            let loc1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
            let loc2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
            return loc1.distance(from: location) < loc2.distance(from: location)
        }
}
```

### Filtering by Lot Type

```swift
// Get car parks with car lots
let carLots = carParks.filter { $0.LotType == "C" }

// Get car parks with motorcycle lots
let motorcycleLots = carParks.filter { $0.LotType == "Y" }

// Get car parks with available spaces
let availableParks = carParks.filter { $0.AvailableLots > 0 }
```

### Car Park Availability View

```swift
import SwiftUI
import LandTransportKit

struct CarParkListView: View {
    @State private var carParks: [CarPark] = []
    @State private var searchText = ""
    @State private var isLoading = false
    
    var filteredCarParks: [CarPark] {
        if searchText.isEmpty {
            return carParks
        }
        return carParks.filter {
            $0.Development.localizedCaseInsensitiveContains(searchText) ||
            $0.Area.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredCarParks, id: \.id) { carPark in
                HStack {
                    VStack(alignment: .leading) {
                        Text(carPark.Development)
                            .font(.headline)
                        Text(carPark.Area)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(carPark.AvailableLots)")
                            .font(.title2.bold())
                            .foregroundStyle(availabilityColor(carPark.AvailableLots))
                        Text("lots")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search car parks")
            .navigationTitle("Car Parks")
            .refreshable {
                await loadCarParks()
            }
            .task {
                await loadCarParks()
            }
        }
    }
    
    private func availabilityColor(_ lots: Int) -> Color {
        switch lots {
        case 0: return .red
        case 1...10: return .orange
        case 11...50: return .yellow
        default: return .green
        }
    }
    
    private func loadCarParks() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            carParks = try await LandTransportAPI.shared.downloadCarParkAvailability()
        } catch {
            print("Error: \(error)")
        }
    }
}
```

## Bike Parking

The bike parking API returns bicycle parking locations near a specified coordinate.

### Basic Usage

```swift
// Find bike parking within 500m of a location
let bikeParks = try await LandTransportAPI.shared.getBikeParks(
    near: 1.3521,      // latitude
    long: 103.8198,    // longitude
    radius: 0.5        // radius in km (default)
)
```

### Bike Park Details

```swift
let bikePark = bikeParks.first!

print("Description: \(bikePark.Description)")
print("Rack Type: \(bikePark.RackType)")
print("Rack Count: \(bikePark.RackCount)")
print("Shelter: \(bikePark.ShelterIndicator)")

// Location
let location = bikePark.location
print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
```

### Finding Bike Parking Near MRT Stations

```swift
import CoreLocation

// Example: Find bike parking near Orchard MRT
let orchardMRT = CLLocationCoordinate2D(latitude: 1.3039, longitude: 103.8318)

let nearbyBikeParks = try await LandTransportAPI.shared.getBikeParks(
    near: orchardMRT.latitude,
    long: orchardMRT.longitude,
    radius: 0.3  // 300 meters
)

for park in nearbyBikeParks {
    print("\(park.Description): \(park.RackCount) racks")
}
```

## Estimated Travel Time

The estimated travel time API provides current travel times for major expressway routes.

### Basic Usage

```swift
let travelTimes = try await LandTransportAPI.shared.downloadEstimatedTravelTimes()

for route in travelTimes {
    print("\(route.Name): \(route.EstTime) minutes")
}
```

### Travel Time Details

```swift
let route = travelTimes.first!

print("Route: \(route.Name)")
print("Direction: \(route.Direction)")
print("Far End Point: \(route.FarEndPoint)")
print("Estimated Time: \(route.EstTime) minutes")
```

### Travel Time Display

```swift
import SwiftUI
import LandTransportKit

struct TravelTimesView: View {
    @State private var travelTimes: [EstimatedTravelTime] = []
    
    var body: some View {
        List(travelTimes, id: \.id) { route in
            HStack {
                VStack(alignment: .leading) {
                    Text(route.Name)
                        .font(.headline)
                    Text("To \(route.FarEndPoint)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(route.EstTime) min")
                    .font(.title3.monospacedDigit())
                    .foregroundStyle(.blue)
            }
        }
        .navigationTitle("Travel Times")
        .task {
            do {
                travelTimes = try await LandTransportAPI.shared.downloadEstimatedTravelTimes()
            } catch {
                print("Error: \(error)")
            }
        }
    }
}
```

## Faulty Traffic Lights

The faulty traffic lights API reports current traffic light malfunctions and scheduled maintenance.

### Basic Usage

```swift
let faults = try await LandTransportAPI.shared.downloadFaultyTrafficLights()

for fault in faults {
    print("\(fault.AlarmID): \(fault.TechnicalAlarmType) at \(fault.NodeID)")
}
```

### Fault Details

```swift
let fault = faults.first!

print("Alarm ID: \(fault.AlarmID)")
print("Node ID: \(fault.NodeID)")
print("Type: \(fault.TechnicalAlarmType)")
print("Start Date: \(fault.StartDate)")
print("End Date: \(fault.EndDate)")
print("Message: \(fault.Message)")

// Check if this is scheduled maintenance
if fault.isScheduledMaintenance {
    print("This is scheduled maintenance")
}

// Get dates as Date objects
if let startDate = fault.iso8601StartDate {
    print("Started: \(startDate)")
}
```

## Road Events

The road events APIs provide information about road openings and road works.

### Road Openings

```swift
let openings = try await LandTransportAPI.shared.downloadRoadOpenings()

for opening in openings {
    print("Event: \(opening.EventID)")
    print("Start: \(opening.StartDate)")
    print("End: \(opening.EndDate)")
}
```

### Road Works

```swift
let works = try await LandTransportAPI.shared.downloadRoadWorks()

for work in works {
    print("Event: \(work.EventID)")
    print("Road: \(work.RoadName)")
    print("Other: \(work.Other)")
}
```

## Facilities Maintenance

The facilities maintenance API provides information about lift maintenance at transport facilities.

### Basic Usage

```swift
let maintenance = try await LandTransportAPI.shared.downloadFacilitiesMaintenance()

for item in maintenance {
    print("Station: \(item.Station)")
    print("Building: \(item.Building)")
}
```

## Passenger Volume Data

The passenger volume APIs provide historical ridership data. These return ZIP files containing CSV data.

> Warning: These endpoints are rate-limited. Excessive requests will result in a ``LandTransportAPIError/rateLimited`` error.

### Available Endpoints

```swift
// Bus passenger volume by stop
let (busStopData, filename1) = try await LandTransportAPI.shared.downloadPassengerVolumeByBusStop()

// Bus passenger volume by origin-destination
let (odBusData, filename2) = try await LandTransportAPI.shared.downloadPassengerVolumeByOriginDestinationBusStop()

// Train passenger volume by station
let (trainStationData, filename3) = try await LandTransportAPI.shared.downloadPassengerVolumeByTrainStation()

// Train passenger volume by origin-destination
let (odTrainData, filename4) = try await LandTransportAPI.shared.downloadPassengerVolumeByOriginDestinationTrainStation()
```

### Handling the ZIP Data

The returned data is in ZIP format containing a CSV file:

```swift
import Foundation

do {
    let (zipData, filename) = try await LandTransportAPI.shared.downloadPassengerVolumeByBusStop()
    
    // Save to documents directory
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileURL = documentsURL.appendingPathComponent(filename)
    try zipData.write(to: fileURL)
    
    print("Saved to: \(fileURL.path)")
    
    // You can then unzip and parse the CSV as needed
    
} catch LandTransportAPIError.rateLimited {
    print("Rate limited - please wait before trying again")
} catch {
    print("Error: \(error)")
}
```

## Complete Example

Here's a facilities dashboard combining multiple APIs:

```swift
import SwiftUI
import LandTransportKit

struct FacilitiesDashboardView: View {
    @State private var carParks: [CarPark] = []
    @State private var travelTimes: [EstimatedTravelTime] = []
    @State private var faultyLights: [FaultyTrafficLight] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                // Car Park Summary
                Section("Car Parks") {
                    let available = carParks.filter { $0.AvailableLots > 0 }.count
                    let total = carParks.count
                    
                    HStack {
                        Label("Available", systemImage: "car.fill")
                        Spacer()
                        Text("\(available) / \(total)")
                            .foregroundStyle(.secondary)
                    }
                }
                
                // Travel Times
                Section("Expressway Travel Times") {
                    ForEach(travelTimes.prefix(5), id: \.id) { route in
                        HStack {
                            Text(route.Name)
                            Spacer()
                            Text("\(route.EstTime) min")
                                .foregroundStyle(.blue)
                        }
                    }
                }
                
                // Faulty Traffic Lights
                Section("Traffic Light Issues (\(faultyLights.count))") {
                    if faultyLights.isEmpty {
                        Text("No reported issues")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(faultyLights.prefix(3), id: \.AlarmID) { fault in
                            VStack(alignment: .leading) {
                                Text(fault.TechnicalAlarmType)
                                    .font(.headline)
                                Text(fault.Message)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Facilities")
            .refreshable {
                await loadAllData()
            }
            .task {
                await loadAllData()
            }
        }
    }
    
    private func loadAllData() async {
        isLoading = true
        defer { isLoading = false }
        
        async let carParksTask = LandTransportAPI.shared.downloadCarParkAvailability()
        async let travelTimesTask = LandTransportAPI.shared.downloadEstimatedTravelTimes()
        async let faultyLightsTask = LandTransportAPI.shared.downloadFaultyTrafficLights()
        
        do {
            let (parks, times, lights) = try await (carParksTask, travelTimesTask, faultyLightsTask)
            carParks = parks
            travelTimes = times
            faultyLights = lights
        } catch {
            print("Error: \(error)")
        }
    }
}
```

## Topics

### Models

- ``CarPark``
- ``BikePark``
- ``EstimatedTravelTime``
- ``FaultyTrafficLight``
- ``RoadEvent``
- ``LiftMaintenance``
