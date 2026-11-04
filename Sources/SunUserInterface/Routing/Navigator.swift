//
//  Navigator.swift
//  SunUserInterface
//
//  Created by Jiawen Sun on 2023/4/20.
//

import SwiftUI

public struct Navigator<DestinationView: FeatureDestinationView, Root: View>: View {
    @Binding private var path: [DestinationView.Destination]
    @Binding private var presentation: FeaturePresentation<DestinationView.Destination>?
    private let root: Root
    private let destination: (DestinationView.Destination) -> DestinationView
    private let wrapsNavigation: Bool

    public init(
        path: Binding<[DestinationView.Destination]>,
        presentation: Binding<FeaturePresentation<DestinationView.Destination>?>,
        wrapsNavigation: Bool = true,
        @ViewBuilder root: () -> Root,
        destination: @escaping (DestinationView.Destination) -> DestinationView
    ) {
        _path = path
        _presentation = presentation
        self.wrapsNavigation = wrapsNavigation
        self.root = root()
        self.destination = destination
    }

    public var body: some View {
        Group {
            if wrapsNavigation {
                NavigationStack(path: $path) { navigationContent }
            } else {
                navigationContent
            }
        }
        .modifier(
            FeaturePresentationModifier(presentation: $presentation, destination: destination)
        )
        .setPopupRoot()
    }

    private var navigationContent: some View {
        root.navigationDestination(for: DestinationView.Destination.self, destination: destination)
    }
}

struct FeaturePresentationModifier<DestinationView: FeatureDestinationView>: ViewModifier {
    @Binding var presentation: FeaturePresentation<DestinationView.Destination>?
    let destination: (DestinationView.Destination) -> DestinationView

    func body(content: Content) -> some View {
        content.present(
            item: $presentation,
            style: { $0.style },
            destination: { item in
                AnyView(
                    Navigator(
                        path: Binding(
                            get: { item.navigation.path },
                            set: { item.navigation.path = $0 }
                        ),
                        presentation: Binding(
                            get: { item.navigation.presentation },
                            set: { item.navigation.presentation = $0 }
                        ),
                        root: { destination(item.destination) },
                        destination: destination
                    )
                )
            }
        )
    }
}

extension View {
    public func featurePresentation<Router: FeatureRouting>(_ router: Router) -> some View {
        modifier(
            FeaturePresentationModifier(
                presentation: Binding(
                    get: { router.presentation },
                    set: { router.presentation = $0 }
                ),
                destination: router.view
            )
        )
    }
}
