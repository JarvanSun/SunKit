//
//  DefaultPlaceholderStyle.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import SwiftUI

public struct DefaultPlaceholderStyle: PlaceholderStyling {
    public let minOpacity: Double
    public let maxOpacity: Double
    public let duration: Double

    public init(minOpacity: Double = 0.25, maxOpacity: Double = 0.5, duration: Double = 0.9) {
        self.minOpacity = min(1, max(0, minOpacity))
        self.maxOpacity = min(1, max(self.minOpacity, maxOpacity))
        self.duration = max(0.01, duration)
    }
}

extension PlaceholderStyling where Self == DefaultPlaceholderStyle {
    public static var `default`: Self { .init() }
}

private struct PlaceholderStyleKey: EnvironmentKey {
    static let defaultValue: any PlaceholderStyling = DefaultPlaceholderStyle()
}

extension EnvironmentValues {
    public var placeholderStyle: any PlaceholderStyling {
        get { self[PlaceholderStyleKey.self] }
        set { self[PlaceholderStyleKey.self] = newValue }
    }
}
