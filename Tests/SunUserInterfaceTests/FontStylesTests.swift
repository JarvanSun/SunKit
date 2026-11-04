//
//  FontStylesTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct FontStylesTests {
    @Test func infoWhenTokenExistsThenPreservesFontAttributes() throws {
        // Given
        let styles = try FontStyles(
            data: Data(
                #"{"fontStyles":[{"token":"headingLarge","fontInfo":{"fontFamily":"custom","size":20,"weight":"bold","lineHeight":30}}]}"#
                    .utf8
            )
        )

        // When
        let style = try #require(styles.info(for: .headingLarge, relativeTo: .headline))

        // Then
        #expect(style.family == "custom")
        #expect(style.size == 20)
        #expect(style.weight == .bold)
        #expect(style.customLineHeight == 30)
    }

    @Test func initWhenFontDataIsMalformedThenThrows() {
        // Given
        let data = Data("broken".utf8)

        // When
        let result = Result { try FontStyles(data: data) }

        // Then
        #expect(throws: (any Error).self) { try result.get() }
    }

    @Test func infoWhenTokenIsMissingThenReturnsNil() {
        // Given
        let styles = FontStyles()

        // When
        let style = styles.info(for: "missing")

        // Then
        #expect(style == nil)
    }
}
