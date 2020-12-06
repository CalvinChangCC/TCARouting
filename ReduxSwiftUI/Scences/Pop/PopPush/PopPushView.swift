//
//  PopPushView.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/22.
//

import SwiftUI
import ComposableArchitecture

struct PopPushView: View {
    var body: some View {
        WithViewStore(PopPush.router) { router in
            Button("Back to Root") {
                router.send(.backToRoot)
            }.navigationTitle("Pop Push View")
        }
    }
}

struct PopPushView_Previews: PreviewProvider {
    static var previews: some View {
        PopPushView()
    }
}
