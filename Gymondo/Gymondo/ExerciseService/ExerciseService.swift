//
//  ExerciseService.swift
//  Gymondo
//
//  Created by Ali Elsokary on 23/08/2023.
//

import Foundation
import Combine

public protocol ExerciseService {
    func dispatch<R: EndpointRouter>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError>
}

public struct ExerciseServiceImpl: ExerciseService {

    private let apiClient: APIClient = APIClient()

    public init() {}

    @discardableResult
    public func dispatch<R: EndpointRouter>(_ request: R) -> AnyPublisher<R.ReturnType, NetworkRequestError> {
        guard let urlRequest = request.asURLRequest(baseURL: APIConstants.basedURL) else {
            return Fail(outputType: R.ReturnType.self, failure: NetworkRequestError.badRequest).eraseToAnyPublisher()
        }
        typealias RequestPublisher = AnyPublisher<R.ReturnType, NetworkRequestError>
        let requestPublisher: RequestPublisher = apiClient.dispatch(request: urlRequest)
        return requestPublisher.eraseToAnyPublisher()
    }
}
