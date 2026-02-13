# ``LandTransportKit``

@Metadata {
    @PageImage(purpose: icon, source: "LTK-Red.png")
    @PageColor(orange)
}

A Swift package for accessing real-time and static data from Singapore's Land Transport Authority (LTA) DataMall API. 

## Overview

LandTransportKit provides a modern, type-safe Swift interface to Singapore's Land Transport Authority (LTA) DataMall API. Built with Swift concurrency (`async`/`await`) and the actor model, it offers thread-safe access to real-time transport data including bus arrivals, traffic conditions, taxi availability, train alerts, and more.

### Key Features

- **Modern Swift Concurrency**: All API methods are `async` and use Swift's structured concurrency
- **Type-Safe Models**: Strongly typed response models with `Codable` and `Sendable` conformance
- **Comprehensive Error Handling**: Custom ``LandTransportAPIError`` enum for precise error handling
- **Location Support**: Convenient `CLLocation` and `CLLocationCoordinate2D` properties on location-based models
- **Automatic Pagination**: Large datasets are automatically fetched across multiple pages

### Supported APIs

LandTransportKit supports the following categories of LTA DataMall APIs:

| Category | Endpoints |
|----------|-----------|
| **Bus** | Arrivals, Routes, Services, Stops |
| **Taxi** | Availability, Stands |
| **Traffic** | Images, Incidents, Speed Bands, Flow, Advisories (VMS) |
| **Train** | Service Alerts, Station Crowd Density |
| **Facilities** | Car Parks, Bike Parking, Maintenance |
| **Other** | Estimated Travel Times, Faulty Traffic Lights, Road Events |

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ErrorHandling>
- ``LandTransportAPI``
- ``LandTransportAPIError``

### Bus

- <doc:BusRelatedAPIs>
- ``BusArrivals``
- ``BusService``
- ``BusRoute``
- ``BusStop``

### Taxi

- <doc:TaxiRelatedAPIs>
- ``TaxiAvailability``
- ``TaxiStand``

### Traffic

- <doc:TrafficRelatedAPIs>
- ``TrafficImage``
- ``TrafficIncident``
- ``TrafficSpeedBand``
- ``TrafficFlowData``
- ``TrafficAdvisoryMessage``

### Train

- <doc:TrainRelatedAPIs>
- ``TrainServiceAlert``
- ``RealTimeDensity``
- ``ForecastDensity``
- ``TrainLines``

### Facilities & Other

- <doc:FacilitiesAPIs>
- ``CarPark``
- ``BikePark``
- ``EstimatedTravelTime``
- ``FaultyTrafficLight``
- ``RoadEvent``
- ``LiftMaintenance``
