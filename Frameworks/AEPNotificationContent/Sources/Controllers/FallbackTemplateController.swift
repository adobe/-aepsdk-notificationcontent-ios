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

class FallbackTemplateController: UIViewController {
    private let SIDE_MARGIN = 8.0
    private let TOP_MARGIN = 8.0

    lazy var titleBodyView: TitleBodyView = {
        let view = TitleBodyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let notificationContent: UNNotificationContent
    private var titleBodyHeight = 0.0

    // MARK: - Initialization

    /// Initializes the FallbackTemplate with the provided notification.
    /// - Parameter notification: The notification to be displayed.
    init(notificationContent: UNNotificationContent) {
        self.notificationContent = notificationContent
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("FallbackTemplate cannot be initialized from storyboard.")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Setup

    /// Sets up the view with the notification content.
    private func setupView() {
        let payload = TitleBodyPayload(title: notificationContent.title,
                                       body: notificationContent.body)

        titleBodyView.setupWith(payload: payload, viewWidth: view.frame.width - (2 * SIDE_MARGIN))
        titleBodyHeight = titleBodyView.viewHeight
        view.addSubview(titleBodyView)

        NSLayoutConstraint.activate([
            titleBodyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: TOP_MARGIN),
            titleBodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SIDE_MARGIN),
            titleBodyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SIDE_MARGIN),
            titleBodyView.heightAnchor.constraint(equalToConstant: titleBodyHeight)
        ])

        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        preferredContentSize.height = titleBodyHeight + (2 * TOP_MARGIN)
    }
}
