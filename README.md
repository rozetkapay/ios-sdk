<img src="https://github.com/user-attachments/assets/6319f2c7-bdc8-4381-b866-5609bacc6e6c" alt="drawing" width="400"/>

# RozetkaPay SDK for iOS
![GitHub Release](https://img.shields.io/github/v/release/rozetkapay/ios-sdk)

> The RozetkaPay SDK makes adding a smooth payment experience to your mobile application easy. Our SDK offers customizable UI components for securely collecting card details and supports complete payment flows, including Apple Pay, for seamless transactions.

You can find all documentation here 🗒️ [RozetkaPay iOS SDK Documentation](https://github.com/rozetkapay/ios-sdk/wiki)

## Installation

To integrate the RozetkaPay SDK into your iOS app, follow the steps below. Ensure your project meets the minimum requirements and add the necessary dependencies to your project.

## Requirements

Before integrating RozetkaPay, make sure your project meets the following requirements:

- **Minimum SDK Version:**  iOS 15.0

## Dependencies

To install the RozetkaPay SDK using Swift Package Manager (SPM), follow these steps:

1. **Add the Package to Your Project:**
    - In Xcode, select `File` > `Add Packages...`.
    - Enter the repository URL: `https://github.com/rozetkapay/ios-sdk`.
    - Click `Add Package`.
2. **Select the Package Version:**
    - Choose the latest version of the SDK. You can find information about the last releases on this page [Releases](https://github.com/rozetkapay/ios-sdk/releases)
    - Click `Next`.
3. **Add the Package to Your Target:**
    - In the `Add to Project` section, select your app target.
    - Ensure the `RozetkaPaySDK` product is checked.
    - Click `Add Package`.

## Initialization

Before using any APIs from the RozetkaPay SDK, you must initialize the SDK. Initialization is a crucial step that sets up the SDK's environment and prepares it for use within your application. Failing to initialize the SDK properly can lead to unexpected behavior or runtime errors. This setup should occur as early as possible in your app's lifecycle, preferably within the `application` method of your application's class `AppDelegate` or the `init` method of your SwiftUI `App`structure.

## Initializing RozetkaPay SDK

To initialize the RozetkaPay SDK, call the `RozetkaPaySdk.initSdk()` function using the necessary parameters. This function requires an application context and allows you to configure the SDK's mode and logging options.

## Code Example

Here’s how you can initialize the SDK:

### For SwiftUI applications:

```swift
import SwiftUI
import RozetkaPaySDK

@main
struct My_UIApp: App {
    
    init() {
        RozetkaPaySdk.initSdk(
            appContext: UIApplication.shared,
            mode: .development, // Use .production in a live environment
            enableLogging: false,
            validationRules: RozetkaPaySdkValidationRules()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### For UIKit applications:

```swift
import UIKit
import RozetkaPaySDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        RozetkaPaySdk.initSdk(
            appContext: application,
            mode: .development, // Use .production in a live environment
            enableLogging: false,
            validationRules: RozetkaPaySdkValidationRules()
        )
        
        return true
    }
}

```

You can find more information about SDK configuration in the configuration section.
⚙️ [Configuration](https://github.com/rozetkapay/ios-sdk/wiki/Configuration)

## Parameters

- `appContext: UIApplication`: The application context. Use `UIApplication.shared` or the `application`parameter in your `AppDelegate`.
- `mode: RozetkaPaySdkMode`: Optional parameter, defaults to `.production`. The operational mode of the SDK. Possible values are:
    - `.production`: Use this mode for live environments and released applications.
    - `.development`: Use this mode for development and testing only. This mode is not suitable for production apps and should not be included in any released application.
- `enableLogging: Bool`: Optional parameter, defaults to `false`. Enable or disable logging. Logging can be helpful for debugging during development but should be disabled in production environments to ensure security and performance.
- `validationRules: RozetkaPaySdkValidationRules`: Optional parameter for custom validation rules for card details. The default is `RozetkaPaySdkValidationRules()`.
