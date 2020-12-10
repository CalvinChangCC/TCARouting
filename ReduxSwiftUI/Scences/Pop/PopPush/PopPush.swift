//
//  PopPush.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/29.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum PopPush {
    typealias RouterType = Store<RouterState, RoutingAction>
    class RouterState: BaseRouterState {
        var viewBuilder: (RouterType) -> PopPushView = {
            PopPushView(router: $0)
        }

        init() {
            super.init(path: "popPush")
        }
    }
    
    enum RoutingAction {
        case activeStateChanged(Bool)
        case backToRoot
    }

    static let routingLogic = Reducer<RouterState, RoutingAction, Dependency> { coordinator, action, _ in
        switch action {
        case .activeStateChanged(let state):
            coordinator.isActive = state
            return .none
        case .backToRoot:
            coordinator.isActive = false
            return .none
        }
    }.debug()
    
    static let initialRouterState = RouterState()
}
