//
//  NamedLocalizationTable.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/19.
//

public struct NamedLocalizationTable: LocalizationTable {
    public let name: String
    public init(_ name: String) { self.name = name }
}
