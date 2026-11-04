//
//  DimensionStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics

public struct DimensionStyle: DimensionStyling {
    private let tokens: DimensionTokens

    public init(tokens: DimensionTokens = .init(tokens: [:])) { self.tokens = tokens }

    public func value(for token: DimensionToken) -> CGFloat? {
        tokens.value(for: token)
    }
}
