# 🏁 Getting Started

Instructions to get you up and running with the `LandTransportKit` functionality.

## Overview

Functionality available in `LandTransportKit` is surfaced via the ``LandTransportAPI`` singleton `actor`. In order make use of the functionality, you must make sure the below pre-requisites are met.

### Pre-requisites

- Obtain an API key from the Land Transport Authority (LTA) [here](https://datamall.lta.gov.sg/content/datamall/en/request-for-api.html).
- Configure the ``LandTransportAPI`` as early as possible during your app's launch.

#### Example

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



