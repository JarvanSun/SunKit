//
//  SettingStorage.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

@propertyWrapper @MainActor
public struct SettingStorage<Value: Codable & Sendable> {
    public let key: SettingsKey<Value>
    private let settings: Settings

    public init(_ key: SettingsKey<Value>, settings: Settings) {
        self.key = key
        self.settings = settings
    }

    public var wrappedValue: Result<Value, any Error> { Result { try settings.value(for: key) } }
    public var projectedValue: Self { self }

    public func set(_ value: Value) throws { try settings.set(value, for: key) }
    public func reset() { settings.reset(key) }
}
