//
//  DimensionTokensTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct DimensionTokensTests {
    @Test func initWhenTokenDataIsProvidedThenDecodesWithoutAppBundle() throws {
        // Given
        let data = Data(#"{"spaceSmall":10,"appSpecificSize":7}"#.utf8)

        // When
        let tokens = try DimensionTokens(data: data)

        // Then
        #expect(tokens.value(for: .spaceSmall) == 10)
        #expect(tokens.value(for: "appSpecificSize") == 7)
    }
}
