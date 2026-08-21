//
//  NutrientTotalsSheet.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24.07.2026.
//

import SwiftUI

struct NutrientTotalsSheet: View {
    @Environment(\.dismiss) private var dismiss
    let nutrients: [NutrientValue]
    let hasMealItems: Bool
    
    var body: some View {
        NavigationStack {
            if hasMealItems {
                Form {
                    NutrientValueSection(nutrients: nutrients)
                }
                .environment(\.defaultMinListRowHeight, 42)
                .navigationTitle("Nutrient Totals")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        closeButton
                    }
                }
            } else {
                ContentUnavailableView {
                    Label {
                        Text("Nothing logged yet")
                    } icon: {
                        Image(systemName: "text.rectangle.page")
                    }
                } description: {
                    Text("Add some food to view nutrient totals.")
                }
                .navigationTitle("Nutrient Totals")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        closeButton
                    }
                }
                .background {
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    private var closeButton: some View {
        Button(role: .close) {
            dismiss()
        } label: {
            Text("Close")
                .fontWeight(.medium)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
