//
//  PopPushView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/22.
//

import SwiftUI
import ComposableArchitecture

struct PopPushView: View {
    let router: RouterType

    var body: some View {
        WithViewStore(router) { router in
            Button(
                "Back to Main",
                action: {
                    router.send(.popUpPop)
                }
            ).navigationTitle("Pop Push View")
        }
    }
}

struct PopPushView_Previews: PreviewProvider {
    static var previews: some View {
        PopPushView(router: RouterTest.store)
    }
}
