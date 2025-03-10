//
//  String+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 10/03/2025.
//

import SwiftUI

extension String {
    func formatted(with format: String) -> String {
        String(format: format, Double(self) ?? 0)
    }
}
