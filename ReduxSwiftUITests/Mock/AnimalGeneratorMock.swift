//
//  AnimalGeneratorMock.swift
//  ReduxSwiftUITests
//
//  Created by Calvin Chang on 11.12.20.
//

import Foundation
import Combine

@testable import ReduxSwiftUI

final class AnimalServiceMock: AnimalServiceType {
    
    var animal: String?
    func generateAnimal() -> Future<String, AnimalServiceError> {
        Future { [weak self] promise in
            if let animal = self?.animal {
                promise(.success(animal))
            } else {
                promise(.failure(AnimalServiceError.unknown))
            }
        }
    }
}
