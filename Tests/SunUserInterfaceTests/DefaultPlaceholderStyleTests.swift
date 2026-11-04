//
//  DefaultPlaceholderStyleTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct DefaultPlaceholderStyleTests {
    @Test func initWhenPlaceholderValuesAreInvalidThenClampsConfiguration() {
        // Given
        let minOpacity = -1.0
        let maxOpacity = 3.0
        let duration = -1.0

        // When
        let style = DefaultPlaceholderStyle(
            minOpacity: minOpacity,
            maxOpacity: maxOpacity,
            duration: duration
        )

        // Then
        #expect(style.minOpacity == 0)
        #expect(style.maxOpacity == 1)
        #expect(style.duration > 0)
    }
}
