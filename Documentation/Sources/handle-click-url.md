# Handling Click URLs in Notification Templates

## Overview

This guide explains how to handle click URLs in notification templates for iOS applications.

## Creating a Custom NotificationViewController

To implement custom URL handling, create a notification view controller that inherits from `AEPNotificationViewController`:

```swift
class NotificationViewController: AEPNotificationViewController {
    // Implementation details will be added below
}
```

## Configuring Info.plist

Add the following entries to your Notification Content extension's Info.plist:

| Key | Type | Value |
| --- | --- | --- |
| `NSExtension` > `NSExtensionPrincipalClass` | `String` | `${PRODUCT_MODULE_NAME}.NotificationViewController` |
| `NSExtension` > `NSExtensionAttributes` > `UNNotificationExtensionUserInteractionEnabled` | `Boolean` | `YES` |
| `NSExtension` > `NSExtensionAttributes` > `UNNotificationExtensionDefaultContentHidden` | `Boolean` | `YES` |
| `NSExtension` > `NSExtensionAttributes` > `UNNotificationExtensionCategory` | `String` | `AEPNotification` |
| `NSExtension` > `NSExtensionAttributes` > `UNNotificationExtensionInitialContentSizeRatio` | `Number` | `0.2` |

Note: Replace `NotificationViewController` in the `NSExtensionPrincipalClass` value with your actual view controller class name if different.

## Implementing URL Handling

Override the `handleNotificationClickURL(_:)` method in your custom NotificationViewController to process click URLs:

```swift
class NotificationViewController: AEPNotificationViewController {
    override func handleNotificationClickURL(_ urlString: String?) {
        // Implement your URL handling logic here
        
        // Optional: Remove the notification from the notification center
        if let notificationId = notification?.request.identifier {
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationId])
        }
    }
}
```

Note: The notification removal code shown above is optional. Include it only if you want to automatically dismiss the notification after handling the URL.