//
//  NavigationState.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import Foundation
import Observation

@MainActor @Observable
public final class NavigationState<Destination: FeatureDestination> {
    public var path: [Destination] = []
    public var presentation: FeaturePresentation<Destination>?

    public init() {}

    public func route(path: [Destination], style: (Destination) -> PresentingStyle) {
        self.path = []
        presentation = nil
        let destinations = path.filter { !$0.isRoot }
        for (index, destination) in destinations.enumerated() {
            switch style(destination) {
            case .push: self.path.append(destination)
            case .none: continue
            case let presentationStyle:
                let state = NavigationState()
                state.route(path: Array(destinations.dropFirst(index + 1)), style: style)
                presentation = .init(
                    destination: destination,
                    style: presentationStyle,
                    navigation: state
                )
                return
            }
        }
    }
}
