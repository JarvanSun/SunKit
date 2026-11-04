//
//  TextForegroundColorStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct TextForegroundColorStyle: TextModifier {
    private let color: any ColorStyling
    public init(_ color: any ColorStyling) { self.color = color }
    public func body(text: Text) -> Text { text.foregroundColor(color.color) }
}
