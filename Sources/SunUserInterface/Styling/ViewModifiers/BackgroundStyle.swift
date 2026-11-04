//
//  BackgroundStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct BackgroundStyle: ViewModifier {
    private let color: any ColorStyling
    public init(_ color: any ColorStyling) { self.color = color }
    public func body(content: Content) -> some View { content.background(color.color) }
}
