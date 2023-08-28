//
//  MockExerciseService.swift
//  GymondoTests
//
//  Created by Ali Elsokary on 28/08/2023.
//

import Foundation
import Combine
import Gymondo

class MockExerciseService: ExerciseService {
    var mockedResponse: AnyPublisher<Exercises, NetworkRequestError>?

    func dispatch<R: EndpointRouter>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        if let mockedResponse = mockedResponse {
            return mockedResponse
                .mapError { $0 as NetworkRequestError }
                .map { $0 as! R.ReturnType }
                .eraseToAnyPublisher()
        } else {
            fatalError("Mocked response is not properly configured.")
        }
    }
}
