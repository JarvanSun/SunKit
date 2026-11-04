//
//  CurrencyFormatter.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public struct CurrencyFormatter: Sendable {
    public let locale: Locale
    public let currencyCode: String

    public init(currencyCode: String, locale: Locale = .current) {
        self.locale = locale
        self.currencyCode = currencyCode

    }

    public func toString(
        amount: Double,
        minFractionDigits: Int = 2,
        maxFractionDigits: Int = 2,
        usePositivePrefix: Bool = false
    ) -> String? {
        guard amount.isFinite else { return nil }

        return NumberFormatting(locale: locale, style: .currency, currencyCode: currencyCode)
            .formatter(
                minFractionDigits: minFractionDigits,
                maxFractionDigits: maxFractionDigits,
                usePositivePrefix: usePositivePrefix
            )
            .string(from: NSNumber(value: amount))
    }

    public func toDouble(
        amount: String,
        minFractionDigits: Int = 2,
        maxFractionDigits: Int = 2,
        usePositivePrefix: Bool = false
    ) -> Double? {
        NumberFormatting(locale: locale, style: .currency, currencyCode: currencyCode)
            .formatter(
                minFractionDigits: minFractionDigits,
                maxFractionDigits: maxFractionDigits,
                usePositivePrefix: usePositivePrefix
            )
            .number(from: amount)?.doubleValue
    }
}
