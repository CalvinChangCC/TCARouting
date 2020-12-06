//
//  Main.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum Main {
    struct State: Equatable {
        var animalName: String
    }
    
    enum Action: Equatable {
    }
    
    struct Environment {
    }
    
    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        .none
    }.debug()
}

extension Main {
    typealias RouterType = Store<RouterState, RoutingAction>
    class RouterState: BaseRouterState {
        var push: Push.RouterState
        var pop: Pop.RouterState
        
        init(push: Push.RouterState, pop: Pop.RouterState) {
            self.push = push
            self.pop = pop
            super.init(path: "main", childs: [push, pop], viewMaker: MainView(store: mainStore).eraseToAnyView())
        }
    }
    
    enum RoutingAction {
        case activeStateChanged(Bool)
        case pushStateChanged(Push.RoutingAction)
        case popStateChanged(Pop.RoutingAction)
    }

    static let routingLogic = Reducer<RouterState, RoutingAction, Dependency>.combine(
        Push.routingLogic.pullback(state: \.push, action: /RoutingAction.pushStateChanged, environment: { $0 }),
        Pop.routingLogic.pullback(state: \.pop, action: /RoutingAction.popStateChanged, environment: { $0 }),
        privateRoutingLogic
    )

    static let privateRoutingLogic = Reducer<RouterState, RoutingAction, Dependency> { coordinator, action, _ in
        switch action {
        case .activeStateChanged(let state):
            coordinator.isActive = state
            return .none
        case .pushStateChanged(.backToRoot),
             .popStateChanged(.backToRoot),
             .popStateChanged(.popPushStateChanged(.backToRoot)):
            coordinator.isActive = false
            return .none
        default: return .none
        }
    }.debug()
    
    static let initialRouterState = RouterState(push: Push.initialRouterState, pop: Pop.initialRouterState)

    static let router = Application.router.scope(
        state: \.main,
        action: Application.RoutingAction.mainStateChanged
    )

    static let mainStore = animalStore.scope(state: \.main, action: Animal.Action.mainAction)
}
