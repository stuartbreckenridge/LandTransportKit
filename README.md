<img width="1920" height="859" alt="LTK" src="https://github.com/user-attachments/assets/8967b445-ee4f-48ab-a945-cc4298e01486" />

# LandTransportKit

[![Test Status](https://github.com/stuartbreckenridge/LandTransportKit/actions/workflows/build.yml/badge.svg)](https://github.com/stuartbreckenridge/LandTransportKit/actions/workflows/build.yml)
<a href="https://codecov.io/github/stuartbreckenridge/LandTransportKit"><img src="https://codecov.io/github/stuartbreckenridge/LandTransportKit/graph/badge.svg?token=NW40O25ANG"/></a>

A Swift package for accessing real-time and static data from Singapore's Land Transport Authority (LTA) DataMall API. It provides strongly typed interfaces to common transport datasets such as Bus Arrival times, Traffic Images, Carpark Availability, Taxi Locations, and more.

## Features

Features supported by this package are as follows, with reference to the LTA DataMall API User Guide


| LTA User Guide Ref  | Description | Supported |
| :------------------ | :----------- | :--------- |
| 2.1                | BUS ARRIVALS | ✅        |
| 2.2                | BUS SERVICES | ✅        |
| 2.3                | BUS ROUTES | ✅        |
| 2.4                | BUS STOPS | ✅        |
| 2.5                | PASSENGER VOLUME BY BUS STOPS  | ✅        |
| 2.6                | PASSENGER VOLUME BY ORIGIN DESTINATION BUS STOPS | ✅        |
| 2.7                | PASSENGER VOLUME BY ORIGIN DESTINATION TRAIN STATIONS | ✅        |
| 2.8                | PASSENGER VOLUME BY TRAIN STATIONS | ✅        |
| 2.9                | TAXI AVAILABILITY | ✅        |
| 2.10                | TAXI STANDS | ✅        |
| 2.11                | TRAIN SERVICE ALERTS | ✅        |
| 2.12                | CARPARK AVAILABILITY | ✅        |
| 2.13                | ESTIMATED TRAVEL TIMES | ✅        |
| 2.14                | FAULTY TRAFFIC LIGHTS | ✅        |
| 2.15                | PLANNED ROAD OPENINGS | ✅        |
| 2.16                | APPROVED ROAD WORKS | ✅        |
| 2.17                | TRAFFIC IMAGES | ✅        |
| 2.18                | TRAFFIC INCIDENTS | ✅        |
| 2.19               | TRAFFIC SPEED BANDS | ✅        |
| 2.20                | VMS / EMAS | ✅        |
| 2.21                | BICYCLE PARKING | ✅        |
| 2.22                | GEOSPATIAL WHOLE ISLAND | ❌        |
| 2.23                | FACILITIES MAINTENANCE | ✅        |
| 2.24               | STATION CROWD DENSITY REAL TIME | ✅        |
| 2.25               | STATION CROWD DENSITY FORECAST | ✅        |
| 2.26               | TRAFFIC FLOW  | ❌           |
| 2.27               | PLANNED BUS ROUTES            |  ✅           |

Documentation is still being written.


## Requirements

- Obtain an API key from the Land Transport Authority (LTA) [here](https://datamall.lta.gov.sg/content/datamall/en/request-for-api.html).
- Configure the ``LandTransportAPI`` as early as possible during your app's launch.

```swift
import SwiftUI
import LandTransportKit

@main
struct lta_example_appApp: App {
    
    let api = LandTransportAPI.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await api.configure(apiKey: <#YOUR_API_KEY#>)
                }
        }
        
    }
}
```

Then, to obtain the latest arrival times for a stop (filtered, optionally, to a single service) you call ``LandTransportAPI/getBusArrivals(at:serviceNo:)``. In a SwiftUI app, 

```swift
import Foundation
import LandTransportKit

@Observable
final class SampleViewModel {

    var arrivals: BusArrivals? = nil
    
    let api = LandTransportAPI.shared

    func getLatestArrivals(stopId: String, serviceNo: String?) async throws {
        let arrivals = try await api.getBusArrivals(stopID, serviceNo)
        self.arrivals = arrivals
    }
}
```
