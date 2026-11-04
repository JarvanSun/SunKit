//
//  PrimaryButtonStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    private let foreground: Color
    private let background: Color
    private let font: any FontStyling
    private let dimensions: ButtonDimension

    public init(
        foreground: some ColorStyling,
        background: some ColorStyling,
        font: some FontStyling,
        dimensions: ButtonDimension = .init()
    ) {
        self.foreground = foreground.color
        self.background = background.color
        self.font = font
        self.dimensions = dimensions
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(FontStyleModifier(fontStyle: font))
            .padding(.vertical, dimensions.verticalPadding)
            .padding(.horizontal, dimensions.horizontalPadding)
            .foregroundStyle(foreground)
            .background(background, in: RoundedRectangle(cornerRadius: dimensions.cornerRadius))
            .opacity(
                !isEnabled
                    ? dimensions.disabledOpacity
                    : configuration.isPressed ? dimensions.pressedOpacity : 1
            )
    }
}
