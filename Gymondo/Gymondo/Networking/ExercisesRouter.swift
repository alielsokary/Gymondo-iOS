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
        var path: String = "/exercise"
        var method: HTTPMethod = .get
    }
}
