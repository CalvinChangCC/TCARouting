//
//  Push.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/29.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum Push {
    typealias RouterType = Store<RouterState, RoutingAction>
    class RouterState: BaseRouterState {
        
        init() {
            super.init(path: "push", childs: [], viewMaker: PushView().eraseToAnyView())
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
        default: return .none
        }
    }.debug()
    
    static let initialRouterState = RouterState()

    static let router = Main.router.scope(
        state: \.push,
        action: Main.RoutingAction.pushStateChanged
    )
}
