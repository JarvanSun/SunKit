//
//  DimensionStyleEnvironment.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import SwiftUI

private struct DimensionStylingKey: EnvironmentKey {
    static let defaultValue: any DimensionStyling = DimensionStyle()
}

extension EnvironmentValues {
    public var dimensions: any DimensionStyling {
        get { self[DimensionStylingKey.self] }
        set { self[DimensionStylingKey.self] = newValue }
    }
}
