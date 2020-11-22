//
//  Main.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import Foundation
import ComposableArchitecture

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
