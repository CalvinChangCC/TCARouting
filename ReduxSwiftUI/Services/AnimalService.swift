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

class AnimalService {
    
    func generateAnimal() -> AnyPublisher<String, AnimalServiceError> {
        let animals = ["Cat", "Dog", "Crow", "Horse", "Iguana", "Cow", "Racoon"]
        let delay = Double.random(in: 0..<5)
        
        return Future<String, AnimalServiceError> { result in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                let randomErrorCode = Int.random(in: 0..<2)
                if(randomErrorCode != 0) {
                    result(.success( animals.randomElement() ?? ""))
                } else if let randomError = AnimalServiceError.allCases.randomElement() {
                    result(.failure(randomError))
                }            }
        }.eraseToAnyPublisher()
    }
}
