//
//  FeatureRoutingTests.swift
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
struct FeatureRoutingTests {
    @Test func routeWhenPathAlreadyExistsThenReplacesIt() {
        // Given
        let router = ConsumerRouter()
        router.route(to: .page(1))

        // When
        router.route(to: .page(2))

        // Then
        #expect(router.path == [.page(2)])
    }

    @Test func routeWhenPathMixesPresentationsThenPartitionsNavigation() throws {
        // Given
        let router = TestRouter()

        // When
        router.route(path: [.page(1), .sheet, .page(2), .cover, .page(3)])

        // Then
        #expect(router.path == [.page(1)])
        let sheet = try #require(router.presentation)
        #expect(sheet.style == .sheet)
        #expect(sheet.navigation.path == [.page(2)])
        let cover = try #require(sheet.navigation.presentation)
        #expect(cover.style == .fullScreenCover)
        #expect(cover.navigation.path == [.page(3)])
    }

    @Test func routeWhenRootIsSelectedThenClearsAllPresentations() {
        // Given
        let router = TestRouter()
        router.route(path: [.page(1), .sheet, .page(2), .cover, .page(3)])

        // When
        router.route(to: .root)

        // Then
        #expect(router.path.isEmpty)
        #expect(router.presentation == nil)
    }

    @Test func routeWhenPathHasPopupAndNoneThenKeepsThemOutOfPushPath() {
        // Given
        let router = TestRouter()

        // When
        router.route(path: [.ignored, .page(1), .popup])

        // Then
        #expect(router.path == [.page(1)])
        #expect(router.presentation?.style == .popup)
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
