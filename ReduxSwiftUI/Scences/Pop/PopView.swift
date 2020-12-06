//
//  PopView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import SwiftUI
import ComposableArchitecture

struct PopView: View {
    var body: some View {
        NavigationView {
            VStack {
                WithViewStore(PopPush.router) { router in
                    NavigationLink(
                        destination: router.viewMaker,
                        isActive: router.binding(
                            get: \.isActive,
                            send: PopPush.RoutingAction.activeStateChanged
                        ),
                        label: {
                            Text("To Pop Push")
                        }
                    )
                }
                WithViewStore(Pop.router) { router in
                    Button("Back to Root") {
                        router.send(.backToRoot)
                    }
                }
            }
            .navigationTitle("Pop View")
        }
    }
}

struct PopView_Previews: PreviewProvider {
    static var previews: some View {
        PopView()
    }
}
