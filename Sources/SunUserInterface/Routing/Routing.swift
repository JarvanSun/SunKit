//
//  Routing.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

@MainActor
public protocol Routing: AnyObject {
    func canRoute(to destination: any FeatureDestination) -> Bool
    func route(to destination: any FeatureDestination)
}
