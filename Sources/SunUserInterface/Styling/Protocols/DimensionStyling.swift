//
//  DimensionStyling.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import CoreGraphics

public protocol DimensionStyling: Sendable {
    func value(for token: DimensionToken) -> CGFloat?
}

extension DimensionStyling {
    public func value(for token: DimensionToken, default defaultValue: CGFloat) -> CGFloat {
        value(for: token) ?? defaultValue
    }

    public var spaceXSmall: CGFloat { value(for: .spaceXSmall, default: 3) }
    public var spaceSmall: CGFloat { value(for: .spaceSmall, default: 8) }
    public var spaceXMedium: CGFloat { value(for: .spaceXMedium, default: 9) }
    public var spaceMedium: CGFloat { value(for: .spaceMedium, default: 12) }
    public var spaceLargeSmall: CGFloat { value(for: .spaceLargeSmall, default: 16) }
    public var spaceLargeExtra: CGFloat { value(for: .spaceLargeExtra, default: 20) }
    public var spaceXLarge: CGFloat { value(for: .spaceXLarge, default: 24) }
    public var spaceXXLarge: CGFloat { value(for: .spaceXXLarge, default: 32) }
    public var spaceXXLargeExtra: CGFloat { value(for: .spaceXXLargeExtra, default: 34) }
    public var spaceXXLargeExtra42: CGFloat { value(for: .spaceXXLargeExtra42, default: 42) }
    public var spaceXXXLarge: CGFloat { value(for: .spaceXXXLarge, default: 64) }
    public var spaceXXXXLarge: CGFloat { value(for: .spaceXXXXLarge, default: 96) }
    public var cornerRadiusSmall: CGFloat { value(for: .cornerRadiusSmall, default: 6) }
    public var cornerRadiusMedium: CGFloat { value(for: .cornerRadiusMedium, default: 8) }
    public var cornerRadiusLarge: CGFloat { value(for: .cornerRadiusLarge, default: 12) }
    public var inProgressViewLarge: CGFloat { value(for: .inProgressViewLarge, default: 100) }
    public var inProgressViewSmall: CGFloat { value(for: .inProgressViewSmall, default: 50) }
    public var borderWidthMedium: CGFloat { value(for: .borderWidthMedium, default: 2) }
    public var borderWidthSmall: CGFloat { value(for: .borderWidthSmall, default: 1) }
    public var borderWidthXSmall: CGFloat { value(for: .borderWidthXSmall, default: 0.5) }
}
