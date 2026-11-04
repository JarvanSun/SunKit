//
//  ImageTokens.swift
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

public final class ImageTokens: Sendable {
    public static let empty = ImageTokens(tokens: [:])

    public let tokens: [String: String]

    public init(tokens: [String: String]) {
        self.tokens = tokens
    }

    public convenience init(_ bundle: Bundle) {
        guard let url = bundle.url(forResource: "ImageTokens", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let values = try? JSONDecoder().decode([String: String].self, from: data)
        else {
            self.init(tokens: [:])
            return
        }

        self.init(tokens: values)
    }

    public func image(for path: String, main bundle: Bundle) -> Image? {
        guard let name = tokens[path], Self.assetExists(name, in: bundle) else { return nil }

        return Image(decorative: name, bundle: bundle)
    }

    public static func assetExists(_ name: String, in bundle: Bundle) -> Bool {
        #if canImport(UIKit)
        UIImage(named: name, in: bundle, compatibleWith: nil) != nil
        #elseif canImport(AppKit)
        bundle.image(forResource: NSImage.Name(name)) != nil
        #else
        false
        #endif
    }

    public static func systemImageExists(_ name: String) -> Bool {
        #if canImport(UIKit)
        UIImage(systemName: name) != nil
        #elseif canImport(AppKit)
        NSImage(systemSymbolName: name, accessibilityDescription: nil) != nil
        #else
        false
        #endif
    }
}
