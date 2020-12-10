//
//  PopPushView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/22.
//

import SwiftUI
import ComposableArchitecture

struct PopPushView: View {
    let router: PopPush.RouterType
    
    init(router: PopPush.RouterType) {
        self.router = router
        print("rtyui")
    }

    var body: some View {
        WithViewStore(router) { router in
            Button("Back to Root") {
                router.send(.backToRoot)
            }.navigationTitle("Pop Push View")
        }
    }
}
