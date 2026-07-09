//
//  MoveMealSheet.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/05/2025.
//

import SwiftUI

struct MoveMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var mainViewModel: MainViewModel
    
    let mealItem: MealItem
    
    var body: some View {
        NavigationStack {
            Form {
                mealTypeSection
                removeSection
            }
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.hidden)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                toolbarContent
            }
        }
    }
    
    private var mealTypeSection: some View {
        Section {
            ForEach(MealType.allCases, id: \.self) { mealType in
                Button {
                    if mealType != mealItem.mealType {
                        mainViewModel.moveMealItem(mealItem, to: mealType)
                        dismiss()
                    }
                } label: {
                    HStack {
                        MealTypeText(mealType: mealType)
                        
                        if mealType == mealItem.mealType {
                            Image(systemName: "checkmark")
                                .font(.headline)
                        }
                    }
                }
            }
        } header: {
            Text("Meal type")
        }
    }
    
    private var removeSection: some View {
        Section {
            ActionButtonView(
                title: "Remove",
                action: {
                    mainViewModel.deleteMealItemMainView(
                        with: mealItem.id,
                        for: mealItem.mealType
                    )
                    dismiss()
                },
                color: .customRed
            )
            .listRowInsets(EdgeInsets())
        } header: {
            Text("Remove from diary")
        }
        .listRowBackground(Color.clear)
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            VStack(alignment: .leading) {
                Text(mealItem.foodName)
                    .font(.headline)
                
                Text(mainViewModel.formattedMealText(for: mealItem))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .lineLimit(1)
            .padding(.leading)
            .frame(
                width: UIScreen.currentSize.width * 0.8,
                alignment: .leading
            )
        }
        
        ToolbarItem(placement: .primaryAction) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
