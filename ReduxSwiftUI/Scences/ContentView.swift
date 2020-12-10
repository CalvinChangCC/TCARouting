//
//  ContentView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/10/27.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let router: Application.RouterType
    let store: Store<Application.State, Application.Action>
    
    var body: some View {
        NavigationView {
            AnimalView(
                router: router,
                store:
                    store.scope(
                        state: \.animal,
                        action: Application.Action.animalRelate(action:)
                    )
            )
            .navigationTitle("Animal")
        }
    }
}
