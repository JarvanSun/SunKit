//
//  DoubleExtensionsTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct DoubleExtensionsTests {
    @Test func toCurrencyStringWhenPositivePrefixIsEnabledThenAddsPlusSign() {
        // Given
        let amount = 1.0

        // When
        let value = amount.toCurrencyString(
            currencyCode: "USD",
            locale: Locale(identifier: "en_US"),
            usePositivePrefix: true
        )

        // Then
        #expect(value?.hasPrefix("+") == true)
    }
}
