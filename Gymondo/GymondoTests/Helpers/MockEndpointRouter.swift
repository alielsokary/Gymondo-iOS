//
//  MockEndpointRouter.swift
//  GymondoTests
//
//  Created by Ali Elsokary on 23/08/2023.
//

import Foundation
@testable import Gymondo

struct MockEndpointRouter: EndpointRouter {
    typealias ReturnType = Exercises

    var path: String { return "/mockPath" }
}
