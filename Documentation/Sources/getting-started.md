#  Installing the AEPNotificationContent package

### Prerequisites

Make sure you have completed the steps in the [prerequisites](./../README.md#prerequisites).

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

# for app development, include all the following pods
target 'YOUR_NOTIFICATION_CONTENT_EXTENSION_NAME' do
      pod 'AEPNotificationContent'
end
```

Replace `YOUR_NOTIFICATION_CONTENT_EXTENSION_NAME` and then, in the `Podfile` directory, run:

```ruby
$ pod install
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

To add the AEPNotificationContent Package to your application, from the Xcode menu select:

`File > Add Packages...`

> **Note**: the menu options may vary depending on the version of Xcode being used.

Enter the URL for the AEPNotificationContent package repository: `https://github.com/adobe/aepsdk-ui-ios.git`.

For `Dependency Rule`, select `Up to Next Major Version`.

Alternatively, if your project has a `Package.swift` file, you can add the AEPNotificationContent extension directly to your dependencies:

```
dependencies: [
    .package(name: "AEPNotificationContent", url: "https://github.com/adobe/aepsdk-ui-ios.git", .upToNextMajor(from: "5.0.0"))
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "AEPNotificationContent", package: "AEPNotificationContent")
        ]
    )
]
```

### Binaries

To generate `AEPNotificationContent.xcframework`, run the following command from the root directory:

```
make archive
```

This will generate an XCFramework under the `build` folder. Drag and drop `AEPNotificationContent.xcframework` to your app's Notification Content extension target.

### Configure your Notification Content extension

With the `AEPNotificationContent` package now available in your application, you need to [configure your notification content extension](./configure-extension.md) to use it.
