//
//  ModelStorageTests.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import SunCore
import SwiftData
import Testing

@MainActor
struct ModelStorageTests {
    @Test func transactionWhenConsumerInsertsModelThenPersistsUsingItsSchema() throws {
        // Given
        let storage = try ModelStorage.make(schema: Schema([Note.self]), inMemory: true)

        // When
        try storage.transaction { $0.insert(Note(title: "Saved")) }
        let reader = ModelContext(storage.container)

        // Then
        #expect(try reader.fetch(FetchDescriptor<Note>()).map(\.title) == ["Saved"])
        #expect(!storage.context.autosaveEnabled)
    }

    @Test func transactionWhenOperationThrowsThenRollsBackUnsavedChanges() throws {
        // Given
        let storage = try ModelStorage.make(schema: Schema([Note.self]), inMemory: true)
        try storage.transaction { $0.insert(Note(title: "Original")) }

        // When
        let result = Result {
            try storage.transaction { context in
                let existing = try #require(context.fetch(FetchDescriptor<Note>()).first)
                existing.title = "Changed"
                context.insert(Note(title: "Uncommitted"))
                throw SampleFailure.rejected
            }
        }

        // Then
        #expect(throws: SampleFailure.rejected) { try result.get() }
        #expect(try storage.context.fetch(FetchDescriptor<Note>()).map(\.title) == ["Original"])
        let reader = ModelContext(storage.container)
        #expect(try reader.fetch(FetchDescriptor<Note>()).map(\.title) == ["Original"])
    }
}

@Model
private final class Note {
    var title: String
    init(title: String) { self.title = title }
}

private enum SampleFailure: Error { case rejected }
