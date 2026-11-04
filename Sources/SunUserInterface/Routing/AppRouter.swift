//
//  AppRouter.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import Foundation

public final class AppRouter: AppRouting {
    private let routers: [any Routing]
    private let destinationForURL: (URL) -> (any FeatureDestination)?
    private let activate: (any Routing) -> Void

    public init(
        routers: [any Routing],
        destinationForURL: @escaping (URL) -> (any FeatureDestination)?,
        activate: @escaping (any Routing) -> Void = { _ in }
    ) {
        self.routers = routers
        self.destinationForURL = destinationForURL
        self.activate = activate
    }

    public func canRoute(to destination: any FeatureDestination) -> Bool {
        routers.contains { $0.canRoute(to: destination) }
    }

    public func route(to destination: any FeatureDestination) {
        guard let router = routers.first(where: { $0.canRoute(to: destination) }) else { return }

        activate(router)
        router.route(to: destination)
    }

    public func canRoute(to url: URL) -> Bool {
        guard let destination = destinationForURL(url) else { return false }

        return canRoute(to: destination)
    }

    public func route(to url: URL) {
        guard let destination = destinationForURL(url) else { return }

        route(to: destination)
    }
}
