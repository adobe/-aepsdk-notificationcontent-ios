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

final class BasicPayloadTests: XCTestCase {

    func testInit_when_validBasicPayload() {
        // Create a mock UNNotificationContent with all necessary fields
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_clr_bg": "#FFFFFF",
            "adb_clr_title": "#000000",
            "adb_clr_body": "#AAAAAA",
            "adb_body_ex": "Expanded Body"
        ]

        // Initialize Payload
        let payload = BasicPayload(from: content)

        // Assert that all properties are correctly set
        XCTAssertEqual(payload?.imageURL, "https://example.com/image.png")
        XCTAssertEqual(payload?.clickURL, "https://example.com/click")

        // verify title and body
        XCTAssertEqual(payload?.titleBodyPayload.title, "Notification Title")
        XCTAssertEqual(payload?.titleBodyPayload.body, "Expanded Body")
    }

    func testInit_when_expandedTitle_unavailable() {
        // Create a mock UNNotificationContent
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click",
            "adb_body_ex": "Expanded Body"
        ]

        // Initialize Payload
        let payload = BasicPayload(from: content)

        // verify title and body picked from the notification
        XCTAssertEqual(payload?.titleBodyPayload.title, "Notification Title")
    }

    func testInit_when_expandedBody_unavailable() {
        // Create a mock UNNotificationContent with all necessary fields
        let content = UNMutableNotificationContent()
        content.body = "Notification body"
        content.userInfo = [
            "adb_title_ex": "Expanded Title",
            "adb_media": "https://example.com/image.png",
            "adb_uri": "https://example.com/click"
        ]

        // Initialize Payload
        let payload = BasicPayload(from: content)

        // verify title and body picked from the notification
        XCTAssertEqual(payload?.titleBodyPayload.title, "Expanded Title")
        XCTAssertEqual(payload?.titleBodyPayload.body, "Notification body")
    }

    func testInit_when_imageURL_notAvailable() {
        // Create a mock UNNotificationContent with all necessary fields
        let content = UNMutableNotificationContent()
        content.title = "Notification Title"
        content.body = "Notification Body"
        content.userInfo = [
            "adb_uri": "https://example.com/click",
            "adb_body_ex": "Expanded Body"
        ]

        // Initialize Payload
        let payload = BasicPayload(from: content)

        // verify payload is formed when image url is not available
        // Basic payload can be displayed without image
        XCTAssertNotNil(payload)
    }
}
