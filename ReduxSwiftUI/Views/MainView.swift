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
    
    let router: RouterType

    var body: some View {
        WithViewStore(store) { viewStore in
            WithViewStore(router) { router in
                VStack {
                    NavigationLink(
                        destination: router.state.push.view,
                        isActive: router.binding(
                            get: \.push.isActive,
                            send: { $0 ? .navigateToPush: .popUpPush }
                        ),
                        label: {
                            Text("Push")
                        }
                    )
                    Button(action: {
                        router.send(.navigateToPop)
                    }, label: {
                        Text("Pop")
                    })
                }.sheet(
                    isPresented: router.binding(
                        get: \.pop.isActive,
                        send: { $0 ? .navigateToPop: .popUpPop }
                    ), content: { router.state.pop.view }
                )
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
            ), router: RouterTest.store
        )
    }
}
