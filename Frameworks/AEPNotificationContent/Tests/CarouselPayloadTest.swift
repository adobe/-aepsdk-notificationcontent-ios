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

final class CarouselPayloadTest: XCTestCase {

    func testInit() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_clr_bg": "#FFFFFF",
            "adb_clr_title": "#000000",
            "adb_clr_body": "#AAAAAA",
            "adb_title_ex": "Expanded Title",
            "adb_body_ex": "Expanded Body",
            "adb_car_mode": "manual",
            "adb_car_layout": "filmstrip",
            "adb_items": [
                [
                    "img": "https://example.com/image1.png",
                    "txt": "This is a carousel item 1",
                    "uri": "https://example.com/click1"
                ],
                [
                    "img": "https://example.com/image2.png",
                    "uri": "https://example.com/click2"
                ]
            ]
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload?.carouselItems.count, 2)
        XCTAssertEqual(payload?.carouselItems[0].imageURL, "https://example.com/image1.png")
        XCTAssertEqual(payload?.carouselItems[0].clickURL, "https://example.com/click1")
        XCTAssertEqual(payload?.carouselItems[0].titleBodyPayload.title, "Expanded Title")
        XCTAssertEqual(payload?.carouselItems[0].titleBodyPayload.body, "This is a carousel item 1")
        XCTAssertEqual(payload?.carouselItems[1].imageURL, "https://example.com/image2.png")
        XCTAssertEqual(payload?.carouselItems[1].clickURL, "https://example.com/click2")
        XCTAssertEqual(payload?.carouselItems[1].titleBodyPayload.title, "Expanded Title")
        XCTAssertEqual(payload?.carouselItems[1].titleBodyPayload.body, "Notification Body")

        // verify Carousel Mode
        XCTAssertEqual(payload?.carouselMode, CarouselMode.manual)

        // verify the color properties
        XCTAssertNotNil(payload?.backgroundColor)
        XCTAssertNotNil(payload?.titleColor)
        XCTAssertNotNil(payload?.descriptionColor)
    }

    func testInitWithMissingItems() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_clr_bg": "#FFFFFF",
            "adb_car_mode": "manual",
            "adb_car_layout": "filmstrip"
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify
        XCTAssertNil(payload)
    }

    func testInitWhenCarouselModeIsMissing() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_items": [
                [
                    "img": "https://example.com/image1.png",
                    "txt": "This is a carousel item 1",
                    "uri": "https://example.com/click1"
                ]
            ]
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify auto mode is picked
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload?.carouselMode, CarouselMode.auto)
    }

    func testInitWhenCarouseModeIsMissing() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_items": [
                [
                    "img": "https://example.com/image1.png",
                    "txt": "This is a carousel item 1",
                    "uri": "https://example.com/click1"
                ]
            ]
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify default layout is picked
        XCTAssertNotNil(payload)
    }

    func testInitWhenCarouselItemsIsEmptyArray() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_car_mode": "manual",
            "adb_car_layout": "filmstrip",
            "adb_items": []
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify
        XCTAssertNil(payload)
    }

    func testInitWhenCarouselItemsIsNotArray() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_car_mode": "manual",
            "adb_car_layout": "filmstrip",
            "adb_items": "not an array"
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify
        XCTAssertNil(payload)
    }

    func testInitWhenOneCarouselItemIsInvalid() {
        // Setup
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_items": [
                [
                    "img": "https://example.com/image1.png",
                    "txt": "This is a carousel item 1",
                    "uri": "https://example.com/click1"
                ],
                [
                    "txt": "This is a carousel item 2",
                    "uri": "https://example.com/click2"
                ]
            ]
        ]

        // Test
        let payload = CarouselPayload(from: content)

        // Verify invalid item are filtered out
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload?.carouselItems.count, 1)
    }

}
