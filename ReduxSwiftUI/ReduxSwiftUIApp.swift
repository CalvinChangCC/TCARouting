//
//  ReduxSwiftUIApp.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/10/27.
//

import SwiftUI
import ComposableArchitecture

@main
struct ReduxSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: Application.State(animal: Animal.State(main: Main.State(animalName: ""))),
                    reducer: Application.reducer,
                    environment: Application.Environment(animalService: AnimalService())
                ), router: RouterTest.store
            ).environmentObject(router)
        }
    }
}

let router = Router<Destination, RoutingAction>(
    initialState: Destination(main: .init(path: "main"), push: .init(path: "push"), pop: .init(path: "pop"), popPush: .init(path: "poppush")),
    navigation: navigator(destination:action:))
