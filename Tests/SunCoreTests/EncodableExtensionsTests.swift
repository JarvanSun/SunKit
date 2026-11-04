//
//  EncodableExtensionsTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct EncodableExtensionsTests {
    @Test func prettyFormattedWhenValueIsEncodableThenIncludesItsProperties() throws {
        // Given
        let value = Payload(number: 3)

        // When
        let formatted = try value.prettyFormatted()

        // Then
        #expect(formatted.contains("3"))
    }
}

private struct Payload: Codable { let number: Int }
