//
//  FeatureRouting.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import Observation

public protocol FeatureRouting: Routing, Observable {
    associatedtype DestinationView: FeatureDestinationView

    var presentation: FeaturePresentation<DestinationView.Destination>? { get set }
    var path: [DestinationView.Destination] { get set }

    func route(to destination: DestinationView.Destination)
    func route(path: [DestinationView.Destination])
    func path(to destination: DestinationView.Destination) -> [DestinationView.Destination]
    func view(for destination: DestinationView.Destination) -> DestinationView
}

extension FeatureRouting {
    public func canRoute(to destination: any FeatureDestination) -> Bool {
        destination is DestinationView.Destination
    }

    public func route(to destination: any FeatureDestination) {
        guard let destination = destination as? DestinationView.Destination else { return }

        route(to: destination)
    }

    public func route(to destination: DestinationView.Destination) {
        route(path: path(to: destination))
    }

    public func route(path: [DestinationView.Destination]) {
        let state = NavigationState<DestinationView.Destination>()
        state.route(path: path) { view(for: $0).style }
        self.path = state.path
        presentation = state.presentation
    }

    public func path(to destination: DestinationView.Destination) -> [DestinationView.Destination] {
        destination.isRoot ? [] : [destination]
    }
}
