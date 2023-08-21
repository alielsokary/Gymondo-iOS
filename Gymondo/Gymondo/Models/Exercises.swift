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
struct ExerciseItem: Codable {
    let id: Int?
    let uuid, name: String?
    let exerciseBase: Int?
    let description: String?
    let created: Date?
    let category: Int?
    let muscles, musclesSecondary, equipment: [Int]?
    let language, license: Int?
    let licenseAuthor: String?
    let variations: [Int]?
    let authorHistory: [String]?

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case exerciseBase = "exercise_base"
        case description, created, category, muscles
        case musclesSecondary = "muscles_secondary"
        case equipment, language, license
        case licenseAuthor = "license_author"
        case variations
        case authorHistory = "author_history"
    }
}
