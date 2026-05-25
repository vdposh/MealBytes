//
//  MealTypeText.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06.05.2026.
//

import SwiftUI

struct MealTypeText: View {
    @Environment(\.colorScheme) var colorScheme
    
    let mealType: MealType
    var title: String?
    var isHeader: Bool = false
    
    var body: some View {
        Text(title ?? mealType.rawValue)
            .fontWeight(isHeader ? .medium : nil)
            .foregroundStyle(Color.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
