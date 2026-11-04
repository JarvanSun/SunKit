//
//  ModelStorage.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import SwiftData

@MainActor
public final class ModelStorage {
    public let container: ModelContainer
    public let context: ModelContext

    public init(container: ModelContainer) {
        self.container = container
        context = ModelContext(container)
        context.autosaveEnabled = false
    }

    public static func make(
        schema: Schema,
        inMemory: Bool = false,
        url: URL? = nil
    ) throws -> ModelStorage {
        let configuration: ModelConfiguration
        if let url {
            configuration = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
        } else {
            configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: inMemory,
                cloudKitDatabase: .none
            )
        }
        return try ModelStorage(
            container: ModelContainer(for: schema, configurations: [configuration])
        )
    }

    public func transaction(_ changes: (ModelContext) throws -> Void) throws {
        do {
            try changes(context)
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
}
