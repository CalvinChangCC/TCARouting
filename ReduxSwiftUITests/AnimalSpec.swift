//
//  AnimalSpec.swift
//  ReduxSwiftUITests
//
//  Created by Calvin Chang on 11.12.20.
//

import Quick
import Nimble
import ComposableArchitecture
import Combine

@testable import ReduxSwiftUI

final class AnimalSpec: QuickSpec {
    
    override func spec() {
        var animalService: AnimalServiceMock!
        var store: TestStore<Animal.State, Animal.State, Animal.Action, Animal.Action, Animal.Environment>!
        
        beforeEach {
            animalService = AnimalServiceMock()
            store = TestStore(
                initialState: Animal.State(
                    current: "",
                    error: nil,
                    inProgress: false,
                    main: .init(animalName: "")
                ),
                reducer: Animal.reducer,
                environment: Animal.Environment(animalService: animalService))
        }
        
        describe("When user start generate") {
            it("should generate successfully") {
                animalService.animal = "Man"
                
                store.assert(
                    .send(.fetch) {
                        $0.inProgress = true
                    },
                    .receive(.complete("Man")) {
                        $0.current = "Man"
                        $0.inProgress = false
                    }
                )
            }
        }
    }
}
