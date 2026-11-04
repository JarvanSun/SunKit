//
//  FileManagementTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SunCore
import Testing

struct FileManagementTests {
    @Test func loadJSONWhenFileIsValidThenDecodesPayload() throws {
        // Given
        let file = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: file) }
        try Data(#"{"number":3}"#.utf8).write(to: file)

        // When
        let value = try FileManagement.loadJSON(from: file, as: Payload.self)

        // Then
        #expect(value.number == 3)
    }

    @Test func loadJSONWhenFileIsMalformedThenThrows() throws {
        // Given
        let file = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: file) }
        try Data("broken".utf8).write(to: file)

        // When
        let result = Result { try FileManagement.loadJSON(from: file, as: Payload.self) }

        // Then
        #expect(throws: (any Error).self) { try result.get() }
    }

    @Test func loadLocalJSONWhenFileIsMissingThenThrowsLoadingError() {
        // Given
        let fileName = UUID().uuidString

        // When
        let result = Result {
            try FileManagement.loadLocalJSON(
                bundle: .main,
                fileName: fileName,
                dataModel: Payload.self
            )
        }

        // Then
        #expect(throws: FileManagement.LoadingError.self) { try result.get() }
    }
}

private struct Payload: Codable { let number: Int }
