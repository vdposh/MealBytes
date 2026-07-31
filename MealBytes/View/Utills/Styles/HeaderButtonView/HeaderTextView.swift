//
//  HeaderTextView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06.05.2026.
//

import SwiftUI

struct HeaderTextView: View {
    let mealType: MealType
    var title: String?
    
    var body: some View {
        Text(title ?? mealType.rawValue)
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundStyle(Color.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
