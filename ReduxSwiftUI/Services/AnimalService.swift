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

class AnimalService: AnimalServiceType {
    func generateAnimal() -> Future<String, AnimalServiceError> {
        let animals = ["Cat", "Dog", "Crow", "Horse", "Iguana", "Cow", "Racoon"]
        let delay = Double.random(in: 0..<3)
        
        return Future<String, AnimalServiceError> { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let randomErrorCode = Int.random(in: 0..<2)
                if randomErrorCode != 2 {
                    result(.success(animals.randomElement() ?? ""))
                } else if let randomError = AnimalServiceError.allCases.randomElement() {
                    result(.failure(randomError))
                }
            }
        }
    }
}
