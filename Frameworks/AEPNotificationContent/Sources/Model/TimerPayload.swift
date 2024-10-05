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

/// Typealias containing the display data for the TimerTemplate
typealias DisplayData = (imageURL: String?, titleBodyPayload: TitleBodyPayload, shouldShowTimer: Bool)

class TimerPayload: Payload {
    // MARK: - Properties

    /// The title for timer expired view
    var alternateTitle: String

    /// The body for timer expired view
    /// This value is optional
    var alternateBody: String?

    /// The image URL for the timer expired view
    var alternateImageURL: String?

    /// The color of the timer text
    var timerColor: UIColor

    /// The duration of the timer
    var expiryTime: TimeInterval

    /// Current display data for the timer template
    /// If the timer is expired, the alternate view data is given
    /// If the timer is not expired, the non-expired view data is given
    var activeDisplayData: DisplayData {
        if isTimerExpired() {
            return (alternateImageURL ?? imageURL, altTitleBodyPayload, false)
        }
        return (imageURL, titleBodyPayload, true)
    }

    /// title and body of non-expired timer template view
    /// non-expired view title uses value from key  `adb_title_ex`, if unavailable defaults to value from `aps.alert.title`
    /// non-expired view body uses value from key `adb_body_ex`, if unavailable defaults to value from `aps.alert.body`
    lazy var titleBodyPayload: TitleBodyPayload = {
        let title = notificationContent.expandedTitle ?? notificationContent.title
        let body = expandedBody ?? notificationContent.body
        return TitleBodyPayload(title: title, body: body)
    }()

    /// title and body for expired timer template view
    /// expired view title uses value from key `adb_title_alt`
    /// expired view body uses value from key `adb_body_alt`, if unavailable no body is shown
    lazy var altTitleBodyPayload: TitleBodyPayload = {
        let title = alternateTitle
        let body = notificationContent.alternateBody
        return TitleBodyPayload(title: title, body: body)
    }()

    /// Initializes a `TimerPayload` instance from a `UNNotificationContent`.
    /// Initialization fails if the mandatory properties required for TimerTemplate are unavailable
    /// - Parameter notification: The content of the notification.
    required init?(from notificationContent: UNNotificationContent, notificationDate: Date) {
        // Extract the mandatory expired view title
        guard let alternateTitle = notificationContent.alternateTitle else {
            return nil
        }
        // Extract the timer data from the notification
        guard let expiryTime = Self.extractExpiryTime(notificationContent, notificationDate) else {
            return nil
        }

        self.alternateTitle = alternateTitle
        self.alternateBody = notificationContent.alternateBody
        self.alternateImageURL = notificationContent.alternateImageURL
        self.timerColor = notificationContent.timerColor
        self.expiryTime = expiryTime
        super.init(notificationContent: notificationContent)
    }

    /// Extracts the timer information from the notification content
    /// - Parameter notificationContent: The content of the notification
    private static func extractExpiryTime(_ content: UNNotificationContent, _ notificationDate: Date) -> (TimeInterval)? {
        if let duration = content.timerDuration {
            return notificationDate.timeIntervalSince1970 + duration
        } else if let endTimestamp = content.endTimestamp {
            return endTimestamp
        }
        return nil
    }

    private func isTimerExpired() -> Bool {
        let now = Date().timeIntervalSince1970
        return expiryTime - now <= 0
    }
}
