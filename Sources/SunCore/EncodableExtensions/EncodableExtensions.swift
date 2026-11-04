//
//  EncodableExtensions.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

extension Encodable {
    public func prettyFormatted() throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return String(decoding: try encoder.encode(self), as: UTF8.self)
    }
}
