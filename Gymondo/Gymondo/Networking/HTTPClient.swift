//
//  HTTPClient.swift
//  Gymondo
//
//  Created by Ali Elsokary on 22/08/2023.
//

import Foundation
import Combine

protocol HTTPClient {
    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError>
}
