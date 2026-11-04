//
//  DimensionStyleEnvironmentTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics
import Foundation
import SunUserInterface
import SwiftUI
import Testing

struct DimensionStyleEnvironmentTests {
    @Test func dimensionsWhenConsumerStyleIsInjectedThenUsesItsValues() {
        // Given
        var environment = EnvironmentValues()

        // When
        environment.dimensions = ConsumerDimensions()

        // Then
        #expect(environment.dimensions.spaceSmall == 42)
        #expect(environment.dimensions.value(for: .consumerThumbnail) == 80)
    }
}

extension DimensionToken {
    fileprivate static let consumerThumbnail: Self = "consumerThumbnail"
}

private struct ConsumerDimensions: DimensionStyling {
    func value(for token: DimensionToken) -> CGFloat? {
        switch token {
        case .spaceSmall: 42
        case .consumerThumbnail: 80
        default: nil
        }
    }
}
