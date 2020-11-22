//
//  ContentView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/10/27.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: Store<Application.State, Application.Action>
    let router: RouterType
    
    var body: some View {
        NavigationView {
            AnimalView(
                store:
                    store.scope(
                        state: \.animal,
                        action: Application.Action.animalRelate(action:)
                    ), router: router
            ).navigationTitle("Animal")
        }
    }
}

struct AnimalView: View {
    @State var test = false
    let store: Store<Animal.State, Animal.Action>
    let router: RouterType

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                if viewStore.inProgress  {
                    ProgressView("Fetching Animal…")
                } else if let error = viewStore.error {
                    Text("Some error occur\n \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                    Button("Try again", action: {
                        viewStore.send(.fetch)
                    })
                } else {
                    Text(viewStore.current)
                        .font(.system(.largeTitle))
                        .padding()
                    Button(
                        "Tap me",
                        action: { viewStore.send(.fetch) }
                    )
                    WithViewStore(router) { router in
                        NavigationLink(
                            destination: router.main.view,
                            isActive: router.binding(
                                get: \.main.isActive,
                                send: { $0
                                    ? .navigateToMain(
                                        self.store.scope(
                                            state: \.main,
                                            action: Animal.Action.mainAction),
                                        self.router
                                    )
                                    : .popUpMain
                                }
                            ),
                            label: {
                                Text("To Main")
                            }
                        )
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: Application.State(animal: Animal.State(main: Main.State(animalName: ""))),
                reducer: Application.reducer,
                environment: Application.Environment(animalService: AnimalService())),
            router: RouterTest.store
        )
    }
}
