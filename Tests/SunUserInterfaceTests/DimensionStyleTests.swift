//
//  DimensionStyleTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct DimensionStyleTests {
    @Test func initWhenDimensionsAreOverriddenThenPreservesOtherDefaults() {
        // Given
        let tokens = DimensionTokens(tokens: [.spaceXXLarge: 37, .borderWidthXSmall: 0.75])

        // When
        let style = DimensionStyle(tokens: tokens)

        // Then
        #expect(style.spaceXXLarge == 37)
        #expect(style.borderWidthXSmall == 0.75)
        #expect(style.inProgressViewLarge == 100)
        #expect(style.cornerRadiusSmall == 6)
    }
}
