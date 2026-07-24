//
//  NutrientTotalsSheet.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24.07.2026.
//

import SwiftUI

struct NutrientTotalsSheet: View {
    @Binding var isPresented: Bool
    let nutrients: [NutrientValue]
    
    var body: some View {
        NavigationStack {
            Form {
                NutrientValueSection(nutrients: nutrients)
            }
            .navigationTitle("Nutrient Totals")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        isPresented = false
                    }
                }
            }
            .environment(\.defaultMinListRowHeight, 42)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
