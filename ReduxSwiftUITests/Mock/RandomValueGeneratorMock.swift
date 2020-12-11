//
//  RandomValueGeneratorMock.swift
//  ReduxSwiftUITests
//
//  Created by Calvin Chang on 11.12.20.
//

import Foundation

@testable import ReduxSwiftUI

final class RandomValueGeneratorMock: RandomValueGeneratorType {
    var nextIntValueClosure: ((Range<Int>) -> Int)?
    func next(range: Range<Int>) -> Int {
        nextIntValueClosure?(range) ?? 0
    }

    var nextDoubleValueClosure: ((Range<Double>) -> Double)?
    func next(range: Range<Double>) -> Double {
        nextDoubleValueClosure?(range) ?? 0
    }
}
