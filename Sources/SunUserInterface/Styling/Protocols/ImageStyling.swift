//
//  ImageStyling.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public protocol ImageStyling {
    var tokens: ImageTokens { get }
    var image: Image { get }
    var name: String { get }
    var bundle: Bundle { get }
    var definingBundle: Bundle { get }
}

extension ImageStyling {
    public var tokens: ImageTokens { .empty }
    public var bundle: Bundle { .main }
    public var definingBundle: Bundle { .main }

    public var image: Image {
        if let image = fetchImage(name) { return image }
        #if canImport(UIKit)
        return Image(uiImage: UIImage())
        #elseif canImport(AppKit)
        return Image(nsImage: NSImage(size: .zero))
        #else
        return Image(decorative: name, bundle: bundle)
        #endif
    }

    public func image(directory: String) -> Image {
        let path = "\(directory)/\(name)"
        if let image = fetchImage(path) { return image }
        let parent = directory.split(separator: "/").dropLast().joined(separator: "/")
        return parent.isEmpty ? image : image(directory: parent)
    }

    private func fetchImage(_ path: String) -> Image? {
        if let override = tokens.image(for: path, main: bundle) {
            return override
        } else if ImageTokens.assetExists(path, in: bundle) {
            return Image(decorative: path, bundle: bundle)
        } else if ImageTokens.assetExists(path, in: definingBundle) {
            return Image(decorative: path, bundle: definingBundle)
        } else if ImageTokens.systemImageExists(path) {
            return Image(systemName: path)
        }
        return nil
    }
}

extension ImageStyling where Self: RawRepresentable, RawValue == String {
    public var name: String { rawValue }
}
