//
//  DoubleOrStringTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct DoubleOrStringTests {
    @Test(arguments: [DoubleOrString.double(12.5), .string("12.5")])
    func initWhenJSONContainsNumberOrStringThenPreservesValue(value: DoubleOrString) throws {
        // Given
        let data = try JSONEncoder().encode(value)

        // When
        let decoded = try JSONDecoder().decode(DoubleOrString.self, from: data)

        // Then
        #expect(decoded == value)
        #expect(decoded.getDouble() == 12.5)
    }

    @Test func getDoubleWhenStringIsInvalidThenReturnsNil() {
        // Given
        let value = DoubleOrString.string("invalid")

        // When
        let number = value.getDouble()

        // Then
        #expect(number == nil)
    }

    @Test(arguments: ["true", "null"])
    func initWhenJSONTypeIsUnsupportedThenThrows(payload: String) {
        // Given
        let data = Data(payload.utf8)

        // When
        let result = Result { try JSONDecoder().decode(DynamicJSONProperty.self, from: data) }

        // Then
        #expect(throws: (any Error).self) { try result.get() }
    }
}
