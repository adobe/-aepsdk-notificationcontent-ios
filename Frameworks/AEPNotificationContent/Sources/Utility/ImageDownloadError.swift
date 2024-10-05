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

/// Enum representing possible errors that can occur during image downloading.
enum ImageDownloadError: Error {
    /// Error indicating that no URL was provided to download image.
    case noURL

    /// Error indicating that a provided URL string to download image is invalid.
    case invalidURL(url: String)

    /// Error indicating a network-related issue occurred while downloading an image.
    case networkError(url: String, error: Error)

    /// Error indicating that the downloaded data could not be converted into an image.
    case invalidImageData(url: String)

    var description: String {
        switch self {
        case .noURL:
            return "No URL provided"
        case let .invalidURL(url):
            return "Invalid URL: \(url)"
        case let .networkError(url, error):
            return "Network error at \(url): \(error.localizedDescription)"
        case let .invalidImageData(url):
            return "Failed to convert downloaded data to image at \(url)"
        }
    }
}
