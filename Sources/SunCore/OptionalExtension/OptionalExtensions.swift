//
//  OptionalExtensions.swift
//  SunCore
//
//  Created by Jiawen Sun on 2023/3/28.
//

public protocol AnyOptional {
    var isNil: Bool { get }
}
extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}
