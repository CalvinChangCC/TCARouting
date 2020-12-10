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
    }
}

extension Main {
    typealias RouterType = Store<RouterState, RoutingAction>
    class RouterState: BaseRouterState {
        var push: Push.RouterState?
        var pop: Pop.RouterState
        
        var viewBuilder: (RouterType) -> MainView = {
            MainView(router: $0, store: mainStore)
        }
        
        init(push: Push.RouterState? = nil, pop: Pop.RouterState) {
            self.push = push
            self.pop = pop
            var childs: [Routable] = [pop]
            if let push = push {
                childs.append(push)
            }
            super.init(path: "main", childs: childs)
        }
    }
    
    enum RoutingAction {
        case activeStateChanged(Bool)
        case pushStateChanged(Push.RoutingAction)
        case popStateChanged(Pop.RoutingAction)
    }

    static let routingLogic = Reducer<RouterState, RoutingAction, Dependency>.combine(
        Push.routingLogic.optional().pullback(state: \.push, action: /RoutingAction.pushStateChanged, environment: { $0 }),
        Pop.routingLogic.pullback(state: \.pop, action: /RoutingAction.popStateChanged, environment: { $0 }),
        privateRoutingLogic
    )

    static let privateRoutingLogic = Reducer<RouterState, RoutingAction, Dependency> { coordinator, action, _ in
        switch action {
        case .activeStateChanged(let state):
            coordinator.isActive = state
            if state {
                let push = Push.RouterState()
                coordinator.push = push
                coordinator.childs.append(push)
            }
            return .none
        case .pushStateChanged(.backToRoot),
             .popStateChanged(.backToRoot),
             .popStateChanged(.popPushStateChanged(.backToRoot)):
            coordinator.isActive = false
            return .none
        default: return .none
        }
    }

    static let mainStore = animalStore.scope(state: \.main, action: Animal.Action.mainAction)
}
