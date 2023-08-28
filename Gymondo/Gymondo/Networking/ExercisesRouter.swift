//
//  ExercisesRouter.swift
//  Gymondo
//
//  Created by Ali Elsokary on 24/08/2023.
//

import Foundation

struct ExercisesRouter {

    struct GetExercises: EndpointRouter {
        typealias ReturnType = Exercises
        var path: String = "/exerciseinfo"
        var method: HTTPMethod = .get
    }

    struct GetExerciseinfo: EndpointRouter {
        typealias ReturnType = ExerciseItem
        let variation: Int

        var path: String {
            return "/exerciseinfo/\(variation)"
        }
        var method: HTTPMethod = .get
    }
}
