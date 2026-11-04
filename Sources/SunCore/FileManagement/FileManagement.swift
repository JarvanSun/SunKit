//
//  FileManagement.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation

public enum FileManagement {
    public enum LoadingError: Error, Equatable {
        case resourceNotFound(String)
    }

    public static func loadLocalJSON<T: Decodable>(
        bundle: Bundle,
        fileName: String,
        fileExtension: String = "json",
        dataModel: T.Type = T.self
    ) throws -> T {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            throw LoadingError.resourceNotFound(fileName + "." + fileExtension)
        }

        return try loadJSON(from: url, as: dataModel)
    }

    public static func loadJSON<T: Decodable>(from url: URL, as type: T.Type = T.self) throws -> T {
        try JSONDecoder().decode(type, from: Data(contentsOf: url))
    }
}
