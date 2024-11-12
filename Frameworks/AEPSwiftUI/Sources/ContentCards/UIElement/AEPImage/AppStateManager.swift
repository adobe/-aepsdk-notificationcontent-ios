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

import AEPServices
import Foundation
import UIKit

final class AppStateManager {
    static let shared = AppStateManager()

    /// The shared instance of `AppStateManager` used to access the singleton instance throughout the app.
    private(set) var isAppInBackground = false

    /// A Boolean value indicating whether the app is currently in the background.
    /// This property is updated automatically through system notifications and should be accessed only for reading.
    private init() {
        Log.debug(label: Constants.LOG_TAG, "Initializing AppStateManager")
        setupNotifications()
    }

    /// Sets up notifications to observe changes in the app’s state:
    /// - Observes when the app enters the background and calls `didEnterBackground`.
    /// - Observes when the app is about to enter the foreground and calls `willEnterForeground`.
    private func setupNotifications() {
        // Observes when the app enters the background
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )

        // Observes when the app is about to enter the foreground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
    }

    /// Called when the app enters the background.
    /// Updates `isAppInBackground` to `true`
    @objc private func didEnterBackground() {
        Log.debug(label: Constants.LOG_TAG, "AppStateManager didEnterBackground notification received. Changing isAppInBackground flag to true.")
        isAppInBackground = true
    }

    /// Called when the app is about to enter the foreground.
    /// Updates `isAppInBackground` to `false`
    @objc private func willEnterForeground() {
        Log.debug(label: Constants.LOG_TAG, "AppStateManager willEnterForeground notification received. Changing isAppInBackground flag to false.")
        isAppInBackground = false
    }

    /// Cleans up observers when `AppStateManager` is deallocated.
    deinit {
        // Remove observers when the instance is deallocated
        NotificationCenter.default.removeObserver(self)
    }
}
