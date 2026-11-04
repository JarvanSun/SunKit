//
//  PercentFormatterTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct PercentFormatterTests {
    @Test func toStringWhenFractionDigitsAreSpecifiedThenFormatsPercent() {
        // Given
        let formatter = PercentFormatter(locale: Locale(identifier: "en_US"))

        // When
        let value = formatter.toString(amount: 0.125, minFractionDigits: 1, maxFractionDigits: 1)

        // Then
        #expect(value == "12.5%")
    }
}
