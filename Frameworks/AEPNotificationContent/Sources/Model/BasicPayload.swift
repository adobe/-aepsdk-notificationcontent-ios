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

/// A class that represents the payload required to build BasicTemplate
class BasicPayload: Payload {
    // MARK: - Public properties

    /// The title and body for BasicTemplate
    var titleBodyPayload: TitleBodyPayload {
        let titleText = expandedTitle ?? notificationContent.title
        let bodyText = expandedBody ?? notificationContent.body
        let titleBodyPayload = TitleBodyPayload(title: titleText,
                                                body: bodyText)
        return titleBodyPayload
    }

    // MARK: - Initialization

    /// Initializes a `BasicPayload` instance from a `UNNotificationContent`.
    /// Initialization fails if the mandatory properties required for BasicTemplate are unavailable
    /// - Parameter notificationContent: The content of the notification.
    required init?(from notificationContent: UNNotificationContent) {
        super.init(notificationContent: notificationContent)
    }
}
