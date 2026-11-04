//
//  DimensionTokens.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation

public final class DimensionTokens: Sendable {
    public typealias TokenDictionary = [DimensionToken: CGFloat]

    public let tokens: TokenDictionary

    public init(tokens: TokenDictionary) {
        self.tokens = tokens
    }

    public convenience init(_ bundle: Bundle) {
        guard let url = bundle.url(forResource: "DimensionTokens", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let decoded = try? Self.decode(data)
        else {
            self.init(tokens: [:])
            return
        }

        self.init(tokens: decoded)
    }

    public convenience init(data: Data) throws {
        self.init(tokens: try Self.decode(data))
    }

    public func value(for token: DimensionToken) -> CGFloat? {
        tokens[token]
    }

    private static func decode(_ data: Data) throws -> TokenDictionary {
        let values = try JSONDecoder().decode([String: Double].self, from: data)
        return values.reduce(into: TokenDictionary()) { result, item in
            result[DimensionToken(rawValue: item.key)] = CGFloat(item.value)
        }
    }
}
