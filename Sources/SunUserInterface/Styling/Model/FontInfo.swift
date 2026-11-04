//
//  FontInfo.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import Foundation

public struct FontInfo: Codable, Sendable {
    public let fontFamily: String?
    public let size: CGFloat
    public let weight: String
    public let lineHeight: CGFloat?
    public init(
        fontFamily: String? = nil,
        size: CGFloat,
        weight: String = "regular",
        lineHeight: CGFloat? = nil
    ) {
        self.fontFamily = fontFamily
        self.size = size
        self.weight = weight
        self.lineHeight = lineHeight
    }
}
