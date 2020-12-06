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
    
    var body: some View {
        NavigationView {
            AnimalView(
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(
//            store: Store(
//                initialState: Application.State(
//                    animal: Animal.State(
//                        main: Main.State(animalName: "")
//                    )
//                ),
//                reducer: Application.reducer,
//                environment: Application.Environment(animalService: AnimalService())), router: mainRouter
//        )
//    }
//}
