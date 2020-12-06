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
            WithViewStore(Application.router) { router in
                router.viewMaker
                    .onOpenURL {
                        router.send(.routeTo(path: manage(url: $0)))
                    }
                    .onAppear {
                        if let url = URL(string: "https://animal.generator.io/main/pop/popPush") {
                            print(url.query)
                            print(url.pathComponents)
                            print(url.path)
                            router.send(.routeTo(path: manage(url: url)))
                        }
                    }
            }
            
        }
    }
    
    func manage(url: URL) -> [String] {
        return url.pathComponents
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

let contentStore = Store(
    initialState: Application.State(animal: Animal.State(main: Main.State(animalName: ""))),
    reducer: Application.reducer,
    environment: Application.Environment(animalService: AnimalService())
)

let animalStore = contentStore.scope(
    state: \.animal,
    action: Application.Action.animalRelate(action:)
)
