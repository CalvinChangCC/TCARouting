//
//  MainView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import SwiftUI
import ComposableArchitecture

struct MainView: View {
    let router: Main.RouterType
    let store: Store<Main.State, Main.Action>
    
    var popRouter: Pop.RouterType {
        router.scope(
            state: \.pop,
            action: Main.RoutingAction.popStateChanged
        )
    }

    var body: some View {
        
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.animalName).padding()
                IfLetStore(
                    router.scope(
                        state: \.push,
                        action: Main.RoutingAction.pushStateChanged
                    ),
                    then: {
                        NavigationLink(
                            destination: ViewStore($0).viewBuilder($0),
                            isActive: ViewStore($0).binding(get: \.isActive, send: Push.RoutingAction.activeStateChanged),
                            label: {
                                Text("To Push")
                            }
                        )
                    }
                )
                WithViewStore(popRouter) { router in
                    Button("To Pop") {
                        router.send(.activeStateChanged(true))
                    }
                    .sheet(
                        isPresented: router.binding(
                            get: \.isActive,
                            send: Pop.RoutingAction.activeStateChanged
                        ), content: { router.viewBuilder(popRouter) }
                    )
                }
                
            }
            
        }
    }
}
