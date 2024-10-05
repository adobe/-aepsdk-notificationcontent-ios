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

/// Class representing a Carousel Item
class CarouselItem {
    // MARK: - Properties

    /// The URL string for the carousel item image.
    let imageURL: String
    /// The URL string for the carousel item click action.
    var clickURL: String?
    /// The image data (will be attached after download).
    var image: UIImage?
    /// The title and body text associated with the item.
    let titleBodyPayload: TitleBodyPayload

    // MARK: - Initialization

    /// Initializes a `CarouselItem` instance from a dictionary.
    /// - Parameters:
    ///   - dictionary: A dictionary containing the carousel item data.
    ///   - notificationContent: The UNNotificationContent object.
    /// - Returns: A `CarouselItem` instance if the dictionary contains valid data, `nil` otherwise.
    init?(dictionary: [String: Any], notificationContent: UNNotificationContent) {
        // If no imageURL is provided, do not create the carousel Item object
        guard let imageURL = dictionary[Constants.PayloadKey.Carousel.IMAGE] as? String, !imageURL.isEmpty else {
            return nil
        }
        self.imageURL = imageURL
        self.clickURL = dictionary[Constants.PayloadKey.Carousel.URI] as? String

        /// Set carousel items title and body text
        /// Carousel Item title is same as the notification title
        /// Set the Carousel Item body text if available, otherwise set it to an empty string
        let titleTxt = notificationContent.expandedTitle ?? notificationContent.title
        let bodyTxt = dictionary[Constants.PayloadKey.Carousel.TEXT] as? String ?? notificationContent.body
        self.titleBodyPayload = TitleBodyPayload(title: titleTxt, body: bodyTxt)
    }
}
