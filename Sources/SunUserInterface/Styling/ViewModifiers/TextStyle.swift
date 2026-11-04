//
//  TextStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct TextStyle: ViewModifier {
    private let colorStyle: any ColorStyling
    private let fontStyle: any FontStyling
    public init(_ colorStyle: any ColorStyling, _ fontStyle: any FontStyling) {
        self.colorStyle = colorStyle
        self.fontStyle = fontStyle
    }
    public func body(content: Content) -> some View {
        content.modifier(FontStyleModifier(fontStyle: fontStyle)).foregroundStyle(colorStyle.color)
    }
}
