//
//  NumberFormatting.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

struct NumberFormatting {
    let locale: Locale
    let style: NumberFormatter.Style
    var currencyCode: String?

    func formatter(minFractionDigits: Int, maxFractionDigits: Int, usePositivePrefix: Bool)
        -> NumberFormatter
    {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = style
        if let currencyCode { formatter.currencyCode = currencyCode }
        formatter.minimumFractionDigits = max(0, minFractionDigits)
        formatter.maximumFractionDigits = max(formatter.minimumFractionDigits, maxFractionDigits)
        if usePositivePrefix { formatter.positivePrefix = "+" + (formatter.positivePrefix ?? "") }
        return formatter
    }
}
