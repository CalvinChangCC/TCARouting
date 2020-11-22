//
//  PopView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import SwiftUI
import ComposableArchitecture

struct PopView: View {
    let router: Store<PopRouter.Destination, PopRouter.RoutingAction>

    var body: some View {
        WithViewStore(router) { router in
            NavigationView {
                NavigationLink(
                    destination: router.state.popPush.view,
                    isActive: router.binding(
                        get: \.popPush.isActive,
                        send: {
                            $0
                                ? .navigateToPopPush
                                : .popUpPopPush
                        }
                    ),
                    label: {
                        Text("Push")
                    }
                ).navigationTitle("Pop View")
            }
        }
    }
}

struct PopView_Previews: PreviewProvider {
    static var previews: some View {
        PopView(router: PopRouter.router)
    }
}
