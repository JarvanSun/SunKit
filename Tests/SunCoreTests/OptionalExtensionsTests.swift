//
//  OptionalExtensionsTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct OptionalExtensionsTests {
    @Test func isNilWhenValueIsAbsentThenReturnsTrue() {
        // Given
        let value: Int? = nil

        // When
        let isNil = value.isNil

        // Then
        #expect(isNil)
    }

    @Test func isNilWhenValueIsPresentThenReturnsFalse() {
        // Given
        let value: Int? = 1

        // When
        let isNil = value.isNil

        // Then
        #expect(!isNil)
    }
}
