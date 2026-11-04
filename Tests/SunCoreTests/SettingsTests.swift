//
//  SettingsTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import Observation
import SunCore
import Testing

@MainActor
struct SettingsTests {
    @Test func setWhenUsersHaveSeparateScopesThenPreservesOtherUserValue() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let key = SettingsKey("favorite", defaultValue: false)
        let first = Settings(storage: storage, namespace: "example", userID: "one")
        let second = Settings(storage: storage, namespace: "example", userID: "two")

        // When
        try first.set(true, for: key)

        // Then
        #expect(try !second.value(for: key))
    }

    @Test func valueWhenUserScopeIsReopenedThenRestoresStoredValue() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let key = SettingsKey("favorite", defaultValue: false)
        let first = Settings(storage: storage, namespace: "example", userID: "one")
        try first.set(true, for: key)

        // When
        let reopened = Settings(storage: storage, namespace: "example", userID: "one")

        // Then
        #expect(try reopened.value(for: key))
    }

    @Test func resetWhenScopeIsSharedThenRestoresDefaultAcrossInstances() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let key = SettingsKey("favorite", defaultValue: false)
        let first = Settings(storage: storage, namespace: "example", userID: "one")
        try first.set(true, for: key)
        let reopened = Settings(storage: storage, namespace: "example", userID: "one")

        // When
        first.reset(key)

        // Then
        #expect(try !reopened.value(for: key))
    }

    @Test func setWhenOptionalValueIsNilThenRemovesStoredValue() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let settings = Settings(storage: storage, namespace: "example")
        let optional = SettingsKey<String?>("optional", defaultValue: nil)
        try settings.set("value", for: optional)

        // When
        try settings.set(nil, for: optional)

        // Then
        #expect(try settings.value(for: optional) == nil)
    }

    @Test func setWhenEncodingFailsThenPreservesStoredValue() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let settings = Settings(storage: storage, namespace: "example")
        let number = SettingsKey("number", defaultValue: 0.0)
        try settings.set(2, for: number)

        // When
        let result = Result { try settings.set(.nan, for: number) }

        // Then
        #expect(throws: (any Error).self) { try result.get() }
        #expect(try settings.value(for: number) == 2)
    }

    @Test func valueWhenStoredDataIsCorruptThenThrows() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let settings = Settings(storage: storage, namespace: "example")
        let key = SettingsKey("value", defaultValue: 0)
        try settings.set(1, for: key)
        let storedKey = try #require(storage.persistentDomain(forName: suite)?.keys.first)

        // When
        storage.set(Data("broken".utf8), forKey: storedKey)

        // Then
        #expect(throws: (any Error).self) { try settings.value(for: key) }
    }

    @Test func setWhenWrapperIsObservedThenNotifiesValueChange() async throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let settings = Settings(storage: storage, namespace: "example")
        let wrapper = SettingStorage(
            SettingsKey("name", defaultValue: "default"),
            settings: settings
        )

        // When
        try await confirmation("Setting changes are observed") { changed in
            withObservationTracking {
                _ = wrapper.wrappedValue
            } onChange: {
                changed()
            }
            try wrapper.set("updated")
        }

        // Then
        #expect(try wrapper.wrappedValue.get() == "updated")
    }

    @Test func resetWhenWrapperHasStoredValueThenRestoresDefault() throws {
        // Given
        let suite = "SunCore.Tests." + UUID().uuidString
        let storage = try #require(UserDefaults(suiteName: suite))
        defer { storage.removePersistentDomain(forName: suite) }
        let settings = Settings(storage: storage, namespace: "example")
        let wrapper = SettingStorage(
            SettingsKey("name", defaultValue: "default"),
            settings: settings
        )
        try wrapper.set("updated")

        // When
        wrapper.reset()

        // Then
        #expect(try wrapper.wrappedValue.get() == "default")
    }
}
