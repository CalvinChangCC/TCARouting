//
//  PopView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import SwiftUI
import ComposableArchitecture

struct PopView: View {
    let router: Pop.RouterType

    var pushRouter: PopPush.RouterType {
        router.scope(
            state: \.popPush,
            action: Pop.RoutingAction.popPushStateChanged
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                WithViewStore(pushRouter) { router in
                    NavigationLink(
                        destination: router.viewBuilder(pushRouter),
                        isActive: router.binding(
                            get: \.isActive,
                            send: PopPush.RoutingAction.activeStateChanged
                        ),
                        label: {
                            Text("To Pop Push")
                        }
                    )
                }
                WithViewStore(router) { router in
                    Button("Back to Root") {
                        router.send(.backToRoot)
                    }
                }
            }
            .navigationTitle("Pop View")
        }
    }
}
