//
//  Application.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import Foundation
import ComposableArchitecture
import SwiftUI

enum Application {
    struct State: Equatable {
        var animal: Animal.State
    }

    enum Action: Equatable {
        case animalRelate(action: Animal.Action)
    }

    struct Environment {
        let animalService: AnimalService
    }

    static let reducer = Reducer<State, Action, Environment>.combine(
        Animal.reducer.pullback(
            state: \.animal,
            action: /Action.animalRelate(action:),
            environment: { Animal.Environment(animalService: $0.animalService ) }),
        Reducer { state, action, environment in
            switch action {
            case .animalRelate:
                return .none
            }
        }
    ).debug()
}

extension Application {
    typealias RouterType = Store<RouterState, RoutingAction>
    class RouterState: BaseRouterState {
        var main: Main.RouterState
        
        var viewBuilder: (RouterType) -> ContentView = {
            ContentView(router: $0, store: contentStore)
        }
        
        init(main: Main.RouterState) {
            self.main = main
            super.init(path: "//", childs: [main])
        }
    }
    
    enum RoutingAction {
        case activeStateChanged(Bool)
        case mainStateChanged(Main.RoutingAction)
        case routeTo(path: [String])
    }

    static let routingLogic = Reducer<RouterState, RoutingAction, Dependency>.combine(
        Main.routingLogic
            .pullback(
                state: \.main,
                action: /RoutingAction.mainStateChanged,
                environment: { $0 }
            ),
        privateRoutingLogic
    )
    
    private static let privateRoutingLogic = Reducer<RouterState, RoutingAction, Dependency> { routerState, action, _ in
        switch action {
        case .activeStateChanged(let state):
            routerState.isActive = state
            return .none
        case .routeTo(let paths):
            routerState.isActive = true
            let paths = Array(paths.dropFirst())
            for index in 0 ..< routerState.childs.count {
                trigger(router: &routerState.childs[index], paths: paths)
            }
            return .none
        default: return .none
        }
    }.debug()
    
    private static func trigger(router: inout Routable, paths: [String]) {
        guard !paths.isEmpty, router.path == paths.first else { return }
        router.isActive = true
        let paths = Array(paths.dropFirst())
        for index in 0 ..< router.childs.count {
            trigger(router: &router.childs[index], paths: paths)
        }
    }
    
    static let initialRouterState = RouterState(main: Main.RouterState(push: .init(), pop: .init(popPush: .init())))

    static let router = Store(
        initialState: initialRouterState,
        reducer: routingLogic,
        environment: Dependency()
    )
}
