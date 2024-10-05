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

// A class that holds the payload required to build TitleBody View
class TitleBodyPayload {
    // MARK: - Public properties

    /// The title for TitleBodyView
    let title: String

    /// The body for TitleBodyView (optional)
    let body: String?

    // MARK: - Initialization

    init(title: String, body: String?) {
        self.title = title
        self.body = body
    }
}
