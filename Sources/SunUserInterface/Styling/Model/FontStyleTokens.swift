//
//  FontStyleTokens.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import Foundation

public struct FontStyleTokens: Codable, Sendable {
    public let fontStyles: [FontTokens]
    public init(fontStyles: [FontTokens]) { self.fontStyles = fontStyles }
}
