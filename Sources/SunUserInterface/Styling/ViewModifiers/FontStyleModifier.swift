//
//  FontStyleModifier.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct FontStyleModifier: ViewModifier {
    @Environment(\.legibilityWeight) private var legibilityWeight
    @ScaledMetric private var scale: CGFloat
    private let fontStyle: any FontStyling

    public init(fontStyle: any FontStyling) {
        self.fontStyle = fontStyle
        _scale = ScaledMetric(wrappedValue: 1, relativeTo: fontStyle.relativeTo)
    }

    public func body(content: Content) -> some View {
        content
            .font(resolvedFont)
            .lineSpacing(lineHeightDifference)
            .padding(.vertical, lineHeightDifference / 2)
    }

    private var lineHeightDifference: CGFloat {
        max(0, fontStyle.lineHeight - fontStyle.nativeLineHeight) * scale
    }

    private var resolvedFont: Font {
        let font: Font
        if let style = fontStyle as? FontStyle {
            if let family = style.family {
                font = .custom(family, fixedSize: style.size * scale).weight(style.weight)
            } else {
                font = .system(size: style.size * scale, weight: style.weight)
            }
        } else {
            font = fontStyle.font
        }
        return legibilityWeight == .bold ? font.weight(.bold) : font
    }
}
