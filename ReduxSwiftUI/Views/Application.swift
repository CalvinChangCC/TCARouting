//
//  Application.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import Foundation
import ComposableArchitecture

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

//extension Application {
//    struct Destination {
//        let contentView: ContentView
//        let contentState: Application.State
//    }
//    
//    enum RoutingAction {
//        case contentActiveChanged(Bool)
//        case contentAction(Application.Action)
//    }
//    
//    struct RoutingEnviroment {}
//    
//    static let routing = Reducer<Destination, RoutingAction, RoutingEnviroment>.combine(
//        reducer
//            .pullback(
//                state: \.contentState,
//                action: RoutingAction.contentAction,
//                environment: { RoutingEnviroment() }
//            ),
//        Reducer<Destination, RoutingAction, RoutingEnviroment> { destination, action, _ in
//            switch action {
//            
//            }
//        }
//    )
//    
//    static let initialDestination = Destination(contentView: ContentView(store: <#T##Store<State, Action>#>, router: <#T##Store<Animal.Destination, Animal.RoutingAction>#>))
//}

