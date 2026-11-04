//
//  ArrayExtensionsTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct ArrayExtensionsTests {
    @Test func filterNotNilWhenValuesContainNilThenPreservesNonNilOrder() {
        // Given
        let values: [Int?] = [nil, 1, nil, 3]

        // When
        let filtered = values.filterNotNil()

        // Then
        #expect(filtered == [1, 3])
    }
}
