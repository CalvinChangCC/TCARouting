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
        
        init() {
            super.init(path: "popPush", childs: [], viewMaker: PopPushView().eraseToAnyView())
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

    static let router = Pop.router.scope(
        state: \.popPush,
        action: Pop.RoutingAction.popPushStateChanged
    )
}
