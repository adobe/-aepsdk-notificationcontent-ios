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

import XCTest
@testable import AEPNotificationContent

final class PayloadTests: XCTestCase {

    func testInitialization_with_allValidNotificationContent() {
        // Create a mock UNNotificationContent with all necessary fields
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_clr_bg": "#FFFFFF",
            "adb_clr_title": "#000000",
            "adb_clr_body": "#AAAAAA",
            "adb_body_ex": "Expanded Description"
        ]

        // Initialize Payload
        let payload = Payload(notificationContent: content)

        // Assert that all properties are correctly set
        XCTAssertEqual(payload.imageURL, "https://example.com/image.png")
        XCTAssertEqual(payload.clickURL, "https://example.com/click")
        XCTAssertEqual(payload.expandedBody, "Expanded Description")

        // verify color properties
        var red, green, blue, alpha: CGFloat
        (red, green, blue, alpha) = (0, 0, 0, 0)
        payload.backgroundColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify background color
        XCTAssertEqual(red, 1.0, accuracy: 0.01, "Background Color Red component does not match")
        XCTAssertEqual(green, 1.0, accuracy: 0.01, "Background Color Green component does not match")
        XCTAssertEqual(blue, 1.0, accuracy: 0.01, "Background Color Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Background Color Alpha component does not match")

        // verify title color
        (red, green, blue, alpha) = (0, 0, 0, 0)
        payload.titleColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 0.0, accuracy: 0.01, "Title Color Red component does not match")
        XCTAssertEqual(green, 0.0, accuracy: 0.01, "Title Color Green component does not match")
        XCTAssertEqual(blue, 0.0, accuracy: 0.01, "Title Color Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Title Color Alpha component does not match")

        // verify body color
        (red, green, blue, alpha) = (0, 0, 0, 0)
        payload.descriptionColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 0.67, accuracy: 0.01, "Body Color Red component does not match")
        XCTAssertEqual(green, 0.67, accuracy: 0.01, "Body Color Green component does not match")
        XCTAssertEqual(blue, 0.67, accuracy: 0.01, "Body Color Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Body Color Alpha component does not match")
    }

    func testInitialization_when_noColorDataInNotification() {
        // Create a mock UNNotificationContent with all necessary fields
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_clr_bg": "invalid",
            "adb_clr_body": "invalid",
            "adb_body_ex": "Expanded Description"
        ]

        // Initialize Payload
        let payload = Payload(notificationContent: content)

        // Assert the other parameters are correctly set
        XCTAssertEqual(payload.imageURL, "https://example.com/image.png")
        XCTAssertEqual(payload.clickURL, "https://example.com/click")
        XCTAssertEqual(payload.expandedBody, "Expanded Description")

        // verify defaults colors are picked
        XCTAssertEqual(payload.backgroundColor, UIColor.defaultBackground)
        XCTAssertEqual(payload.titleColor, UIColor.defaultTitle)
        XCTAssertEqual(payload.descriptionColor, UIColor.defaultBody)
    }

    func testInitialization_with_noClickURL_noMediaURL_noExpandedTextProvided() {
        // Create a mock UNNotificationContent with all necessary fields
        let content = UNMutableNotificationContent()
        content.userInfo = [:]

        // Initialize Payload
        let payload = Payload(notificationContent: content)

        // Assert that payload is initialized with nil values
        XCTAssertNil(payload.imageURL)
        XCTAssertNil(payload.clickURL)
        XCTAssertNil(payload.expandedBody)
    }

}
