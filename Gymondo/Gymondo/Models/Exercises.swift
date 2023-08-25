//
//  Exercises.swift
//  Gymondo
//
//  Created by Ali Elsokary on 22/08/2023.
//

import Foundation

// MARK: - Exercises
public struct Exercises: Codable {
    let results: [ExerciseItem]?
}

// MARK: - ExerciseItem
public struct ExerciseItem: Codable, Equatable {
    public let id: Int?
    public let uuid, name: String?
    public let exerciseBase: Int?
    public let description: String?
    public let created: String?
    public let category: Int?
    public let language: Int?
    public let variations: [Int]?

    public init(id: Int?, uuid: String?, name: String?, exerciseBase: Int?, description: String?, created: String?, category: Int?, language: Int?, variations: [Int]?) {
        self.id = id
        self.uuid = uuid
        self.name = name
        self.exerciseBase = exerciseBase
        self.description = description
        self.created = created
        self.category = category
        self.language = language
        self.variations = variations
    }

    enum CodingKeys: String, CodingKey {
        case id, uuid, name
        case exerciseBase = "exercise_base"
        case description, created, category
        case language
        case variations
    }
}
