//
//  FontStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct FontStyle: FontStyling {
    public private(set) var family: String?
    public private(set) var size: CGFloat
    public private(set) var weight: Font.Weight
    public private(set) var customLineHeight: CGFloat?
    public let relativeTo: Font.TextStyle

    public init(
        _ family: String? = nil,
        size: CGFloat,
        weight: Font.Weight = .regular,
        lineHeight: CGFloat? = nil,
        relativeTo: Font.TextStyle = .body
    ) {
        self.family = family
        self.size = max(1, size)
        self.weight = weight
        self.customLineHeight = lineHeight
        self.relativeTo = relativeTo
    }

    public func family(_ value: String) -> Self {
        var style = self
        style.family = value
        return style
    }
    public func size(_ value: CGFloat) -> Self {
        var style = self
        style.size = max(1, value)
        return style
    }
    public func weight(_ value: Font.Weight) -> Self {
        var style = self
        style.weight = value
        return style
    }
    public func lineHeight(_ value: CGFloat) -> Self {
        var style = self
        style.customLineHeight = value
        return style
    }

    public var font: Font {
        if let family { return .custom(family, size: size, relativeTo: relativeTo).weight(weight) }
        return .system(size: size, weight: weight)
    }

    public var lineHeight: CGFloat { max(nativeLineHeight, customLineHeight ?? nativeLineHeight) }

    public var nativeLineHeight: CGFloat {
        #if canImport(UIKit)
        uiFont.lineHeight
        #elseif canImport(AppKit)
        NSFont.systemFont(ofSize: size).ascender - NSFont.systemFont(ofSize: size).descender
            + NSFont.systemFont(ofSize: size).leading
        #else
        size * 1.2
        #endif
    }

    #if canImport(UIKit)
    public var uiFont: UIFont {
        let font =
            family.flatMap { UIFont(name: $0, size: size) } ?? UIFont.systemFont(ofSize: size)
        let descriptor = font.fontDescriptor.addingAttributes([
            .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight(weight)]
        ])
        return UIFont(descriptor: descriptor, size: size)
    }
    #endif
}
