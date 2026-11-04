//
//  CaseIterable.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

extension CaseIterable where Self: RawRepresentable {
    public static var allValues: [RawValue] { allCases.map(\.rawValue) }
}
