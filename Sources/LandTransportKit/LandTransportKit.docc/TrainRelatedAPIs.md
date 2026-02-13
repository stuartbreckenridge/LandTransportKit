# Train Related APIs

@Metadata {
    @PageColor(purple)
}

Access MRT/LRT service alerts and station crowd density data.

## Overview

LandTransportKit provides train-related data through three APIs:

| API | Method | Description |
|-----|--------|-------------|
| Service Alerts | ``LandTransportAPI/downloadTrainServiceAlerts()`` | Current service disruptions |
| Real-Time Density | ``LandTransportAPI/downloadRealTimeDensity(for:)`` | Current station crowd levels |
| Forecast Density | ``LandTransportAPI/downloadForecastDensity(for:)`` | Predicted crowd levels |

## Train Lines

Singapore's rail network consists of multiple MRT and LRT lines. Use the ``TrainLines`` enum to specify which line to query:

```swift
public enum TrainLines: CaseIterable {
    case ccl    // Circle Line
    case cel    // Circle Line Extension
    case cgl    // Changi Extension
    case dtl    // Downtown Line
    case ewl    // East West Line
    case nel    // North East Line
    case nsl    // North South Line
    case bpl    // Bukit Panjang LRT
    case slrt   // Sengkang LRT
    case plrt   // Punggol LRT
    case tel    // Thomson-East Coast Line
}
```

Each line provides a code and description:

```swift
let line = TrainLines.dtl
print(line.code)        // "DTL"
print(line.description) // "Downtown Line"

// Iterate all lines
for line in TrainLines.allCases {
    print("\(line.code): \(line.description)")
}
```

## Train Service Alerts

The service alerts API provides information about current MRT/LRT service disruptions, delays, or changes.

### Basic Usage

```swift
import LandTransportKit

let alert = try await LandTransportAPI.shared.downloadTrainServiceAlerts()

// Check overall service status
switch alert.Status {
case 1:
    print("All services operating normally")
case 2:
    print("Service disruption in progress")
default:
    print("Unknown status")
}
```

### Alert Details

The ``TrainServiceAlert`` contains detailed information about any active disruptions:

```swift
let alert = try await LandTransportAPI.shared.downloadTrainServiceAlerts()

// Check if there are any affected segments
if let affectedSegments = alert.AffectedSegments {
    for segment in affectedSegments {
        print("Line: \(segment.Line)")
        print("Direction: \(segment.Direction)")
        print("Stations: \(segment.Stations)")
        print("Free Bus: \(segment.FreeBusAvailable ? "Yes" : "No")")
        print("Free MRT Shuttle: \(segment.FreeMRTShuttleAvailable ? "Yes" : "No")")
    }
}

// Get any messages
if let messages = alert.Messages {
    for message in messages {
        print("[\(message.CreatedDate)] \(message.Content)")
    }
}
```

### Displaying Service Status

```swift
import SwiftUI
import LandTransportKit

struct ServiceStatusView: View {
    @State private var alert: TrainServiceAlert?
    @State private var isLoading = false
    
    var body: some View {
        List {
            Section {
                HStack {
                    statusIcon
                    VStack(alignment: .leading) {
                        Text("MRT/LRT Status")
                            .font(.headline)
                        Text(statusText)
                            .foregroundStyle(statusColor)
                    }
                }
            }
            
            if let messages = alert?.Messages, !messages.isEmpty {
                Section("Service Messages") {
                    ForEach(messages, id: \.Content) { message in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message.Content)
                            Text(message.CreatedDate)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            
            if let segments = alert?.AffectedSegments, !segments.isEmpty {
                Section("Affected Lines") {
                    ForEach(segments, id: \.Line) { segment in
                        VStack(alignment: .leading) {
                            Text(segment.Line)
                                .font(.headline)
                            Text(segment.Stations)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .refreshable {
            await loadAlert()
        }
        .task {
            await loadAlert()
        }
    }
    
    private var statusIcon: some View {
        Image(systemName: alert?.Status == 1 ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
            .font(.title)
            .foregroundStyle(statusColor)
    }
    
    private var statusText: String {
        guard let status = alert?.Status else { return "Loading..." }
        return status == 1 ? "Normal Service" : "Service Disruption"
    }
    
    private var statusColor: Color {
        guard let status = alert?.Status else { return .gray }
        return status == 1 ? .green : .red
    }
    
    private func loadAlert() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            alert = try await LandTransportAPI.shared.downloadTrainServiceAlerts()
        } catch {
            print("Error: \(error)")
        }
    }
}
```

## Station Crowd Density

The crowd density APIs provide real-time and forecasted crowd levels at MRT/LRT stations. This data helps commuters plan their journeys to avoid crowded stations.

### Real-Time Density

Get the current crowd density for all stations on a specific line:

```swift
// Get real-time density for Downtown Line
let density = try await LandTransportAPI.shared.downloadRealTimeDensity(for: .dtl)

for station in density {
    print("\(station.Station): \(station.CrowdLevel)")
}
```

### Crowd Level Values

The `CrowdLevel` property indicates how crowded a station is:

| Value | Meaning |
|-------|---------|
| `l` | Low crowd - plenty of space |
| `m` | Moderate crowd - some crowding |
| `h` | High crowd - very crowded |

```swift
let density = try await LandTransportAPI.shared.downloadRealTimeDensity(for: .nsl)

for station in density {
    let emoji = switch station.CrowdLevel {
        case "l": "🟢"
        case "m": "🟡"
        case "h": "🔴"
        default: "⚪️"
    }
    print("\(emoji) \(station.Station)")
}
```

### Forecast Density

Get predicted crowd density for stations on a line:

```swift
let forecast = try await LandTransportAPI.shared.downloadForecastDensity(for: .ewl)

for station in forecast {
    print("Station: \(station.Station)")
    print("Start Time: \(station.StartTime)")
    print("End Time: \(station.EndTime)")
    print("Crowd Level: \(station.CrowdLevel)")
}
```

### Complete Station Crowd Example

```swift
import SwiftUI
import LandTransportKit

struct StationCrowdView: View {
    @State private var selectedLine: TrainLines = .dtl
    @State private var density: [RealTimeDensity] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Line", selection: $selectedLine) {
                        ForEach(TrainLines.allCases, id: \.self) { line in
                            Text(line.description)
                                .tag(line)
                        }
                    }
                }
                
                Section("Stations") {
                    if isLoading {
                        ProgressView()
                    } else if density.isEmpty {
                        Text("No data available")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(density, id: \.Station) { station in
                            HStack {
                                crowdIndicator(station.CrowdLevel)
                                Text(station.Station)
                                Spacer()
                                Text(crowdText(station.CrowdLevel))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Station Crowds")
            .onChange(of: selectedLine) {
                Task { await loadDensity() }
            }
            .task {
                await loadDensity()
            }
        }
    }
    
    private func crowdIndicator(_ level: String) -> some View {
        Circle()
            .fill(crowdColor(level))
            .frame(width: 12, height: 12)
    }
    
    private func crowdColor(_ level: String) -> Color {
        switch level {
        case "l": return .green
        case "m": return .yellow
        case "h": return .red
        default: return .gray
        }
    }
    
    private func crowdText(_ level: String) -> String {
        switch level {
        case "l": return "Low"
        case "m": return "Moderate"
        case "h": return "High"
        default: return "Unknown"
        }
    }
    
    private func loadDensity() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            density = try await LandTransportAPI.shared.downloadRealTimeDensity(for: selectedLine)
        } catch {
            print("Error: \(error)")
            density = []
        }
    }
}
```

## Complete Example

Here's a comprehensive train information view combining service alerts and crowd density:

```swift
import SwiftUI
import LandTransportKit

struct TrainInfoView: View {
    @State private var serviceAlert: TrainServiceAlert?
    @State private var crowdData: [TrainLines: [RealTimeDensity]] = [:]
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            List {
                // Service Status Section
                Section {
                    ServiceStatusRow(alert: serviceAlert)
                }
                
                // Crowd by Line Section
                ForEach(TrainLines.allCases, id: \.self) { line in
                    if let stations = crowdData[line], !stations.isEmpty {
                        Section(line.description) {
                            ForEach(stations.prefix(5), id: \.Station) { station in
                                HStack {
                                    Circle()
                                        .fill(crowdColor(station.CrowdLevel))
                                        .frame(width: 10, height: 10)
                                    Text(station.Station)
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Train Info")
            .refreshable {
                await loadAllData()
            }
            .task {
                await loadAllData()
            }
        }
    }
    
    private func crowdColor(_ level: String) -> Color {
        switch level {
        case "l": return .green
        case "m": return .yellow
        case "h": return .red
        default: return .gray
        }
    }
    
    private func loadAllData() async {
        isLoading = true
        defer { isLoading = false }
        
        // Load service alert
        do {
            serviceAlert = try await LandTransportAPI.shared.downloadTrainServiceAlerts()
        } catch {
            print("Error loading alerts: \(error)")
        }
        
        // Load crowd data for major lines
        let majorLines: [TrainLines] = [.nsl, .ewl, .nel, .ccl, .dtl, .tel]
        
        await withTaskGroup(of: (TrainLines, [RealTimeDensity]).self) { group in
            for line in majorLines {
                group.addTask {
                    do {
                        let density = try await LandTransportAPI.shared.downloadRealTimeDensity(for: line)
                        return (line, density)
                    } catch {
                        return (line, [])
                    }
                }
            }
            
            for await (line, density) in group {
                crowdData[line] = density
            }
        }
    }
}

struct ServiceStatusRow: View {
    let alert: TrainServiceAlert?
    
    var body: some View {
        HStack {
            Image(systemName: alert?.Status == 1 ? "tram.fill" : "exclamationmark.triangle.fill")
                .foregroundStyle(alert?.Status == 1 ? .green : .red)
            VStack(alignment: .leading) {
                Text("MRT/LRT Service")
                    .font(.headline)
                Text(alert?.Status == 1 ? "Normal" : "Disruption")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
```

## Topics

### Models

- ``TrainServiceAlert``
- ``RealTimeDensity``
- ``ForecastDensity``
- ``TrainLines``
