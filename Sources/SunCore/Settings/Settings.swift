//
//  Settings.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import Observation

@MainActor @Observable
public final class Settings {
    @ObservationIgnored private let storage: UserDefaults
    public let namespace: String
    public let userID: String?
    private var revision = 0

    public init(storage: UserDefaults = .standard, namespace: String, userID: String? = nil) {
        self.storage = storage
        self.namespace = namespace
        self.userID = userID
    }

    public func value<Value>(for key: SettingsKey<Value>) throws -> Value {
        _ = revision
        guard let data = storage.data(forKey: storageKey(for: key.name)) else {
            return key.defaultValue
        }

        return try JSONDecoder().decode(Value.self, from: data)
    }

    public func set<Value>(_ value: Value, for key: SettingsKey<Value>) throws {
        if let optional = value as? any AnyOptional, optional.isNil {
            reset(key)
            return
        }
        let data = try JSONEncoder().encode(value)
        storage.set(data, forKey: storageKey(for: key.name))
        revision &+= 1
    }

    public func reset<Value>(_ key: SettingsKey<Value>) {
        storage.removeObject(forKey: storageKey(for: key.name))
        revision &+= 1
    }

    public func reload() { revision &+= 1 }

    private func storageKey(for key: String) -> String {
        let parts = [namespace, userID == nil ? "global" : "user", userID ?? "", key]
        return parts.map { Data($0.utf8).base64EncodedString() }.joined(separator: ":")
    }
}
