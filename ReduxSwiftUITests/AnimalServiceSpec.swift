//
//  AnimalServiceSpec.swift
//  ReduxSwiftUITests
//
//  Created by Calvin Chang on 2020/11/1.
//

import Quick
import Nimble

@testable import ReduxSwiftUI

class AnimalServiceSpec: QuickSpec {
    override func spec() {
        var service: AnimalService?
        
        beforeEach {
            service = AnimalService()
        }
        
        describe("animal service test") {
            it("should generate error") {
                service?.generateAnimal()
            }
        }
    }
}
