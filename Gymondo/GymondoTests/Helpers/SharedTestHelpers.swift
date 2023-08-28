//
//  SharedTestHelpers.swift
//  GymondoTests
//
//  Created by Ali Elsokary on 28/08/2023.
//

import Foundation
import Gymondo

func makeItem(id: Int?, uuid: String?, name: String?, exerciseBase: Int?) -> ExerciseItem {
    return ExerciseItem(id: id, uuid: uuid, name: name, exerciseBase: exerciseBase, description: nil, images: nil, created: nil, variations: nil)
}
