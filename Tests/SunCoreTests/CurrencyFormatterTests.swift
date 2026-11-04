//
//  CurrencyFormatterTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct CurrencyFormatterTests {
    @Test func toStringWhenCurrencyIsEURThenUsesEuroSymbol() {
        // Given
        let formatter = CurrencyFormatter(currencyCode: "EUR", locale: Locale(identifier: "en_US"))

        // When
        let value = formatter.toString(amount: 1)

        // Then
        #expect(value?.contains("€") == true)
    }

    @Test func toStringWhenAmountIsInfiniteThenReturnsNil() {
        // Given
        let formatter = CurrencyFormatter(currencyCode: "EUR", locale: Locale(identifier: "en_US"))

        // When
        let value = formatter.toString(amount: .infinity)

        // Then
        #expect(value == nil)
    }
}
