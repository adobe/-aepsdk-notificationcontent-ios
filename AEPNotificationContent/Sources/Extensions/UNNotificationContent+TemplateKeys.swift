/*
 Copyright 2024 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import Foundation
import UIKit
import UserNotifications

// UNNotification extension to extract template keys and cast them to the appropriate types
extension UNNotificationContent {
    // MARK: - Basic Template Keys

    // Retrieve the image URL from the notification
    // If a valid image URL is not available, nil is returned
    var imageURL: URL? {
        guard let imageURLString = userInfo[AEPNotificationContentConstants.PayloadKey.IMAGE_URL] as? String else {
            return nil
        }
        return URL(string: imageURLString)
    }

    // Retrieve the click URL from the notification
    // If a valid click URL is not available, nil is returned
    var clickURL: URL? {
        guard let clickURLString = userInfo[AEPNotificationContentConstants.PayloadKey.CLICK_URL] as? String else {
            return nil
        }
        return URL(string: clickURLString)
    }

    // Retrieve the expanded description from the notification
    // If an expanded description is not available, nil is returned
    var expandedBody: String? {
        userInfo[AEPNotificationContentConstants.PayloadKey.Basic.EXPANDED_BODY_TXT] as? String
    }

    // Returns the background color of the notification
    // If a valid background color is not available, defaultBackground color is used
    var backgroundColor: UIColor {
        UNNotificationContent.extractColor(from: self, key: AEPNotificationContentConstants.PayloadKey.BACKGROUND_COLOR,
                                           defaultColor: .defaultBackground)
    }

    // Returns the title color of the notification
    // If a valid title color is not available, defaultTitle color is used
    var titleColor: UIColor {
        UNNotificationContent.extractColor(from: self, key: AEPNotificationContentConstants.PayloadKey.TITLE_COLOR,
                                           defaultColor: .defaultTitle)
    }

    // Returns the body color of the notification
    // If a valid body color is not available, defaultBody color is used
    var bodyColor: UIColor {
        UNNotificationContent.extractColor(from: self, key: AEPNotificationContentConstants.PayloadKey.BODY_COLOR,
                                           defaultColor: .defaultBody)
    }

    // MARK: - Carousel Template Keys

    // Retrieve the carousel layout from the notification
    // If the layout is not available, default Layout is used
    var carouselLayout: CarouselLayout {
        guard let layoutString = userInfo[AEPNotificationContentConstants.PayloadKey.Carousel.LAYOUT] as? String,
              let layout = CarouselLayout(rawValue: layoutString) else {
            return .defaultLayout
        }
        return layout
    }

    // Retrieve the carousel mode from the notification
    // If the mode is not available, defaults to auto
    var carouselMode: CarouselMode {
        guard let modeString = userInfo[AEPNotificationContentConstants.PayloadKey.Carousel.MODE] as? String,
              let mode = CarouselMode(rawValue: modeString) else {
            return .auto
        }
        return mode
    }

    // MARK: - Timer Template Keys

    // Returns the alternate title of timer template
    // If the alternate title is not available, nil is returned
    var alternateTitle: String? {
        userInfo[AEPNotificationContentConstants.PayloadKey.Timer.ALTERNATE_TITLE] as? String
    }

    // Returns the alternate body of timer template
    // If the alternate body is not available, nil is returned
    var alternateBody: String? {
        userInfo[AEPNotificationContentConstants.PayloadKey.Timer.ALTERNATE_BODY] as? String
    }

    // Returns the alternate image URL of timer template
    // If a valid alternate image URL is not available, nil is returned
    var alternateImageURL: URL? {
        guard let alternateImageURLString = userInfo[AEPNotificationContentConstants.PayloadKey.Timer.ALTERNATE_IMAGE] as? String else {
            return nil
        }
        return URL(string: alternateImageURLString)
    }

    // Return the timer color from the notification
    // If a valid timer color is not available, defaultTitle color is used
    var timerColor: UIColor {
        UNNotificationContent.extractColor(from: self, key: AEPNotificationContentConstants.PayloadKey.Timer.COLOR,
                                           defaultColor: .defaultTitle)
    }

    /// Extracts and returns a color from notification content for a specific key.
    /// - Parameters:
    ///   - notificationContent: The notification content to extract from.
    ///   - key: The key for the color information.
    ///   - defaultColor: The default color to return if extraction fails.
    /// - Returns: The extracted color or the default color.
    static func extractColor(from notificationContent: UNNotificationContent, key: String, defaultColor: UIColor) -> UIColor {
        if let colorString = notificationContent.userInfo[key] as? String, let color = UIColor(hexString: colorString) {
            return color
        }
        return defaultColor
    }
}
