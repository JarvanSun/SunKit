//
//  ResponseDecoderTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct ResponseDecoderTests {
    @Test func decodeWhenDataMatchesTypeThenReturnsTypedValue() throws {
        // Given
        let decoder = ResponseDecoder()
        let data = Data(#"{"displayName":"Sun"}"#.utf8)

        // When
        let value = try decoder.decode(Payload.self, from: data)

        // Then
        #expect(value.displayName == "Sun")
    }

    @Test func decodeWhenKeysAreConfiguredThenUsesAppDecodingPolicy() throws {
        // Given
        let decoder = ResponseDecoder {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            decoder.dateDecodingStrategy = .iso8601
            return decoder
        }
        let data = Data(#"{"created_at":"1970-01-01T00:00:00Z"}"#.utf8)

        // When
        let value = try decoder.decode(DatedPayload.self, from: data)

        // Then
        #expect(value.createdAt == Date(timeIntervalSince1970: 0))
    }

    @Test func decodeWhenPayloadIsMalformedThenPreservesCodingPath() {
        // Given
        let decoder = ResponseDecoder()
        let data = Data(#"{"displayName":42}"#.utf8)

        // When
        let result = Result { try decoder.decode(Payload.self, from: data) }

        // Then
        guard case .failure(DecodingError.typeMismatch(_, let context)) = result else {
            Issue.record("Expected a type mismatch")
            return
        }

        #expect(context.codingPath.map(\.stringValue) == ["displayName"])
    }

    @Test func decodeWhenCalledConcurrentlyThenKeepsDecoderConfigurationIndependent() async throws {
        // Given
        let decoder = ResponseDecoder()
        let firstData = Data(#"{"displayName":"Sun"}"#.utf8)
        let secondData = Data(#"{"displayName":"Other"}"#.utf8)

        // When
        async let first = decoder.decode(Payload.self, from: firstData)
        async let second = decoder.decode(Payload.self, from: secondData)
        let values = try await (first, second)

        // Then
        #expect(values.0.displayName == "Sun")
        #expect(values.1.displayName == "Other")
    }
}

private struct Payload: Decodable, Sendable { let displayName: String }
private struct DatedPayload: Decodable, Sendable { let createdAt: Date }
