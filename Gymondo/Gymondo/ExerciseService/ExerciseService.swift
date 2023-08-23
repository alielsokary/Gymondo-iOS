//
//  ExerciseService.swift
//  Gymondo
//
//  Created by Ali Elsokary on 23/08/2023.
//

import Foundation
import Combine

protocol ExerciseService {
    func dispatch<R: EndpointRouter>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError>
    var apiClient: APIClient { get }
}

struct ExerciseServiceImpl: ExerciseService {

    var apiClient: APIClient = APIClient()

    func dispatch<R: EndpointRouter>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: APIConstants.basedURL) else {
            return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
        }
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>
        let requestPublisher: RequestPublisher = apiClient.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }
}
