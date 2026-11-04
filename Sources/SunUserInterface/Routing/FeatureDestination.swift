//
//  FeatureDestination.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

public protocol FeatureDestination: Hashable {
    static var root: Self { get }
    var isRoot: Bool { get }
}

extension FeatureDestination {
    public var isRoot: Bool { self == .root }
}
