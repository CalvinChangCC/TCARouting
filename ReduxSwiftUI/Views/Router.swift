//
//  File.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/22.
//

import Foundation
import Combine
import ComposableArchitecture
import SwiftUI

struct Destination {
    var main: DestinationState<MainView>
    var push: DestinationState<PushView>
    var pop: DestinationState<PopView>
    var popPush: DestinationState<PopPushView>
}

class DestinationState<DestinationView: View>: Equatable, ObservableObject {
    static func == (lhs: DestinationState<DestinationView>, rhs: DestinationState<DestinationView>) -> Bool {
        lhs.path == rhs.path
    }
    
    var view: DestinationView?
    var isActive: Bool { view != nil }
    let path: String
    
    init(path: String) {
        self.view = nil
        self.path = path
    }
    
    func set(view: DestinationView?) {
        self.view = view
    }
}

enum RoutingAction {
    case navigateToMain(Store<Main.State, Main.Action>)
    case test
    case cancel
    case testPush
    case testPop
    case cancelPush
    case cancelPop
    case navigateToPopPush
    case cancelPopPush
}

func navigator(destination: inout Destination, action: RoutingAction) -> Void {
    switch action {
    case .navigateToMain(let store):
        print("go to main")
//        destination.main.set(view: MainView(store: store))
//        destination.main.isActive.toggle()
    case .cancel:
//        destination.main.isActive = false
        destination.main.set(view: nil)
        print("main cancel")
    case .testPush:
        print("go to push")
        destination.push.set(
            view: PushView()
        )
//        destination.push.isActive.toggle()
    case .testPop:
        print("go to pop")
        
//        destination.pop.set(view: PopView(router: router))
//        destination.pop.isActive.toggle()
    case .cancelPush:
        print("cancel to push")

//        destination.push.isActive = false
        destination.push.set(view: nil)
    case .cancelPop:
        print("cancel to pop")

//        destination.pop.isActive = false
        destination.popPush.set(view: nil)
        destination.pop.set(view: nil)
    case .navigateToPopPush:
        print("navigate to pop push")

//        destination.popPush.set(view: PopPushView(router: router))
//        destination.popPush.isActive.toggle()
    case .cancelPopPush:
        print("cancel pop push")
//        destination.popPush.isActive = false
        destination.popPush.set(view: nil)
    default: return
    }

}

struct MainDestination {
    var push: DestinationState<PushView>
    var pop: DestinationState<PopView>
}

enum MainRoutingAction {
    case navigateToMain(Store<Main.State, Main.Action>)
    case testPush
    case testPop
    case cancelPush
    case cancelPop
}

//func mainNavigator(destination: inout MainDestination, action: MainRoutingAction) -> Void {
//    switch action {
//    case .testPush:
//        print("go to push")
//        destination.push.set(
//            view: PushView()
//        )
//    case .testPop:
//        print("go to pop")
//        destination.pop.set(
//            view: PopView()
//        )
//    case .cancelPush:
//        destination.push.set(view: nil)
//    case .cancelPop:
//        destination.pop.set(view: nil)
//    default: return
//    }
//
//}


typealias Navigation<State, Action> = (inout State, Action) -> Void
final class Router<Destination, Action>: ObservableObject {

    // Read-only access to app state
    @Published private(set) var state: Destination

    private let navigation: Navigation<Destination, Action>

    init(initialState: Destination, navigation: @escaping Navigation<Destination, Action>) {
        self.state = initialState
        self.navigation = navigation
    }

    // The dispatch function.
    func dispatch(_ action: Action) {
        navigation(&state, action)
    }
    
    func binding<LocalState>(
        get: @escaping (Destination) -> LocalState,
        send localStateToViewAction: @escaping (LocalState) -> Action
    ) -> Binding<LocalState> {
        Binding(
            get: { get(self.state) },
            set: { newLocalState, transaction in
                withAnimation(transaction.disablesAnimations ? nil : transaction.animation) {
                    self.dispatch(localStateToViewAction(newLocalState))
                }
            })
    }
}

enum RouterTest {
    struct Destination: Equatable {
        var main: DestinationState<MainView>
        var push: DestinationState<PushView>
        var pop: DestinationState<PopView>
        var popPush: DestinationState<PopPushView>
    }
    
    enum RoutingAction {
        case navigateToMain(Store<Main.State, Main.Action>, RouterType)
        case popUpMain
        case navigateToPush
        case popUpPush
        case navigateToPop
        case popUpPop
        case navigateToPopPush
        case popUpPopPush
    }
    
    static let reducer = Reducer<Destination, RoutingAction, Void> { destination, action, _ in
        switch action {
        case .navigateToMain(let store, let router):
            print("navigate to main")
            destination.main.set(view: MainView(store: store, router: router))
        case .popUpMain:
            print("Pop up main")
            destination.main.set(view: nil)
        case .navigateToPush:
            print("navigate to push")
            destination.push.set(view: PushView())
        case .popUpPush:
            print("Pop up push")
            destination.push.set(view: nil)
        case .navigateToPop:
            print("navigate to pop")
            destination.pop.set(view: PopView(router: PopRouter.router))
        case .popUpPop:
            print("Pop up pop")
            destination.pop.set(view: nil)
        case .navigateToPopPush:
            print("navigate to pop push")
//            destination.popPush.set(view: PopPushView(router: RouterTest.store))
        case .popUpPopPush:
            print("Pop up pop push")
            destination.popPush.set(view: nil)
        }
        return .none
    }

    static let inital = Destination(
        main: .init(path: "main"),
        push: .init(path: "push"),
        pop: .init(path: "pop"),
        popPush: .init(path: "popPush")
    )
    
    static let store = Store<Destination, RoutingAction>(
        initialState: inital,
        reducer: reducer,
        environment: ()
    )
}

typealias RouterType = Store<RouterTest.Destination, RouterTest.RoutingAction>

enum PopRouter {
    struct Destination: Equatable {
        var popPush: DestinationState<PopPushView>
    }
    
    enum RoutingAction {
        case navigateToPopPush
        case popUpPopPush
    }
    
    static let reducer = Reducer<Destination, RoutingAction, Void> { destination, action, _ in
        switch action {
        case .navigateToPopPush:
            print("navigate to pop push")
//            destination.popPush.set(view: PopPushView(router: RouterTest.store))
        case .popUpPopPush:
            print("Pop up pop push")
            destination.popPush.set(view: nil)
        }
        return .none
    }
    
    static let initial = Destination(popPush: .init(path: "popPush"))
    
    static let router = Store<Destination, RoutingAction>(
        initialState: initial,
        reducer: reducer,
        environment: ()
    )
}
