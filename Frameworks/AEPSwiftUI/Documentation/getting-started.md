# Getting started with AEPSwiftUI framework

### [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

```ruby
# Podfile
use_frameworks!

# for app development, include all the following pods
target 'YOUR_APP_NAME' do
    pod 'AEPSwiftUI', :git => 'https://github.com/adobe/aepsdk-ui-ios.git', :branch => '5.1.0'
end
```

Replace `YOUR_APP_NAME` and then, in the `Podfile` directory, run:

```ruby
$ pod install
```

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

To add the AEPSwiftUI Package to your application, from the Xcode menu select:

`File > Add Packages...`

> **Note**: the menu options may vary depending on the version of Xcode being used.

Enter the URL for the AEPSwiftUI package repository: `https://github.com/adobe/aepsdk-ui-ios.git`.

For `Dependency Rule`, select `Branch` and enter `v5.1.0`.

Alternatively, if your project has a `Package.swift` file, you can add AEPMessaging directly to your dependencies:

```
dependencies: [
    .package(url: "https://github.com/adobe/aepsdk-ui-ios.git", .branch("v5.1.0"))
],
targets: [
    .target(name: "YourTarget",
            dependencies: ["AEPSwiftUI"],
            path: "your/path")
]

### Binaries

To generate `AEPSwiftUI.xcframework`, run the following command from the root directory:

```
make archive
```

This will generate an XCFramework under the `build` folder. Drag and drop `AEPSwiftUI.xcframework` to your app's target in Xcode.