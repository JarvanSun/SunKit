//
//  ArrayExtensions.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

extension Array {
    public func filterNotNil<T>() -> [T] where Element == T? { compactMap { $0 } }
}
