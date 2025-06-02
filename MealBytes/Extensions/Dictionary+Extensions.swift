//
//  Dictionary+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/03/2025.
//

import SwiftUI

extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        var result: [T: Value] = [:]
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }
}
