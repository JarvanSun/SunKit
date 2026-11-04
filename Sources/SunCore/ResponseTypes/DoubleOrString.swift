//
//  DoubleOrString.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public enum DoubleOrString: Equatable, Codable, Sendable {
    case double(Double)
    case string(String)

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else {
            self = .string(try container.decode(String.self))
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let value): try container.encode(value)
        case .string(let value): try container.encode(value)
        }
    }

    public func getDouble() -> Double? {
        switch self {
        case .double(let value): value
        case .string(let value): Double(value)
        }
    }

    public func getString() -> String {
        switch self {
        case .double(let value): String(value)
        case .string(let value): value
        }
    }
}

public typealias DynamicJSONProperty = DoubleOrString
