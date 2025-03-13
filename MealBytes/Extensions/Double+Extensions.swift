//
//  String+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 10/03/2025.
//

import SwiftUI

extension Double {
    func formattedDouble(with format: String) -> String {
        String(format: format, self)
    }
}
