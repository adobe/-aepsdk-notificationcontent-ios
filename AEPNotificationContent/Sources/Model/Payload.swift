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

// A class that extracts and loads the base properties for building push templates
class Payload {
    // MARK: Public properties

    /// The image URL for the notification.
    let imageURL: URL?

    /// The click URL for the notification.
    let clickURL: URL?

    /// The content of the notification.
    let notificationContent: UNNotificationContent

    /// The title color for the expanded view.
    let titleColor: UIColor

    /// The description color for the expanded view.
    let descriptionColor: UIColor

    /// The background color of the notification.
    var backgroundColor: UIColor

    /// The description text for the expanded view
    var expandedDescription: String?

    // MARK: - Initialization

    /// Initializes a `BasicPayload` instance from a `UNNotificationContent`.
    /// Initialization fails if the mandatory properties required for BasicTemplate are unavailable
    /// - Parameter notificationContent: The content of the notification.
    init(notificationContent: UNNotificationContent) {
        self.notificationContent = notificationContent

        self.imageURL = notificationContent.imageURL
        self.clickURL = notificationContent.clickURL
        self.expandedDescription = notificationContent.expandedBody

        // Extract the color data
        self.backgroundColor = notificationContent.backgroundColor
        self.titleColor = notificationContent.titleColor
        self.descriptionColor = notificationContent.bodyColor
    }
}
