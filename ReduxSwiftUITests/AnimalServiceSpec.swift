//
//  AnimalServiceSpec.swift
//  ReduxSwiftUITests
//
//  Created by Calvin Chang on 2020/11/1.
//

import Quick
import Nimble
import Combine

@testable import ReduxSwiftUI

class AnimalServiceSpec: QuickSpec {
    override func spec() {
        var service: AnimalService!
        var randomValueGenerator: RandomValueGeneratorMock!
        var cancellables: Set<AnyCancellable>!
        
        beforeEach {
            cancellables = Set()
            let animals = ["Dog"]
            randomValueGenerator = RandomValueGeneratorMock()
            service = AnimalService(
                animals: animals,
                randomValueGenerator: randomValueGenerator
            )
        }
        
        describe("Generate the animal") {
            context("If value is not 2") {
                it("should generate successfully") {
                    randomValueGenerator.nextIntValueClosure = { _ in 1 }
                    randomValueGenerator.nextDoubleValueClosure = { _ in 0 }
                    var animal: String?
                    
                    service.generateAnimal()
                        .sink(
                            receiveCompletion: { _ in },
                            receiveValue: { animal = $0 }
                        )
                        .store(in: &cancellables)
                    
                    expect(animal).toEventually(equal("Dog"))
                }
            }
            
            context("If value is 2") {
                it("Should return error") {
                    randomValueGenerator.nextIntValueClosure = { _ in 2 }
                    randomValueGenerator.nextDoubleValueClosure = { _ in 0 }
                    var error: Bool = false
                    
                    service.generateAnimal()
                        .sink(
                            receiveCompletion: { if $0 != .finished { error = true } },
                            receiveValue: { _ in }
                        )
                        .store(in: &cancellables)
                    
                    expect(error).toEventually(beTrue())
                }
            }
        }
    }
}
