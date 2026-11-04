//
//  FeatureHost.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import SwiftUI

public protocol FeatureHost: View {
    associatedtype Router: FeatureRouting
    associatedtype Root: View
    var featureRouter: Router { get }
    var appRouter: (any AppRouting)? { get }
    var addContentInNavigationView: Bool { get }
    @ViewBuilder var root: Root { get }
}

extension FeatureHost {
    public var appRouter: (any AppRouting)? { nil }
    public var addContentInNavigationView: Bool { true }

    public var body: some View {
        Navigator(
            path: Binding(get: { featureRouter.path }, set: { featureRouter.path = $0 }),
            presentation: Binding(
                get: { featureRouter.presentation },
                set: { featureRouter.presentation = $0 }
            ),
            wrapsNavigation: addContentInNavigationView,
            root: { root },
            destination: featureRouter.view
        )
        .onOpenURL { appRouter?.route(to: $0) }
    }
}
