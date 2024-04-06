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
import UserNotifications
import UserNotificationsUI

open class AEPNotificationViewController: UIViewController, UNNotificationContentExtension, TemplateControllerDelegate {
    var notification: UNNotification?

    // MARK: - UNNotificationContentExtension delegate methods

    /// This method is called in the main thread of the notification content app extension
    public func didReceive(_ notification: UNNotification) {
        self.notification = notification
        let notificationContent = notification.request.content

        /// Extract the template type from the notification content
        guard let notificationUserInfo = notification.request.content.userInfo as? [String: AnyObject],
              let templateType = notificationUserInfo[AEPNotificationContentConstants.PayloadKey.TEMPLATE_TYPE] as? String,
              let payload = createPayload(for: templateType, from: notification)
        else {
            displayFallbackTemplate(notificationContent)
            return
        }

        /// Create a controller based on the template type
        let controller: UIViewController
        if let basicPayload = payload as? BasicPayload {
            controller = BasicTemplateController(withPayload: basicPayload, delegate: self)
        } else if let carouselPayload = payload as? CarouselPayload {
            controller = CarouselTemplateController(withPayload: carouselPayload, delegate: self)
        } else {
            controller = FallbackTemplateController(notificationContent: notificationContent)
        }

        /// Add the controller and its view as a child to the AEPNotificationViewController
        addChild(controller)
        view.addSubview(controller.view)
    }

    public func didReceive(_: UNNotificationResponse, completionHandler _: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {}

    // MARK: - UIViewController delegate methods

    /// Called after the controller's view is loaded into memory
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    /// Called when the preferred content size of one of the view controller's child content containers changes
    override open func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        preferredContentSize.height = container.preferredContentSize.height
    }

    // MARK: - Private methods

    /// Create a payload object based on the template type
    /// Returns nil if the template type is not supported or if the payload object could not be created
    /// - Parameters:
    ///   - templateType: String representing the template type
    ///   - notification: the received notification
    /// - Returns: the appropriate Payload object
    private func createPayload(for templateType: String, from notification: UNNotification) -> Payload? {
        let content = notification.request.content
        switch templateType {
        case AEPNotificationContentConstants.PayloadKey.TemplateType.BASIC:
            return BasicPayload(from: content)
        case AEPNotificationContentConstants.PayloadKey.TemplateType.CAROUSEL:
            return CarouselPayload(from: content)
        case AEPNotificationContentConstants.PayloadKey.TemplateType.TIMER:
            return TimerPayload(from: content, notificationDate: notification.date)
        default:
            return nil
        }
    }

    /// Use this method to display a fallback template
    /// This method is called when the template fails to load for any reason
    /// - Parameter notificationContent - UNNotificationContent object
    private func displayFallbackTemplate(_ notificationContent: UNNotificationContent) {
        let fallback = FallbackTemplateController(notificationContent: notificationContent)
        addChild(fallback)
        view.addSubview(fallback.view)
    }

    // MARK: - TemplateControllerDelegate

    // This method is called when the template failed to load
    // A template can fail if there are issues in downloading images, parsing the payload, etc.
    // In this case, we display a fallback template
    func templateFailedToLoad() {
        guard let notification = self.notification else { return }
        displayFallbackTemplate(notification.request.content)
    }

    // Use this method to get the instance of the parent view controller
    func getParentViewController() -> UIViewController {
        self
    }
}
