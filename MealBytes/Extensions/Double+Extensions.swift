//
//  String+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10/03/2025.
//

import SwiftUI

extension Double {
    func asCalories(grouping: Bool = true) -> String {
        var format = FloatingPointFormatStyle<Double>()
            .precision(.fractionLength(0))
        
        if !grouping {
            format = format.grouping(.never)
        }
        
        return self.formatted(format)
    }
    
    func asNutrient(unit: String? = nil, grouping: Bool = true) -> String {
        var format = FloatingPointFormatStyle<Double>()
            .precision(.fractionLength(0...2))
        
        if !grouping {
            format = format.grouping(.never)
        }
        
        let formattedNumber = self.formatted(format)
        
        if let unit {
            return "\(formattedNumber) \(unit)"
        } else {
            return formattedNumber
        }
    }
    
    func asPercentage(fractionDigits: Int = 0) -> String {
        self.formatted(.percent.precision(.fractionLength(fractionDigits)))
    }
}

#Preview {
    PreviewContentView.contentView
}
