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

class TimerTemplateController: TemplateController {
    let TIMER_LABEL_WIDTH = 75.0

    private let payload: TimerPayload
    private var countdownTimer: Timer?

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .defaultTitle
        if #available(iOS 13.0, *) {
            label.font = UIFont.monospacedSystemFont(ofSize: 20.0, weight: .medium)
        } else {
            label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        }
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "AEPTimerLabel"
        return label
    }()

    lazy var titleBodyView: TitleBodyView = {
        let view = TitleBodyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "AEPTimerImage"
        return view
    }()

    override var clickURL: String? {
        payload.clickURL
    }

    private var titleBodyHeight = 0.0
    private var imageViewHeight = 0.0

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Timer Template Controller cannot be initialized with Storyboard")
    }

    init(withPayload payload: TimerPayload, delegate: TemplateControllerDelegate) {
        self.payload = payload
        super.init(delegate: delegate)
    }

    override func viewDidLoad() {
        buildView()
    }

    private func buildView() {
        showLoadingIndicator()
        let displayData = payload.activeDisplayData
        ImageDownloader().downloadImage(url: displayData.imageURL, completion: { [weak self] downloadedImage in
            guard let self = self else { return }
            removeLoadingIndicator()
            setupView(downloadedImage, displayData)
            activateTapGesture()
        })
    }

    private func setupView(_ image: UIImage?, _ displayData: DisplayData) {
        // Add imageView to UI only if image is downloaded
        if let image = image {
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

        // Update constraints for titleBodyView based on whether or not the imageView exists
        let imageViewBottomAnchor = image != nil ? imageView.bottomAnchor : view.safeAreaLayoutGuide.topAnchor
        var titleViewTrailingAnchor = view.trailingAnchor
        var titleBodyViewWidth = view.frame.width - (2 * SIDE_MARGIN)

        if displayData.shouldShowTimer {
            view.addSubview(timerLabel)
            timerLabel.textColor = payload.timerColor
            NSLayoutConstraint.activate([
                timerLabel.topAnchor.constraint(equalTo: imageViewBottomAnchor, constant: TOP_MARGIN),
                timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -SIDE_MARGIN),
                timerLabel.widthAnchor.constraint(equalToConstant: TIMER_LABEL_WIDTH),
                timerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            titleViewTrailingAnchor = timerLabel.leadingAnchor
            titleBodyViewWidth = titleBodyViewWidth - TIMER_LABEL_WIDTH - SIDE_MARGIN
            updateCountdown()
            startCountdown()
        }

        titleBodyView.setupWith(payload: displayData.titleBodyPayload, viewWidth: titleBodyViewWidth)
        titleBodyView.changeColor(from: payload)
        titleBodyHeight = titleBodyView.viewHeight
        view.addSubview(titleBodyView)
        NSLayoutConstraint.activate([
            titleBodyView.topAnchor.constraint(equalTo: imageViewBottomAnchor, constant: TOP_MARGIN),
            titleBodyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: SIDE_MARGIN),
            titleBodyView.trailingAnchor.constraint(equalTo: titleViewTrailingAnchor, constant: 0),
            titleBodyView.heightAnchor.constraint(equalToConstant: titleBodyHeight)
        ])

        view.backgroundColor = payload.backgroundColor
        updatePreferredContentSize()
    }

    private func startCountdown() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc func updateCountdown() {
        let now = Date().timeIntervalSince1970
        let countdown = payload.expiryTime - now

        if countdown <= 0 {
            // Countdown has finished
            countdownTimer?.invalidate()
            countdownTimer = nil
            removeAllViews()
            buildView()
        } else {
            // Update countdown label
            let hours = Int(countdown) / 3600
            let minutes = Int(countdown) / 60 % 60
            let seconds = Int(countdown) % 60
            if hours >= 1 {
                timerLabel.text = String(format: "%02i:%02i:%02i", hours, minutes, seconds)
            } else {
                timerLabel.text = String(format: "%02i:%02i", minutes, seconds)
            }
        }
    }

    private func removeAllViews() {
        imageView.removeFromSuperview()
        timerLabel.removeFromSuperview()
        titleBodyView.removeFromSuperview()
    }

    private func updatePreferredContentSize() {
        preferredContentSize.height = titleBodyHeight + imageViewHeight + (2 * TOP_MARGIN)
        parent?.preferredContentSize.height = titleBodyHeight + imageViewHeight + (2 * TOP_MARGIN)
    }
}
