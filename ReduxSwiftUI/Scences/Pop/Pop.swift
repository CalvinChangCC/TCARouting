//
//  Pop.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/29.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum Pop {
    typealias RouterType = Store<RouterState, RoutingAction>
    class RouterState: BaseRouterState {
        var popPush: PopPush.RouterState
        
        init(popPush: PopPush.RouterState) {
            self.popPush = popPush
            super.init(path: "pop", childs: [popPush], viewMaker: PopView().eraseToAnyView())
        }
    }
    
    enum RoutingAction {
        case activeStateChanged(Bool)
        case popPushStateChanged(PopPush.RoutingAction)
        case backToRoot
    }

    static let routingLogic = Reducer<RouterState, RoutingAction, Dependency>.combine(
        PopPush.routingLogic.pullback(state: \.popPush, action: /RoutingAction.popPushStateChanged, environment: { $0 }),
        privateRoutingLogic
    )
    
    static let privateRoutingLogic = Reducer<RouterState, RoutingAction, Dependency> { coordinator, action, _ in
        switch action {
        case .activeStateChanged(let state):
            coordinator.isActive = state
            return .none
        case .popPushStateChanged(.backToRoot),
             .backToRoot:
            coordinator.isActive = false
            return .none
        default: return .none
        }
    }.debug()
    
    static let initialRouterState = RouterState(popPush: PopPush.initialRouterState)

    static let router = Main.router.scope(
        state: \.pop,
        action: Main.RoutingAction.popStateChanged
    )
}
