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

import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        var hexString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        // Ensure hex string is in 6- or 8-digit format
        guard hexString.count == 6 || hexString.count == 8 else {
            return nil
        }

        // Check for valid hexadecimal characters
        let validHexChars = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        guard CharacterSet(charactersIn: hexString).isSubset(of: validHexChars) else {
            return nil
        }

        // Create scanner for hex string
        var color: UInt64 = 0
        let scanner = Scanner(string: hexString)
        scanner.scanHexInt64(&color)

        // bit shifting for picking the correct component
        let mask = 0x0000_00FF
        var r, g, b, a: Int
        if hexString.count == 8 {
            // 8-digit hex (including alpha)
            r = Int(color >> 24) & mask
            g = Int(color >> 16) & mask
            b = Int(color >> 8) & mask
            a = Int(color) & mask
        } else {
            // 6-digit hex
            a = 255
            r = Int(color >> 16) & mask
            g = Int(color >> 8) & mask
            b = Int(color) & mask
        }
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        let alpha = CGFloat(a) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static var defaultBackground: UIColor {
        if #available(iOS 13.0, *) {
            return .systemBackground
        } else {
            return .white
        }
    }

    static var defaultTitle: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }

    static var defaultBody: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .darkGray
        }
    }
}
