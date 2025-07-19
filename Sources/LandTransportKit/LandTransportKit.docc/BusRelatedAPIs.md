# Bus Related APIs

@Metadata {
    @PageImage(purpose: icon, source: "bus.png")
    @PageColor(green)
}

This article covers the bus related APIs supported by ``LandTransportKit``.

## Overview

``LandTransportAPI`` surfaces four bus related APIs:
- Bus Arrivals (see ``BusArrivals``)
- Bus Routes (see ``BusRoute``)
- Bus Services (see ``BusService``)
- Bus Stops` (see ``BusStop``)

### Bus Arrivals

To obtain the latest arrival times for a stop (filtered, optionally, to a single service) you call ``LandTransportAPI/getBusArrivals(at:serviceNo:)``. In a SwiftUI app, 

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


