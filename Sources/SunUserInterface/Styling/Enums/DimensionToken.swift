//
//  DimensionToken.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

public struct DimensionToken: RawRepresentable, Hashable, Codable, Sendable,
    ExpressibleByStringLiteral
{
    public let rawValue: String

    public init(rawValue: String) { self.rawValue = rawValue }

    public init(stringLiteral value: String) { rawValue = value }
}

extension DimensionToken {
    public static let spaceXSmall: Self = "spaceXSmall"
    public static let spaceSmall: Self = "spaceSmall"
    public static let spaceXMedium: Self = "spaceXMedium"
    public static let spaceMedium: Self = "spaceMedium"
    public static let spaceLargeSmall: Self = "spaceLargeSmall"
    public static let spaceLargeExtra: Self = "spaceLargeExtra"
    public static let spaceXLarge: Self = "spaceXLarge"
    public static let spaceXXLarge: Self = "spaceXXLarge"
    public static let spaceXXLargeExtra: Self = "spaceXXLargeExtra"
    public static let spaceXXLargeExtra42: Self = "spaceXXLargeExtra42"
    public static let spaceXXXLarge: Self = "spaceXXXLarge"
    public static let spaceXXXXLarge: Self = "spaceXXXXLarge"
    public static let cornerRadiusSmall: Self = "cornerRadiusSmall"
    public static let cornerRadiusMedium: Self = "cornerRadiusMedium"
    public static let cornerRadiusLarge: Self = "cornerRadiusLarge"
    public static let inProgressViewLarge: Self = "inProgressViewLarge"
    public static let inProgressViewSmall: Self = "inProgressViewSmall"
    public static let borderWidthMedium: Self = "borderWidthMedium"
    public static let borderWidthSmall: Self = "borderWidthSmall"
    public static let borderWidthXSmall: Self = "borderWidthXSmall"
}
