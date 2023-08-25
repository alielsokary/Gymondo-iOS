//
//  APIParameters.swift
//  Gymondo
//
//  Created by Ali Elsokary on 25/08/2023.
//

import Foundation

protocol DictionaryConvertor: Codable {}

// MARK: APIParameters for using in URLrequests

struct APIParameters: DictionaryConvertor {

    struct Exercise: Encodable {
        var exercise_base: Int?
    }
}
