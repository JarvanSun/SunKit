//
//  RoutingTests.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/3/28.
//

import Foundation
import Observation
import SunUserInterface
import SwiftUI
import Testing

@MainActor
struct RoutingTests {
    @Test func routeWhenTypeErasedRootIsSelectedThenClearsPath() {
        // Given
        let router = ConsumerRouter()
        router.route(to: .page(1))
        let entry: any Routing = router

        // When
        entry.route(to: ConsumerDestination.root)

        // Then
        #expect(router.path.isEmpty)
    }

    @Test func routeWhenDestinationBelongsToAnotherFeatureThenPreservesPath() {
        // Given
        let router = ConsumerRouter()
        router.route(to: .page(1))
        let entry: any Routing = router
        #expect(!entry.canRoute(to: ForeignDestination.root))

        // When
        entry.route(to: ForeignDestination.root)

        // Then
        #expect(router.path == [.page(1)])
    }
}

private enum ConsumerDestination: FeatureDestination {
    case root
    case page(Int)
}

private enum ForeignDestination: FeatureDestination { case root }

private struct ConsumerDestinationView: FeatureDestinationView {
    let destination: ConsumerDestination
    var body: some View { EmptyView() }
}

@Observable
private final class ConsumerRouter: FeatureRouting {
    var presentation: FeaturePresentation<ConsumerDestination>?
    var path: [ConsumerDestination] = []
    func view(for destination: ConsumerDestination) -> ConsumerDestinationView {
        ConsumerDestinationView(destination: destination)
    }
}
