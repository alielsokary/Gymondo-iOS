//
//  Optional+Extension.swift
//  Gymondo
//
//  Created by Ali Elsokary on 23/08/2023.
//

import Foundation

public protocol Defaultable {
    static var defaultValue: Self { get }
}

public extension Optional where Wrapped: Defaultable {
    var unwrapped: Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.defaultValue
        }
    }
}

extension Int: Defaultable {
    public static var defaultValue: Int { return 0 }
}

extension CGFloat: Defaultable {
    public static var defaultValue: CGFloat { return 0 }
}

extension String: Defaultable {
    public static var defaultValue: String { return "" }
}

extension Bool: Defaultable {
    public static var defaultValue: Bool { return false }
}

extension Array: Defaultable {
    public static var defaultValue: [Element] { return [] }
}
