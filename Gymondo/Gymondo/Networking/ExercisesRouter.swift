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

    struct GetImages: EndpointRouter {
        typealias ReturnType = ExerciseImages
        var path: String = "/exerciseimage"
        var method: HTTPMethod = .get
        var queryParams: [String: Any]?
        init(queryParams: APIParameters.Exercise) {
            self.queryParams = queryParams.asDictionary
        }
    }
}
