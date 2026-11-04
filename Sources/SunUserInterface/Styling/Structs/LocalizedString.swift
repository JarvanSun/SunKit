//
//  LocalizedString.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import Foundation

public struct LocalizedString: Sendable {
    public enum Argument: Sendable {
        case string(String)
        case integer(Int)
        case decimal(Double)

        fileprivate var value: any CVarArg {
            switch self {
            case .string(let value): value
            case .integer(let value): value
            case .decimal(let value): value
            }
        }
    }

    public let key: String?
    private let table: String?
    private let bundle: Bundle
    private let definingBundle: Bundle
    private let arguments: [Argument]
    private let verbatim: String?

    public init(
        key: String,
        table: some LocalizationTable,
        bundle: Bundle,
        definingBundle: Bundle,
        args: [Argument] = []
    ) {
        self.key = key
        self.table = table.name
        self.bundle = bundle
        self.definingBundle = definingBundle
        self.arguments = args
        self.verbatim = nil
    }

    public init(verbatim value: String) {
        self.key = nil
        self.table = nil
        self.bundle = .main
        self.definingBundle = .main
        self.arguments = []
        self.verbatim = value
    }

    public func resolved(locale: Locale = .current) -> String {
        if let verbatim { return verbatim }
        guard let key else { return "" }

        let missing = "__SunUserInterface_missing_localization__"
        var format = bundle.localizedBundle(for: locale).localizedString(
            forKey: key,
            value: missing,
            table: table
        )
        if format == missing {
            format = definingBundle.localizedBundle(for: locale).localizedString(
                forKey: key,
                value: key,
                table: table
            )
        }
        guard !arguments.isEmpty else { return format }

        return String(format: format, locale: locale, arguments: arguments.map(\.value))
    }
}
