//
//  ResponseDecoder.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public struct ResponseDecoder: Sendable {
    private let makeJSONDecoder: @Sendable () -> JSONDecoder

    public init(makeJSONDecoder: @escaping @Sendable () -> JSONDecoder = { JSONDecoder() }) {
        self.makeJSONDecoder = makeJSONDecoder
    }

    public func decode<Value: Decodable & Sendable>(
        _ type: Value.Type,
        from data: Data
    ) throws -> Value {
        try makeJSONDecoder().decode(type, from: data)
    }
}
