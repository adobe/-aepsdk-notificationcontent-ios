# APIs Usage

This document provides information on how to use the AEPSwiftUI APIs to receive and display content card views in your application.

## Importing AEPSwiftUI

To use the AEPSwiftUI APIs, you need to import the AEPSwiftUI module in your Swift file.

```swift
import AEPSwiftUI
```

## APIs

### extensionVersion

The `extensionVersion` property is used to get the version of the AEPSwiftUI extension.

```swift
let version = AEPSwiftUI.extensionVersion
```

### getContentCardsUI

The `getContentCardsUI` method retrieves an array of [ContentCardUI](./ContentCard/PublicClasses/contentcardui.md) objects for the provided surface. These ContentCardUI objects provide the user interface for templated content cards in your application.

#### Parameters:

- _surface_ - The surface for which the content cards should be retrieved.
- _customizer_ - An optional [ContentCardCustomizing](./ContentCard/PublicClasses/contentcardcustomizing.md) object to customize the appearance of the content card template. If you do not need to customize the appearance of the content card template, this parameter can be omitted.
- _listener_ - An optional [ContentCardUIEventListening](./ContentCard/PublicClasses/contentcarduieventlistening.md) object to listen to UI events from the content card. If you do not need to listen to UI events from the content card, this parameter can be omitted.
- _completion_ - A completion handler that is called with a `Result` containing either:
    - _success_ - An array of [ContentCardUI](./ContentCard/PublicClasses/contentcardui.md) objects representing the content cards to be displayed.
    - _failure_ - An `Error` object indicating the reason for the failure, if any.

> **Note** - Calling this API will not download content cards from Adobe Journey Optimizer; it will only retrieve the content cards that are already downloaded and cached by the Messaging extension. You **must** call [`updatePropositionsForSurfaces`](https://github.com/adobe/aepsdk-messaging-ios/blob/main/Documentation/sources/propositions/developer-documentation/api-usage.md#updatePropositionsForSurfaces) API from the AEPMessaging extension with the desired surfaces prior to calling this API. 

#### Syntax

```swift
public static func getContentCardsUI(for surface: Surface,
                                     customizer: ContentCardCustomizing? = nil,
                                     listener: ContentCardUIEventListening? = nil,
                                     _ completion: @escaping (Result<[ContentCardUI], Error>) -> Void)
```

#### Example

```swift
// Download the content cards for homepage surface using Messaging extension
let homePageSurface = Surface(path: "homepage")
Messaging.updatePropositionsForSurfaces([homePageSurface])

// Get the content card UI for the homepage surface
AEPSwiftUI.getContentCardsUI(for: acrobatCardsSurface) { result in
    switch result {
    case .success(let contentCards):
        // Use the contentCards array to display UI for templated content cards in your application
    case .failure(let error):
        // Handle the error
    }
}
```