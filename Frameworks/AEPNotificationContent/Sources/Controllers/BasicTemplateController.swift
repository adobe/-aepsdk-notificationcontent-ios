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

// UI Recommendations
// Title  : Characters per line : 35-40
// Title : Recommended maximum title length : 35
// Title : Multiple lines supported : No
// Description : Characters per line : 50-60
// Description : Recommended number of characters : 250
// Description : Multiple lines supported : Yes
// Image : Required aspect ratio :  2:1
// Image : Recommended dimensions : 600x300
// Image : Recommended size : 40KB
// Image : Recommended formats : png, jpg, webp

// ViewController for Basic Template
class BasicTemplateController: TemplateController {
    // MARK: - Properties

    private let payload: BasicPayload

    // MARK: - Height properties

    private var titleBodyHeight = 0.0
    private var imageViewHeight = 0.0

    // MARK: - UI Elements

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "AEPBasicTemplateImage"
        return imageView
    }()

    lazy var titleBodyView: TitleBodyView = {
        let view = TitleBodyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override var clickURL: String? {
        payload.clickURL
    }

    // MARK: - Initializers

    init(withPayload payload: BasicPayload, delegate: TemplateControllerDelegate) {
        self.payload = payload
        super.init(delegate: delegate)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("BasicTemplateController cannot be initialized from storyboard.")
    }

    // MARK: - ViewController lifecycle method

    override func viewDidLoad() {
        // show loading indicator until the image is downloaded
        showLoadingIndicator()
        ImageDownloader().downloadImage(url: payload.imageURL, completion: { [weak self] downloadImage in
            guard let self = self else { return }
            removeLoadingIndicator()
            setupView(withImage: downloadImage)
            activateTapGesture()
        })
    }

    // MARK: - Private methods

    /// Configure and setup the view with the downloaded image
    /// - Parameter downloadedImage: UIImage object
    private func setupView(withImage downloadedImage: UIImage?) {
        // Add imageView to template UI only if image is downloaded
        if let image = downloadedImage {
            imageView.image = image
            view.addSubview(imageView)

            /// keeping height of the image view as half of the notification width.
            /// This is to maintain the recommended aspect ratio of 2:1
            imageViewHeight = (view.frame.width / 2)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                imageView.heightAnchor.constraint(equalToConstant: view.frame.width / 2)
            ])
        }

        titleBodyView.setupWith(payload: payload.titleBodyPayload, viewWidth: view.frame.width - (2 * SIDE_MARGIN))
        titleBodyView.changeColor(from: payload)
        titleBodyView.translatesAutoresizingMaskIntoConstraints = false
        titleBodyHeight = titleBodyView.viewHeight
        view.addSubview(titleBodyView)

        // Update constraints for titleBodyView based on whether or not the imageView exists
        let titleBodyViewTopAnchor = downloadedImage != nil ? imageView.bottomAnchor : view.safeAreaLayoutGuide.topAnchor
        NSLayoutConstraint.activate([
            titleBodyView.topAnchor.constraint(equalTo: titleBodyViewTopAnchor, constant: TOP_MARGIN),
            titleBodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SIDE_MARGIN),
            titleBodyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SIDE_MARGIN),
            titleBodyView.heightAnchor.constraint(equalToConstant: titleBodyHeight)
        ])

        view.backgroundColor = payload.backgroundColor
        updatePreferredContentSize()
    }

    /// Update the preferred content size of the view controller
    private func updatePreferredContentSize() {
        preferredContentSize.height = titleBodyHeight + imageViewHeight + (2 * TOP_MARGIN)
        parent?.preferredContentSize.height = titleBodyHeight + imageViewHeight + (2 * TOP_MARGIN)
    }
}
