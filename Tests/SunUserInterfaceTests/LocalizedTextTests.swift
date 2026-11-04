//
//  LocalizedTextTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunUserInterface
import Testing

struct LocalizedTextTests {
    @Test func resolvedWhenBothBundlesContainKeyThenPrefersAppBundle() throws {
        // Given
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let app = try makeBundle(
            at: root.appendingPathComponent("App.bundle"),
            translations: ["en": ["title": "App title"], "de": ["title": "App Titel"]]
        )
        let library = try makeBundle(
            at: root.appendingPathComponent("Library.bundle"),
            translations: [
                "en": ["title": "Library title", "fallback": "Library", "format": "Hello %@"],
                "de": ["title": "Library Titel", "fallback": "Bibliothek", "format": "Hallo %@"],
            ]
        )
        let table = NamedLocalizationTable("Example")
        let text = LocalizedString(
            key: "title",
            table: table,
            bundle: app,
            definingBundle: library
        )

        // When
        let value = text.resolved(locale: Locale(identifier: "en"))

        // Then
        #expect(value == "App title")
    }

    @Test func resolvedWhenLocaleChangesThenUsesNewTranslation() throws {
        // Given
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let app = try makeBundle(
            at: root.appendingPathComponent("App.bundle"),
            translations: ["en": ["title": "App title"], "de": ["title": "App Titel"]]
        )
        let library = try makeBundle(
            at: root.appendingPathComponent("Library.bundle"),
            translations: [
                "en": ["title": "Library title", "fallback": "Library", "format": "Hello %@"],
                "de": ["title": "Library Titel", "fallback": "Bibliothek", "format": "Hallo %@"],
            ]
        )
        let table = NamedLocalizationTable("Example")
        let text = LocalizedString(
            key: "title",
            table: table,
            bundle: app,
            definingBundle: library
        )
        let original = text.resolved(locale: Locale(identifier: "en"))
        try #require(original == "App title")

        // When
        let value = text.resolved(locale: Locale(identifier: "de"))

        // Then
        #expect(value == "App Titel")
    }

    @Test func resolvedWhenAppKeyIsMissingThenFallsBackToLibrary() throws {
        // Given
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let app = try makeBundle(
            at: root.appendingPathComponent("App.bundle"),
            translations: ["en": ["title": "App title"], "de": ["title": "App Titel"]]
        )
        let library = try makeBundle(
            at: root.appendingPathComponent("Library.bundle"),
            translations: [
                "en": ["title": "Library title", "fallback": "Library", "format": "Hello %@"],
                "de": ["title": "Library Titel", "fallback": "Bibliothek", "format": "Hallo %@"],
            ]
        )
        let table = NamedLocalizationTable("Example")
        let text = LocalizedString(
            key: "fallback",
            table: table,
            bundle: app,
            definingBundle: library
        )

        // When
        let value = text.resolved(locale: Locale(identifier: "de"))

        // Then
        #expect(value == "Bibliothek")
    }

    @Test func resolvedWhenArgumentsAreProvidedThenSubstitutesValues() throws {
        // Given
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let app = try makeBundle(
            at: root.appendingPathComponent("App.bundle"),
            translations: ["en": ["title": "App title"], "de": ["title": "App Titel"]]
        )
        let library = try makeBundle(
            at: root.appendingPathComponent("Library.bundle"),
            translations: [
                "en": ["title": "Library title", "fallback": "Library", "format": "Hello %@"],
                "de": ["title": "Library Titel", "fallback": "Bibliothek", "format": "Hallo %@"],
            ]
        )
        let table = NamedLocalizationTable("Example")
        let text = LocalizedString(
            key: "format",
            table: table,
            bundle: app,
            definingBundle: library,
            args: [.string("Sun")]
        )

        // When
        let value = text.resolved(locale: Locale(identifier: "de"))

        // Then
        #expect(value == "Hallo Sun")
    }

    @Test func resolvedWhenKeyHasNoTranslationThenReturnsKey() throws {
        // Given
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let app = try makeBundle(
            at: root.appendingPathComponent("App.bundle"),
            translations: ["en": ["title": "App title"], "de": ["title": "App Titel"]]
        )
        let library = try makeBundle(
            at: root.appendingPathComponent("Library.bundle"),
            translations: [
                "en": ["title": "Library title", "fallback": "Library", "format": "Hello %@"],
                "de": ["title": "Library Titel", "fallback": "Bibliothek", "format": "Hallo %@"],
            ]
        )
        let table = NamedLocalizationTable("Example")
        let text = LocalizedString(
            key: "missing",
            table: table,
            bundle: app,
            definingBundle: library
        )

        // When
        let value = text.resolved()

        // Then
        #expect(value == "missing")
    }

    @Test func resolvedWhenTextIsVerbatimThenPreservesPercentSymbol() {
        // Given
        let text = LocalizedString(verbatim: "100%")

        // When
        let value = text.resolved()

        // Then
        #expect(value == "100%")
    }

    @Test(arguments: [(1, "1 item"), (2, "2 items")])
    func resolvedWhenCountIsProvidedThenSelectsPluralForm(count: Int, expected: String) throws {
        // Given
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let bundle = try makeBundle(
            at: root.appendingPathComponent("App.bundle"),
            translations: ["en": [:]]
        )
        let plural = LocalizedString(
            key: "items",
            table: NamedLocalizationTable("Example"),
            bundle: bundle,
            definingBundle: bundle,
            args: [.integer(count)]
        )

        // When
        let value = plural.resolved(locale: Locale(identifier: "en"))

        // Then
        #expect(value == expected)
    }

    private func makeBundle(at url: URL, translations: [String: [String: String]]) throws -> Bundle
    {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        let info: [String: Any] = [
            "CFBundleIdentifier": UUID().uuidString, "CFBundleDevelopmentRegion": "en",
            "CFBundleLocalizations": Array(translations.keys),
        ]
        try PropertyListSerialization.data(fromPropertyList: info, format: .xml, options: 0).write(
            to: url.appendingPathComponent("Info.plist")
        )
        for (language, values) in translations {
            let directory = url.appendingPathComponent(language + ".lproj")
            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )
            try PropertyListSerialization.data(fromPropertyList: values, format: .xml, options: 0)
                .write(to: directory.appendingPathComponent("Example.strings"))
        }
        let plurals: [String: Any] = [
            "items": [
                "NSStringLocalizedFormatKey": "%#@count@",
                "count": [
                    "NSStringFormatSpecTypeKey": "NSStringPluralRuleType",
                    "NSStringFormatValueTypeKey": "lld",
                    "one": "%lld item",
                    "other": "%lld items",
                ],
            ]
        ]
        try PropertyListSerialization.data(fromPropertyList: plurals, format: .xml, options: 0)
            .write(to: url.appendingPathComponent("en.lproj/Example.stringsdict"))
        return try #require(Bundle(url: url))
    }
}
