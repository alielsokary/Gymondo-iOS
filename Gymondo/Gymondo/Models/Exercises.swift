//
//  Exercises.swift
//  Gymondo
//
//  Created by Ali Elsokary on 22/08/2023.
//

import Foundation

// MARK: - Exercises
struct Exercises: Codable {
    let results: [ExerciseItem]?
}

// MARK: - ExerciseItem
struct ExerciseItem: Codable, Equatable {
    let id: Int?
    let uuid, name: String?
    let exerciseBase: Int?
    let description: String?
    let created: String?
    let category: Int?
    let language: Int?
    let variations: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case exerciseBase = "exercise_base"
        case description, created, category
        case language
        case variations
    }
}
