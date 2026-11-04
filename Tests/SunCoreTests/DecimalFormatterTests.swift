//
//  DecimalFormatterTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct DecimalFormatterTests {
    @Test func toStringWhenLocaleIsGermanThenUsesDecimalComma() {
        // Given
        let formatter = DecimalFormatter(locale: Locale(identifier: "de_DE"))

        // When
        let value = formatter.toString(amount: 12.5)

        // Then
        #expect(value == "12,50")
    }

    @Test func toDoubleWhenLocaleIsGermanThenParsesDecimalComma() {
        // Given
        let formatter = DecimalFormatter(locale: Locale(identifier: "de_DE"))

        // When
        let value = formatter.toDouble(amount: "12,50")

        // Then
        #expect(value == 12.5)
    }

    @Test(arguments: 0..<10)
    func toStringWhenCallsUseDifferentPrecisionThenKeepsResultsIndependent(digits: Int) async {
        // Given
        let decimal = DecimalFormatter(locale: Locale(identifier: "de_DE"))
        let expected = digits == 0 ? "1" : "1," + String(repeating: "0", count: digits)

        // When
        async let formatted = decimal.toString(
            amount: 1,
            minFractionDigits: digits,
            maxFractionDigits: digits
        )
        async let defaultFormatted = decimal.toString(amount: 12.5)
        let (actual, defaultActual) = await (formatted, defaultFormatted)

        // Then
        #expect(actual == expected)
        #expect(defaultActual == "12,50")
    }
}
