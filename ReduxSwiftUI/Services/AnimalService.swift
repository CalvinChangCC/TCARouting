//
//  AnimalService.swift
//  ReduxSwiftUI
//
//  Created by Calvin Chang on 2020/10/27.
//

import Foundation
import Combine

enum AnimalServiceError: Error, CaseIterable, Equatable {
    case unknown
    case networkError
}

protocol AnimalServiceType {
    func generateAnimal() -> Future<String, AnimalServiceError>
}

final class AnimalService: AnimalServiceType {
    let animals: [String]
    let randomValueGenerator: RandomValueGeneratorType

    init(animals: [String], randomValueGenerator: RandomValueGeneratorType) {
        self.animals = animals
        self.randomValueGenerator = randomValueGenerator
    }
    
    func generateAnimal() -> Future<String, AnimalServiceError> {
        let delay = self.randomValueGenerator.next(range: 0.0..<2)
        
        return Future<String, AnimalServiceError> { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let randomErrorCode = self.randomValueGenerator.next(range: 0..<2)
                if randomErrorCode != 2 {
                    result(.success(self.animals.randomElement() ?? ""))
                } else if let randomError = AnimalServiceError.allCases.randomElement() {
                    result(.failure(randomError))
                }
            }
        }
    }
}

protocol RandomValueGeneratorType {
    func next(range: Range<Int>) -> Int
    
    func next(range: Range<Double>) -> Double
}

final class RandomValueGenerator: RandomValueGeneratorType {
    func next(range: Range<Int>) -> Int {
        Int.random(in: range)
    }

    func next(range: Range<Double>) -> Double {
        Double.random(in: range)
    }
}
