//
//  FoodView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct FoodView: View {
    @StateObject private var foodViewModel: FoodViewModel
    @FocusState private var isTextFieldFocused: Bool
    @Binding private var isDismissed: Bool
    private let showAddButton: Bool
    private let showSaveRemoveButton: Bool
    private let showCloseButton: Bool
    @Environment(\.dismiss) private var dismiss
    
    init(isDismissed: Binding<Bool>,
         food: Food,
         searchViewModel: SearchViewModel,
         mainViewModel: MainViewModel,
         mealType: MealType,
         amount: String,
         measurementDescription: String,
         showAddButton: Bool,
         showSaveRemoveButton: Bool,
         showCloseButton: Bool,
         originalMealItemId: UUID? = nil) {
        self._isDismissed = isDismissed
        self.showAddButton = showAddButton
        self.showSaveRemoveButton = showSaveRemoveButton
        self.showCloseButton = showCloseButton
        _foodViewModel = StateObject(wrappedValue: FoodViewModel(
            food: food,
            mealType: mealType,
            searchViewModel: searchViewModel,
            mainViewModel: mainViewModel,
            initialAmount: amount,
            initialMeasurementDescription: measurementDescription,
            showSaveRemoveButton: showSaveRemoveButton,
            originalMealItemId: originalMealItemId
        ))
    }
    
    var body: some View {
        ZStack {
            if let error = foodViewModel.errorMessage {
                error.contentUnavailableView(query: "") {
                    Task {
                        foodViewModel.errorMessage = nil
                        await foodViewModel.fetchFoodDetails()
                    }
                }
            } else {
                List {
                    if !foodViewModel.isLoading {
                        servingSizeSection
                        nutrientActionSection
                        nutrientDetailSection
                    }
                }
                .listSectionSpacing(15)
                .scrollDismissesKeyboard(.never)
                
                if foodViewModel.isLoading {
                    LoadingView()
                }
            }
        }
        .navigationBarTitle("Add to Diary", displayMode: .inline)
        .confirmationDialog(
            "Select Serving",
            isPresented: $foodViewModel.showActionSheet,
            titleVisibility: .visible
        ) {
            if let servings = foodViewModel.foodDetail?.servings.serving {
                servingButtons(servings: servings)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Text("Enter serving size")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Done") {
                    isTextFieldFocused = false
                }
            }
            if showCloseButton {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        isDismissed = false
                    }
                }
            }
        }
        .task {
            await foodViewModel.fetchFoodDetails()
        }
    }
    
    private var servingSizeSection: some View {
        Section {
            Text(foodViewModel.food.searchFoodName)
                .font(.headline)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            VStack(spacing: 15) {
                ServingTextFieldView(title: "Size",
                                     text: $foodViewModel.amount)
                .focused($isTextFieldFocused)
                ServingButtonView(
                    title: "Serving",
                    description: foodViewModel.servingDescription,
                    showActionSheet: $foodViewModel.showActionSheet
                ) {
                    foodViewModel.showActionSheet.toggle()
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    private var nutrientActionSection: some View {
        Section {
            VStack {
                HStack {
                    ForEach(foodViewModel.compactNutrientDetails, id: \.id) {
                        nutrient in
                        CompactNutrientDetailRow(nutrient: nutrient)
                    }
                }
                .padding(.bottom, 10)
                
                HStack {
                    switch showAddButton {
                    case true:
                        ActionButtonView(
                            title: "Add",
                            action: {
                                foodViewModel.addFoodItem(
                                    in: foodViewModel.mealType,
                                    for: foodViewModel.mainViewModel.date
                                )
                                isDismissed = false
                            },
                            backgroundColor: .customGreen,
                            isEnabled: foodViewModel.canAddFood
                        )
                        
                        BookmarkButtonView(
                            action: {
                                foodViewModel.toggleBookmark()
                            },
                            isFilled: foodViewModel.isBookmarkFilled,
                            width: 55,
                            height: 30
                        )
                    case false:
                        ActionButtonView(
                            title: "Remove",
                            action: {
                                foodViewModel.deleteMealItem()
                                dismiss()
                            },
                            backgroundColor: .customRed
                        )
                        
                        ActionButtonView(
                            title: "Save",
                            action: {
                                foodViewModel.saveMealItem(
                                    for: foodViewModel.mainViewModel.date)
                                dismiss()
                            },
                            backgroundColor: .customGreen,
                            isEnabled: foodViewModel.canAddFood
                        )
                    }
                }
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
        }
    }
    
    private var nutrientDetailSection: some View {
        NutrientDetailSectionView(
            title: "Detailed Information",
            nutrientDetails: foodViewModel.nutrientDetails
        )
    }
    
    private func servingButtons(servings: [Serving]) -> some View {
        ForEach(servings, id: \.self) { serving in
            Button(foodViewModel.servingDescription(for: serving)) {
                foodViewModel.updateServing(serving)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FoodView(
            isDismissed: .constant(true),
            food: Food(
                searchFoodId: 794,
                searchFoodName: "Whole Milk",
                searchFoodDescription: ""
            ),
            searchViewModel: SearchViewModel(
                networkManager: NetworkManager()
            ),
            mainViewModel: MainViewModel(),
            mealType: .breakfast,
            amount: "1",
            measurementDescription: "",
            showAddButton: false,
            showSaveRemoveButton: true,
            showCloseButton: true
        )
    }
    .accentColor(.customGreen)
}
