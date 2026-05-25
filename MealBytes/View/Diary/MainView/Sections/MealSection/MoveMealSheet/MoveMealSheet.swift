//
//  MoveMealSheet.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/05/2025.
//

import SwiftUI

struct MoveMealSheet: View {
    let mealItem: MealItem
    @ObservedObject var mainViewModel: MainViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    ForEach(MealType.allCases, id: \.self) { mealType in
                        Button {
                            if mealType != mealItem.mealType {
                                mainViewModel
                                    .moveMealItem(mealItem, to: mealType)
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
                    Text("Change meal type for this food")
                        .padding(.top)
                }
                
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
                    Text("Remove this food from diary")
                }
                .listRowBackground(Color.clear)
            }
            .presentationDetents([.fraction(0.6), .large])
            .presentationDragIndicator(.hidden)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.accent)
                            .symbolColorRenderingMode(.gradient)
                        
                        VStack(alignment: .leading) {
                            Text(mealItem.foodName)
                                .font(.headline)
                            
                            Text(
                                mainViewModel.formattedMealText(for: mealItem)
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                        .lineLimit(1)
                    }
                    .frame(width: screenSize.width * 0.8, alignment: .leading)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var screenSize: CGSize {
        (
            UIApplication.shared.connectedScenes.first as? UIWindowScene
        )?.screen.bounds.size ?? .zero
    }
}

#Preview {
    PreviewContentView.contentView
}
