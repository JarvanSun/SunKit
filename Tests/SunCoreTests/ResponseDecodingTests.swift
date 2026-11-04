//
//  ResponseDecodingTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct ResponseDecodingTests {
    @Test func decodeWhenEmptyResponseIsDeclaredThenAcceptsNoBody() throws {
        // Given
        let decoding = ResponseDecoding<EmptyResponse>.empty
        let response = response(data: Data())

        // When
        let value = try decoding.decode(response, using: ResponseDecoder())

        // Then
        #expect(value == EmptyResponse())
    }

    @Test func decodeWhenEmptyResponseHasBodyThenThrows() {
        // Given
        let decoding = ResponseDecoding<EmptyResponse>.empty
        let response = response(data: Data("unexpected".utf8))

        // When
        let result = Result { try decoding.decode(response, using: ResponseDecoder()) }

        // Then
        #expect(throws: NetworkError.unexpectedResponseBody) { try result.get() }
    }

    @Test func decodeWhenCustomPolicyIsProvidedThenUsesIt() throws {
        // Given
        let decoding = ResponseDecoding<String> { response, _ in
            String(decoding: response.data, as: UTF8.self)
        }
        let response = response(data: Data("plain text".utf8))

        // When
        let value = try decoding.decode(response, using: ResponseDecoder())

        // Then
        #expect(value == "plain text")
    }

    private func response(data: Data) -> HTTPResponse {
        HTTPResponse(
            data: data,
            response: HTTPURLResponse(
                url: URL(string: "https://example.test")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
        )
    }
}
