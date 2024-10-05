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

final class TimerPayloadTests: XCTestCase {

    func testInit_with_validPayload() {
        // setup
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_media": "https://www.adobe.com/image0.jpg",
            "adb_title_ex": "title",
            "adb_body_ex": "body",
            "adb_tmr_dur": "10",
            "adb_title_alt": "expired title",
            "adb_body_alt": "expired body",
            "adb_media_alt": "https://www.adobe.com/image1.jpg"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify
        XCTAssertNotNil(timerPayload)
        XCTAssertNotNil(timerPayload?.expiryTime)
        XCTAssertEqual(timerPayload?.titleBodyPayload.title, "title")
        XCTAssertEqual(timerPayload?.titleBodyPayload.body, "body")
        XCTAssertEqual(timerPayload?.altTitleBodyPayload.title, "expired title")
        XCTAssertEqual(timerPayload?.altTitleBodyPayload.body, "expired body")
        XCTAssertEqual(timerPayload?.imageURL, "https://www.adobe.com/image0.jpg")
        XCTAssertEqual(timerPayload?.alternateImageURL, "https://www.adobe.com/image1.jpg")
    }

    // MARK: - Image Keys tests

    func testInit_without_alternateImageURL() {
        // setup
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_tmr_dur": "10",
            "adb_title_alt": "expired title",
            "adb_body_alt": "expired body"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify that the payload instance is still created
        XCTAssertNotNil(timerPayload)
    }

    // MARK: - Title and Body Keys tests

    func testInit_without_alternateTitle() {
        // setup
        let content = UNMutableNotificationContent()
        content.title = "notification title"
        content.userInfo = [
            "adb_tmr_dur": "10",
            "adb_body_alt": "expired body"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify
        XCTAssertNil(timerPayload)
    }

    func testInit_without_alternateBody() {
        // setup
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_tmr_dur": "10",
            "adb_title_alt": "expired title"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify
        XCTAssertNotNil(timerPayload)
        XCTAssertNil(timerPayload?.altTitleBodyPayload.body)
    }

    func testInit_without_expandedTitle() {
        // setup
        let content = UNMutableNotificationContent()
        content.title = "notification title"
        content.userInfo = [
            "adb_tmr_dur": "10",
            "adb_body_ex": "body",
            "adb_title_alt": "expired title"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify that the actual notifications title is used instead
        XCTAssertNotNil(timerPayload)
        XCTAssertEqual(timerPayload?.titleBodyPayload.title, "notification title")
    }

    func testInit_without_expandedBody() {
        // setup
        let content = UNMutableNotificationContent()
        content.body = "notification body"
        content.userInfo = [
            "adb_tmr_dur": "10",
            "adb_title_alt": "expired title"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify that the notification's body is used instead
        XCTAssertNotNil(timerPayload)
        XCTAssertEqual(timerPayload?.titleBodyPayload.body, "notification body")
    }

    // MARK: - Timer keys tests

    func testInit_with_timerDuration() {
        // setup
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_media": "https://www.adobe.com/image0.jpg",
            "adb_tmr_dur": "10",
            "adb_title_alt": "alternate title",
            "adb_body_ex_alt": "alternate body",
            "adb_media_alt": "https://www.adobe.com/image1.jpg"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify
        XCTAssertNotNil(timerPayload)
        XCTAssertEqual(timerPayload!.expiryTime, Date().timeIntervalSince1970 + 10, accuracy: 2.0)
    }

    func testInit_with_endTimestamp() {
        // setup
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_media": "https://www.adobe.com/image0.jpg",
            "adb_tmr_end": "1712417524",
            "adb_title_alt": "alternate title",
            "adb_body_ex_alt": "alternate body",
            "adb_media_alt": "https://www.adobe.com/image1.jpg"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify
        XCTAssertNotNil(timerPayload)
        XCTAssertEqual(timerPayload!.expiryTime, 1712417524)
    }

        func testInit_without_expiryTime() {
        // setup
        let content = UNMutableNotificationContent()
        content.userInfo = [
            "adb_title_alt": "alternate title",
            "adb_body_ex_alt": "alternate body"
        ]

        // test
        let timerPayload = TimerPayload(from: content, notificationDate: Date())

        // verify
        XCTAssertNil(timerPayload)
    }

}
