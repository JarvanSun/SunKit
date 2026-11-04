//
//  AppRouterTests.swift
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
struct AppRouterTests {
    @Test func routeWhenURLMatchesFeatureThenActivatesItsRouter() {
        // Given
        let router = TestRouter()
        var activationCount = 0
        let appRouter = AppRouter(
            routers: [router],
            destinationForURL: { url in
                url.scheme == "example" && url.host == "page" ? TestDestination.page(7) : nil
            },
            activate: { _ in activationCount += 1 }
        )
        let accepted = URL(string: "example://page")!

        // When
        appRouter.route(to: accepted)

        // Then
        #expect(router.path == [.page(7)])
        #expect(activationCount == 1)
    }

    @Test func canRouteWhenURLMatchesFeatureThenReturnsTrue() {
        // Given
        let router = TestRouter()
        let appRouter = AppRouter(
            routers: [router],
            destinationForURL: { url in
                url.scheme == "example" && url.host == "page" ? TestDestination.page(7) : nil
            }
        )
        let url = URL(string: "example://page")!

        // When
        let accepted = appRouter.canRoute(to: url)

        // Then
        #expect(accepted)
    }

    @Test func canRouteWhenURLIsUnknownThenReturnsFalse() {
        // Given
        let router = TestRouter()
        let appRouter = AppRouter(
            routers: [router],
            destinationForURL: { url in
                url.scheme == "example" && url.host == "page" ? TestDestination.page(7) : nil
            }
        )
        let url = URL(string: "https://invalid.example")!

        // When
        let accepted = appRouter.canRoute(to: url)

        // Then
        #expect(!accepted)
    }
}

private enum TestDestination: FeatureDestination {
    case root
    case page(Int)
    case sheet, cover, popup, ignored
}

private struct TestDestinationView: FeatureDestinationView {
    let destination: TestDestination
    var style: PresentingStyle {
        switch destination {
        case .sheet: .sheet
        case .cover: .fullScreenCover
        case .popup: .popup
        case .ignored: .none
        default: .push
        }
    }
    var body: some View { Text("Destination") }
}

@Observable
private final class TestRouter: FeatureRouting {
    var path: [TestDestination] = []
    var presentation: FeaturePresentation<TestDestination>?
    func view(for destination: TestDestination) -> TestDestinationView {
        .init(destination: destination)
    }
}
