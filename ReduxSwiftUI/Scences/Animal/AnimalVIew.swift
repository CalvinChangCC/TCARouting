//
//  AnimalVIew.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/12/1.
//

import SwiftUI
import ComposableArchitecture

struct AnimalView: View {
    let store: Store<Animal.State, Animal.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.inProgress  {
                    ProgressView("Fetching Animal…")
                } else if let error = viewStore.error {
                    Text("Some error occur\n \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Try again") {
                        viewStore.send(.fetch)
                    }
                } else {
                    Text(viewStore.current)
                        .font(.system(.largeTitle))
                        .padding()
                    Button("Tap me") { viewStore.send(.fetch) }
                    WithViewStore(Main.router) { router in
                        NavigationLink(
                            destination: router.viewMaker,
                            isActive: router.binding(get: \.isActive, send: {
                                if $0 { viewStore.send(.setName) }
                                return Main.RoutingAction.activeStateChanged($0)
                            }),
                            label: {
                                Text("To main")
                            }
                        )
                    }
                }
            }
        }
    }
}
