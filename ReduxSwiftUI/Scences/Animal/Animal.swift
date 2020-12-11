//
//  Animal.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/11/21.
//

import Foundation
import ComposableArchitecture

enum Animal {
    struct State: Equatable {
        var current: String = ""
        var error: AnimalServiceError?
        var inProgress: Bool = false
        var main: Main.State
    }

    enum Action: Equatable {
        case fetch
        case complete(String)
        case error(AnimalServiceError)
        case mainAction(Main.Action)
        case setName
    }

    struct Environment {
        let animalService: AnimalServiceType
    }

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .fetch:
            state.inProgress = true
            return environment.animalService
                .generateAnimal()
                .catchToEffect()
                .map {
                    switch $0 {
                    case .success(let name):
                        return .complete(name)
                    case .failure(let error):
                        return .error(error)
                    }
                }
                    
        case .complete(let name):
            state.inProgress = false
            state.current = name
            return .none
        case .error(let error):
            state.inProgress = false
            state.error = error
            return .none
        case .setName:
            state.main.animalName = state.current
            return .none
        }
    }.debug()
}
