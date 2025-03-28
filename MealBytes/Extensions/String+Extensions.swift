//
//  String+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

extension String {
    var sanitizedForDouble: String {
        self.replacingOccurrences(of: ",", with: ".")
    }
}
