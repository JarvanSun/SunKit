//
//  FontStyleTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct FontStyleTests {
    @Test func sizeWhenOverriddenThenReturnsCopyWithoutMutatingOriginal() {
        // Given
        let style = FontStyle(size: 20)

        // When
        let resized = style.size(22)

        // Then
        #expect(resized.size == 22)
        #expect(style.size == 20)
    }

    #if canImport(UIKit)
    @Test @MainActor func fontWhenDynamicTypeIncreasesThenRendersLargerText() throws {
        // Given
        let style = FontStyle(size: 17, lineHeight: 28)
        let standard = ImageRenderer(
            content: Text("Scale").font(style).fixedSize().environment(\.dynamicTypeSize, .large)
        )
        let accessible = ImageRenderer(
            content: Text("Scale").font(style).fixedSize().environment(
                \.dynamicTypeSize,
                .accessibility3
            )
        )

        // When
        let standardImage = try #require(standard.cgImage)
        let accessibleImage = try #require(accessible.cgImage)

        // Then
        #expect(accessibleImage.height > standardImage.height)
        #expect(accessibleImage.width > standardImage.width)
    }
    #endif

    @Test @MainActor func fontWhenCustomLineHeightIncreasesThenAddsVerticalSpace() throws {
        // Given
        let compact = ImageRenderer(content: Text("Line").font(FontStyle(size: 17)).fixedSize())
        let spacious = ImageRenderer(
            content: Text("Line").font(FontStyle(size: 17, lineHeight: 50)).fixedSize()
        )

        // When
        let spaciousImage = try #require(spacious.cgImage)
        let compactImage = try #require(compact.cgImage)

        // Then
        #expect(spaciousImage.height > compactImage.height)
    }
}
