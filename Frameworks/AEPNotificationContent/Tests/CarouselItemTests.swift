//
// Copyright 2024 Adobe. All rights reserved.
// This file is licensed to you under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy
// of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
// OF ANY KIND, either express or implied. See the License for the specific language
// governing permissions and limitations under the License.
//

import Foundation
import XCTest
@testable import AEPNotificationContent

final class CarouselItemTests: XCTestCase {

    func testInit_happy() {
        // setup
        let dictionary: [String: Any] = [
            "img": "https://www.adobe.com/image.png",
            "txt": "This is a carousel item",
            "uri": "https://www.adobe.com"
        ]
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "This is a title"
        notificationContent.userInfo = ["adb_title_ex": "Expanded Title"]

        // test
        let carouselItem = CarouselItem(dictionary: dictionary, notificationContent: notificationContent)

        // verify
        XCTAssertNotNil(carouselItem)
        XCTAssertEqual(carouselItem?.imageURL, "https://www.adobe.com/image.png")
        XCTAssertEqual(carouselItem?.clickURL, "https://www.adobe.com")
        XCTAssertEqual(carouselItem?.titleBodyPayload.title, "Expanded Title")
        XCTAssertEqual(carouselItem?.titleBodyPayload.body, "This is a carousel item")
    }

    func testInit_when_invalidImageURL() {
        // setup
        let dictionary: [String: Any] = [
            "img": "",
            "txt": "This is a carousel item",
            "uri": "https://www.adobe.com"
        ]
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = ["adb_title_ex": "Expanded Title"]

        // test
        let carouselItem = CarouselItem(dictionary: dictionary, notificationContent: notificationContent)

        // verify
        XCTAssertNil(carouselItem)
    }

    func testInit_with_missingBody() {
        // setup
        let dictionary: [String: Any] = [
            "img": "https://www.adobe.com/image.png",
            "uri": "https://www.adobe.com"
        ]
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = ["adb_title_ex": "Expanded Title"]

        // test
        let carouselItem = CarouselItem(dictionary: dictionary, notificationContent: notificationContent)

        // verify
        XCTAssertNotNil(carouselItem)
        XCTAssertEqual(carouselItem?.titleBodyPayload.body, "")
    }

    func testInit_with_invalidBody() {
        // setup
        let dictionary: [String: Any] = [
            "img": "https://www.adobe.com/image.png",
            "txt": 123,
            "uri": "https://www.adobe.com"
        ]
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = ["adb_title_ex": "Expanded Title"]

        // test
        let carouselItem = CarouselItem(dictionary: dictionary, notificationContent: notificationContent)

        // verify
        XCTAssertNotNil(carouselItem)
        XCTAssertEqual(carouselItem?.titleBodyPayload.body, "")
    }

    func testInit_with_noClickURL() {
        // setup
        let dictionary: [String: Any] = [
            "img": "https://www.adobe.com/image.png",
            "txt": "This is a carousel item",
            "uri": ""
        ]
        let notificationContent = UNMutableNotificationContent()
        notificationContent.userInfo = ["adb_title_ex": "Expanded Title"]

        // test
        let carouselItem = CarouselItem(dictionary: dictionary, notificationContent: notificationContent)

        // verify the carousel item is created
        XCTAssertNotNil(carouselItem)
    }

    func testInit_with_noExpandedTitle() {
        // setup
        let dictionary: [String: Any] = [
            "img": "https://www.adobe.com/image.png",
            "txt": "This is a carousel item",
            "uri": "https://www.adobe.com"
        ]
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "This is a title"

        // test
        let carouselItem = CarouselItem(dictionary: dictionary, notificationContent: notificationContent)

        // verify
        XCTAssertNotNil(carouselItem)
        XCTAssertEqual(carouselItem?.titleBodyPayload.title, "This is a title")
    }
}
