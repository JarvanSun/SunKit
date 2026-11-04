//
//  CaseIterableTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct CaseIterableTests {
    @Test func allValuesWhenEnumHasRawValuesThenPreservesDeclarationOrder() {
        // Given
        let expected = ["first", "second"]

        // When
        let values = Sample.allValues

        // Then
        #expect(values == expected)
    }
}

private enum Sample: String, CaseIterable { case first, second }
