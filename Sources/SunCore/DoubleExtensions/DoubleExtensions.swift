//
//  DoubleExtensions.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

extension Double {
    public func toCurrencyString(
        currencyCode: String,
        locale: Locale = .current,
        minFractionDigits: Int = 2,
        maxFractionDigits: Int = 2,
        usePositivePrefix: Bool = false
    ) -> String? {
        CurrencyFormatter(currencyCode: currencyCode, locale: locale).toString(
            amount: self,
            minFractionDigits: minFractionDigits,
            maxFractionDigits: maxFractionDigits,
            usePositivePrefix: usePositivePrefix
        )
    }
}
