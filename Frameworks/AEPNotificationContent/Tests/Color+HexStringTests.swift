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
import XCTest
@testable import AEPNotificationContent

final class ColorHexStringTests: XCTestCase {

    func testColorCreation_withValid_hexString_withoutAlpha() {
        // 6-digit hex string (no alpha)
        let color = UIColor(hexString: "#FF5733")
        var red, green, blue, alpha: CGFloat
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 1.0, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 0.34, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 0.20, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Alpha component does not match")
    }

    func testColorCreation_basicColors() {
        // 6-digit hex white color
        var color = UIColor(hexString: "#FFFFFF")
        var red, green, blue, alpha: CGFloat
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 1.0, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 1.0, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 1.0, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Alpha component does not match")

        // 6-digit hex black color
        color = UIColor(hexString: "#000000")
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 0.0, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 0.0, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 0.0, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Alpha component does not match")

        // 6-digit hex red color
        color = UIColor(hexString: "#FF0000")
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 1.0, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 0.0, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 0.0, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Alpha component does not match")

        // 6-digit hex green color
        color = UIColor(hexString: "#00FF00")
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 0.0, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 1.0, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 0.0, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Alpha component does not match")

        // 6-digit hex blue color
        color = UIColor(hexString: "#0000FF")
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 0.0, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 0.0, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 1.0, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 1.0, accuracy: 0.01, "Alpha component does not match")
    }

    func testColorCreation_fromValidHexWithAlpha() {
        // 8-digit hex string (with alpha)
        let color = UIColor(hexString: "#23FB8AD9")
        var red, green, blue, alpha: CGFloat
        (red, green, blue, alpha) = (0, 0, 0, 0)
        color?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        // verify
        XCTAssertEqual(red, 0.13, accuracy: 0.01, "Red component does not match")
        XCTAssertEqual(green, 0.98, accuracy: 0.01, "Green component does not match")
        XCTAssertEqual(blue, 0.54, accuracy: 0.01, "Blue component does not match")
        XCTAssertEqual(alpha, 0.85, accuracy: 0.01, "Alpha component does not match")
    }

    func testColorCreation_when_tooShortInput() {
        XCTAssertNil(UIColor(hexString: "#123"))
    }

    func testColorCreation_when_tooLongInput() {
        XCTAssertNil(UIColor(hexString: "#123456789"))
    }

    func testColorCreation_when_invalidCharacters() {
        XCTAssertNil(UIColor(hexString: "#ZZZZZZ"))
    }

    func testColorCreation_withoutHash() {
        XCTAssertNotNil(UIColor(hexString: "FF5733"))
    }

}
