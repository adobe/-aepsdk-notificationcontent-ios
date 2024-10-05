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

// Base class for all template controllers
// This class provides all the common methods and properties that are required by all the template controllers
class TemplateController: UIViewController {
    // MARK: - Margin constants

    let SIDE_MARGIN = 8.0
    let TOP_MARGIN = 10.0

    // MARK: - UI Elements

    lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .medium
        } else {
            loadingIndicator.style = .white
        }
        loadingIndicator.color = .defaultTitle
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.center = self.view.center
        return loadingIndicator
    }()

    /// Default click URL for the notification
    /// Override this property in the subclass to provide a clickURL for the particular template
    var clickURL: String? {
        nil
    }

    var tapRecognizer: UITapGestureRecognizer?

    let delegate: TemplateControllerDelegate

    // MARK: - Initializers

    init(delegate: TemplateControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("BaseTemplateController cannot be initialized from storyboard.")
    }

    func activateTapGesture() {
        guard tapRecognizer == nil else { return }
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
        view.addGestureRecognizer(tapRecognizer!)
    }

    // MARK: - Loading Indicator methods

    func showLoadingIndicator() {
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        self.view.bringSubviewToFront(loadingIndicator)
        loadingIndicator.startAnimating()
    }

    func removeLoadingIndicator() {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.removeFromSuperview()
    }

    @objc func tapped() {
        delegate.handleNotificationClickURL(clickURL)
    }
}
