//
//  SettingsKey.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public struct SettingsKey<Value: Codable & Sendable>: Sendable {
    public let name: String
    public let defaultValue: Value

    public init(_ name: String, defaultValue: Value) {
        self.name = name
        self.defaultValue = defaultValue
    }
}
