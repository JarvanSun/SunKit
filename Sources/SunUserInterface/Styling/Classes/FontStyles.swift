//
//  FontStyles.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

import Foundation
import SunCore
import SwiftUI

public struct FontStyles: Sendable {
    private let tokens: FontStyleTokens

    public init(tokens: FontStyleTokens = .init(fontStyles: [])) { self.tokens = tokens }
    public init(data: Data) throws {
        tokens = try JSONDecoder().decode(FontStyleTokens.self, from: data)
    }
    public init(bundle: Bundle, fileName: String = "FontTokens") throws {
        tokens = try FileManagement.loadLocalJSON(bundle: bundle, fileName: fileName)
    }

    public func info(for token: FontToken, relativeTo: Font.TextStyle = .body) -> FontStyle? {
        info(for: token.rawValue, relativeTo: relativeTo)
    }

    public func info(for token: String, relativeTo: Font.TextStyle = .body) -> FontStyle? {
        guard let info = tokens.fontStyles.first(where: { $0.token == token })?.fontInfo else {
            return nil
        }

        return FontStyle(
            info.fontFamily,
            size: info.size,
            weight: Self.weight(info.weight),
            lineHeight: info.lineHeight,
            relativeTo: relativeTo
        )
    }

    private static func weight(_ name: String) -> Font.Weight {
        switch name.lowercased() {
        case "ultralight": .ultraLight
        case "thin": .thin
        case "light": .light
        case "medium": .medium
        case "semibold": .semibold
        case "bold": .bold
        case "heavy": .heavy
        case "black": .black
        default: .regular
        }
    }
}
