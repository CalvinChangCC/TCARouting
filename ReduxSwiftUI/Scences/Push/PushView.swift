//
//  PushView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import SwiftUI
import ComposableArchitecture

struct PushView: View {
    let router: Push.RouterType

    var body: some View {
        WithViewStore(router) { router in
            Button("Back to Root") {
                router.send(.backToRoot)
            }
        }
        .navigationTitle("Push View")
    }
}
