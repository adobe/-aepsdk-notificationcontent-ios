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

class CarouselPayload: Payload {
    // MARK: - Properties

    /// The mode of the carousel.
    let carouselMode: CarouselMode

    /// The items in the carousel.
    var carouselItems: [CarouselItem] = []

    /// Initializes a `CarouselPayload` instance from a `UNNotificationContent`.
    /// Initialization fails if the mandatory properties required for CarouselTemplate are unavailable.
    /// - Parameter notificationContent: The content of the notification.
    required init?(from notificationContent: UNNotificationContent) {
        let userInfo = notificationContent.userInfo

        self.carouselMode = notificationContent.carouselMode

        // Retrieve the carousel items from the notification
        if let itemsArray = userInfo[Constants.PayloadKey.Carousel.ITEMS] as? [[String: Any]] {
            // Filter out invalid items
            self.carouselItems = itemsArray.compactMap { itemDict in
                CarouselItem(dictionary: itemDict, notificationContent: notificationContent)
            }

            // If no valid carouselItems exist, the array will be empty, return nil
            guard !self.carouselItems.isEmpty else { return nil }

        } else {
            return nil
        }

        super.init(notificationContent: notificationContent)
    }
}
