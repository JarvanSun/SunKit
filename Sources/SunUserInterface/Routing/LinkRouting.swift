//
//  LinkRouting.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import Foundation

@MainActor
public protocol LinkRouting: AnyObject {
    func canRoute(to url: URL) -> Bool
    func route(to url: URL)
}
