//
//  ResponseDecoding.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public struct ResponseDecoding<Value: Decodable & Sendable>: Sendable {
    private let decoding: @Sendable (HTTPResponse, ResponseDecoder) throws -> Value

    public init(
        decode: @escaping @Sendable (HTTPResponse, ResponseDecoder) throws -> Value
    ) {
        decoding = decode
    }

    public static var json: Self {
        .init { response, decoder in try decoder.decode(Value.self, from: response.data) }
    }

    public func decode(_ response: HTTPResponse, using decoder: ResponseDecoder) throws -> Value {
        try decoding(response, decoder)
    }
}

extension ResponseDecoding where Value == EmptyResponse {
    public static var empty: Self {
        .init { response, _ in
            guard response.data.isEmpty else { throw NetworkError.unexpectedResponseBody }

            return EmptyResponse()
        }
    }
}
