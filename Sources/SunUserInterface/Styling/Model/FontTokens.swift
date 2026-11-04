//
//  FontTokens.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

public struct FontTokens: Codable, Sendable {
    public let token: String
    public let fontInfo: FontInfo
    public init(token: String, fontInfo: FontInfo) {
        self.token = token
        self.fontInfo = fontInfo
    }
}
