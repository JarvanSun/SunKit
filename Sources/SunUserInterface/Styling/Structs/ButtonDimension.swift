//
//  ButtonDimension.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics

public struct ButtonDimension: Sendable {
    public let verticalPadding: CGFloat
    public let horizontalPadding: CGFloat
    public let cornerRadius: CGFloat
    public let pressedOpacity: Double
    public let disabledOpacity: Double

    public init(
        verticalPadding: CGFloat = 14,
        horizontalPadding: CGFloat = 16,
        cornerRadius: CGFloat = 8,
        pressedOpacity: Double = 0.6,
        disabledOpacity: Double = 0.4
    ) {
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.cornerRadius = cornerRadius
        self.pressedOpacity = pressedOpacity
        self.disabledOpacity = disabledOpacity
    }
}
