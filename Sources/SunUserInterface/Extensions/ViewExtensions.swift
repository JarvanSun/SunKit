//
//  ViewExtensions.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

extension View {
    public func font(_ style: some FontStyling) -> some View {
        modifier(FontStyleModifier(fontStyle: style))
    }
    public func textStyle(_ color: some ColorStyling, _ font: some FontStyling) -> some View {
        modifier(TextStyle(color, font))
    }
    public func foregroundColor(_ style: some ColorStyling) -> some View {
        modifier(ForegroundColorStyle(style))
    }
    public func background(_ style: some ColorStyling) -> some View {
        modifier(BackgroundStyle(style))
    }
    public func accessibilityIdentifier(_ identifier: some AccessibilityIdentifying) -> some View {
        accessibilityIdentifier(identifier.rawValue)
    }
}
