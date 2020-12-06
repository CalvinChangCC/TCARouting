//
//  MainView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let store: Store<Main.State, Main.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.animalName).padding()
                WithViewStore(Push.router) { router in
                    NavigationLink(
                        destination: router.viewMaker,
                        isActive: router.binding(get: \.isActive, send: Push.RoutingAction.activeStateChanged),
                        label: {
                            Text("To Push")
                        }
                    )
                }
                WithViewStore(Pop.router) { router in
                    Button("To Pop") {
                        router.send(.activeStateChanged(true))
                    }
                    .sheet(
                        isPresented: router.binding(
                            get: \.isActive,
                            send: Pop.RoutingAction.activeStateChanged
                        ), content: { router.viewMaker }
                    )
                }
                
            }
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            store: Store<Main.State, Main.Action>(
                initialState: Main.State(animalName: "me"),
                reducer: Main.reducer,
                environment: Main.Environment()
            )
        )
    }
}
