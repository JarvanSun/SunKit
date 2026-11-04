//
//  RequestBody.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public struct RequestBody: Sendable {
    public let contentType: String?
    private let encoding: @Sendable (JSONEncoder) throws -> Data

    private init(
        contentType: String?,
        encoding: @escaping @Sendable (JSONEncoder) throws -> Data
    ) {
        self.contentType = contentType
        self.encoding = encoding
    }

    public static func json<Value: Encodable & Sendable>(_ value: Value) -> Self {
        .init(contentType: "application/json", encoding: { try $0.encode(value) })
    }

    public static func raw(_ data: Data, contentType: String? = nil) -> Self {
        .init(contentType: contentType, encoding: { _ in data })
    }

    public func encode(using encoder: JSONEncoder) throws -> Data {
        try encoding(encoder)
    }
}
