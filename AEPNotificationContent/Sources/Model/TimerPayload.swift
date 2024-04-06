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
import UserNotifications
import UIKit

class TimerPayload: Payload {
    
    /// Mark: - Properties
    /// The title text for the timer expired view
    var alternateTitle: String?
    
    /// The body text for the timer expired view
    var alternateBody: String?

    /// The image URL for the timer expired view
    var alternateImageURL: URL
    
    /// The color of the timer text
    var timerColor : UIColor
    
    /// The duration of the timer
    var expiryTime: TimeInterval
    
    /// check with PM
    lazy var titleBodyPayload: TitleBodyPayload = {
        return TitleBodyPayload(title: notificationContent.title, body: self.expandedDescription ?? notificationContent.body)
    }()
    
    /// check with PM
    lazy var altTitleBodyPayload: TitleBodyPayload = {
        return TitleBodyPayload(title: alternateTitle ?? notificationContent.title, body: alternateBody ?? "")
    }()

    /// Initializes a `TimerPayload` instance from a `UNNotificationContent`.
    /// Initialization fails if the mandatory properties required for TimerTemplate are unavailable
    /// - Parameter notification: The content of the notification.
    required init?(from notificationContent: UNNotificationContent, notificationDate : Date) {
        let userInfo = notificationContent.userInfo

        // Extract the alternate image data and fast fail if alternateImage URL is not available
        guard let alternateImageURL = notificationContent.alternateImageURL else {
            return nil
        }
        self.alternateImageURL =  alternateImageURL
        
        // Extract the timer data from the notification
        guard let expiryTime = Self.extractExpiryTime(from: notificationContent, notificationDate: notificationDate) else {
            return nil
        }
        self.expiryTime = expiryTime

        
        // Extract alternate title, body and image URL from the notification
        self.alternateTitle = notificationContent.alternateTitle
        self.alternateBody = notificationContent.alternateBody
        
        // Extract the color of the timer text color from the notification
        self.timerColor = notificationContent.timerColor
        
        super.init(notificationContent: notificationContent)
        // If the imageUrl or alternate image url not available in the notification, bail out
        guard let _ = imageURL else {
            return nil
        }
    }
    
    /// Extracts the timer information from the notification content
    /// - Parameter notificationContent: The content of the notification
    private static func extractExpiryTime(from content: UNNotificationContent, notificationDate: Date) -> (TimeInterval)? {
        let userInfo = content.userInfo
        if let duration = userInfo[AEPNotificationContentConstants.PayloadKey.Timer.DURATION] as? TimeInterval {
            return notificationDate.timeIntervalSince1970 + duration
        } else if let endTimestamp = userInfo[AEPNotificationContentConstants.PayloadKey.Timer.END_TIMESTAMP] as? TimeInterval {
            return endTimestamp
        }
        return nil
    }
}
