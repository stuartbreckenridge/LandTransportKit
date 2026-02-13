# Traffic Related APIs

@Metadata {
    @PageColor(red)
}

Access real-time traffic images, incidents, speed data, and advisory messages.

## Overview

LandTransportKit provides comprehensive traffic monitoring data through five APIs:

| API | Method | Description |
|-----|--------|-------------|
| Traffic Images | ``LandTransportAPI/downloadTrafficImages()`` | Live camera feeds |
| Traffic Incidents | ``LandTransportAPI/downloadTrafficIncidents()`` | Active incidents |
| Traffic Speed Bands | ``LandTransportAPI/downloadTrafficSpeedBands()`` | Road speed data |
| Traffic Flow | ``LandTransportAPI/downloadTrafficFlow()`` | Traffic flow measurements |
| VMS (Advisories) | ``LandTransportAPI/downloadTrafficAdvisories()`` | Variable message signs |

## Traffic Images

The traffic images API provides URLs to live camera feeds from traffic cameras across Singapore's road network.

### Basic Usage

```swift
import LandTransportKit

let images = try await LandTransportAPI.shared.downloadTrafficImages()
print("Traffic cameras: \(images.count)")
```

### Displaying Traffic Camera Images

```swift
import SwiftUI
import LandTransportKit

struct TrafficCameraView: View {
    @State private var cameras: [TrafficImage] = []
    @State private var selectedCamera: TrafficImage?
    
    var body: some View {
        NavigationStack {
            List(cameras, id: \.CameraID) { camera in
                Button {
                    selectedCamera = camera
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: camera.ImageLink)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 120, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading) {
                            Text(camera.CameraID)
                                .font(.headline)
                            if let coordinate = camera.coordinate2D {
                                Text("\(coordinate.latitude, specifier: "%.4f"), \(coordinate.longitude, specifier: "%.4f")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Traffic Cameras")
            .task {
                await loadCameras()
            }
            .sheet(item: $selectedCamera) { camera in
                TrafficCameraDetailView(camera: camera)
            }
        }
    }
    
    private func loadCameras() async {
        do {
            cameras = try await LandTransportAPI.shared.downloadTrafficImages()
        } catch {
            print("Error: \(error)")
        }
    }
}
```

### Camera Location Properties

```swift
let camera = cameras.first!

print("Camera ID: \(camera.CameraID)")
print("Image URL: \(camera.ImageLink)")

// Location as CLLocationCoordinate2D
if let coordinate = camera.coordinate2D {
    print("Location: \(coordinate.latitude), \(coordinate.longitude)")
}

// Location as CLLocation
if let location = camera.location {
    let distance = location.distance(from: myLocation)
    print("Distance: \(distance)m")
}
```

## Traffic Incidents

The traffic incidents API returns currently active traffic incidents such as accidents, breakdowns, and road closures.

### Basic Usage

```swift
let incidents = try await LandTransportAPI.shared.downloadTrafficIncidents()

for incident in incidents {
    print("\(incident.Type): \(incident.Message)")
}
```

### Incident Details

```swift
let incident = incidents.first!

print("Type: \(incident.Type)")         // "Accident", "Road Work", "Vehicle Breakdown", etc.
print("Message: \(incident.Message)")   // Detailed description
print("Latitude: \(incident.Latitude)")
print("Longitude: \(incident.Longitude)")
```

### Filtering by Type

```swift
// Get only accidents
let accidents = incidents.filter { $0.Type == "Accident" }

// Get only road works
let roadWorks = incidents.filter { $0.Type == "Road Work" }

// Get only breakdowns
let breakdowns = incidents.filter { $0.Type == "Vehicle Breakdown" }
```

### Displaying Incidents on a Map

```swift
import SwiftUI
import MapKit
import LandTransportKit

struct IncidentMapView: View {
    @State private var incidents: [TrafficIncident] = []
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        Map(position: $position) {
            ForEach(incidents, id: \.id) { incident in
                Annotation(incident.Type, coordinate: CLLocationCoordinate2D(
                    latitude: incident.Latitude,
                    longitude: incident.Longitude
                )) {
                    Image(systemName: iconForType(incident.Type))
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(colorForType(incident.Type))
                        .clipShape(Circle())
                }
            }
        }
        .task {
            do {
                incidents = try await LandTransportAPI.shared.downloadTrafficIncidents()
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    private func iconForType(_ type: String) -> String {
        switch type {
        case "Accident": return "car.side.front.open"
        case "Road Work": return "cone.fill"
        case "Vehicle Breakdown": return "exclamationmark.triangle"
        default: return "mappin"
        }
    }
    
    private func colorForType(_ type: String) -> Color {
        switch type {
        case "Accident": return .red
        case "Road Work": return .orange
        case "Vehicle Breakdown": return .yellow
        default: return .gray
        }
    }
}
```

## Traffic Speed Bands

The traffic speed bands API provides current traffic speeds for road segments across Singapore.

### Basic Usage

```swift
let speedBands = try await LandTransportAPI.shared.downloadTrafficSpeedBands()
print("Road segments: \(speedBands.count)")
```

> Note: This is a paginated endpoint that may return thousands of records. The API handles pagination automatically.

### Speed Band Data

```swift
let segment = speedBands.first!

print("Link ID: \(segment.LinkID)")
print("Road: \(segment.RoadName)")
print("Category: \(segment.RoadCategory)")  // "A" (Expressway), "B" (Major), etc.
print("Speed Band: \(segment.SpeedBand)")   // 1 (slow) to 8 (fast)
print("Speed Range: \(segment.MinimumSpeed) - \(segment.MaximumSpeed) km/h")

// Segment coordinates
let startCoord = segment.startCoordinate
let endCoord = segment.endCoordinate
print("From: \(startCoord.latitude), \(startCoord.longitude)")
print("To: \(endCoord.latitude), \(endCoord.longitude)")
```

### Filtering by Speed

```swift
// Find congested roads (speed band 1-2)
let congested = speedBands.filter { $0.SpeedBand <= 2 }

// Find free-flowing roads (speed band 7-8)
let freeFlowing = speedBands.filter { $0.SpeedBand >= 7 }

// Filter by road category (expressways only)
let expressways = speedBands.filter { $0.RoadCategory == "A" }
```

## Traffic Flow

The traffic flow API provides traffic volume measurements from sensors across the road network.

### Basic Usage

```swift
do {
    let flowData = try await LandTransportAPI.shared.downloadTrafficFlow()
    print("Measurements: \(flowData.Value.count)")
} catch LandTransportAPIError.rateLimited {
    print("Rate limited - try again later")
}
```

> Warning: This is a rate-limited endpoint. Excessive requests may result in a ``LandTransportAPIError/rateLimited`` error.

### Flow Data Structure

```swift
let flowData = try await LandTransportAPI.shared.downloadTrafficFlow()

for measurement in flowData.Value {
    print("Link ID: \(measurement.LinkID)")
    print("Road: \(measurement.RoadName)")
    print("Speed: \(measurement.Speed) km/h")
    print("Volume: \(measurement.Volume) vehicles")
}
```

## Traffic Advisories (VMS)

The Variable Message Services (VMS) API returns messages currently displayed on electronic road signs.

### Basic Usage

```swift
let advisories = try await LandTransportAPI.shared.downloadTrafficAdvisories()

for advisory in advisories {
    print("Message: \(advisory.Message)")
}
```

### Advisory Details

```swift
let advisory = advisories.first!

print("Equipment ID: \(advisory.EquipmentID)")
print("Message: \(advisory.Message)")
```

## Complete Example

Here's a comprehensive traffic monitoring dashboard:

```swift
import SwiftUI
import LandTransportKit

struct TrafficDashboardView: View {
    @State private var incidents: [TrafficIncident] = []
    @State private var advisories: [TrafficAdvisoryMessage] = []
    @State private var cameras: [TrafficImage] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                // Incidents Section
                Section("Active Incidents (\(incidents.count))") {
                    if incidents.isEmpty {
                        Text("No active incidents")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(incidents.prefix(5), id: \.id) { incident in
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundStyle(.orange)
                                    Text(incident.Type)
                                        .font(.headline)
                                }
                                Text(incident.Message)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                
                // Advisories Section
                Section("Road Advisories (\(advisories.count))") {
                    if advisories.isEmpty {
                        Text("No advisories")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(advisories.prefix(5), id: \.EquipmentID) { advisory in
                            Text(advisory.Message)
                                .font(.subheadline)
                        }
                    }
                }
                
                // Cameras Section
                Section("Traffic Cameras") {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 12) {
                            ForEach(cameras.prefix(10), id: \.CameraID) { camera in
                                AsyncImage(url: URL(string: camera.ImageLink)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 160, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .navigationTitle("Traffic")
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
        
        async let incidentsTask = LandTransportAPI.shared.downloadTrafficIncidents()
        async let advisoriesTask = LandTransportAPI.shared.downloadTrafficAdvisories()
        async let camerasTask = LandTransportAPI.shared.downloadTrafficImages()
        
        do {
            let (loadedIncidents, loadedAdvisories, loadedCameras) = try await (
                incidentsTask,
                advisoriesTask,
                camerasTask
            )
            incidents = loadedIncidents
            advisories = loadedAdvisories
            cameras = loadedCameras
        } catch {
            print("Error loading traffic data: \(error)")
        }
    }
}
```

## Topics

### Models

- ``TrafficImage``
- ``TrafficIncident``
- ``TrafficSpeedBand``
- ``TrafficFlowData``
- ``TrafficAdvisoryMessage``
