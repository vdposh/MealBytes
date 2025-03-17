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
    @Environment(\.dismiss) private var dismiss
    let mealType: MealType
    let isFromSearchView: Bool
    let isFromFoodItemRow: Bool
    
    init(food: Food,
         searchViewModel: SearchViewModel,
         mainViewModel: MainViewModel,
         mealType: MealType,
         isFromSearchView: Bool,
         isFromFoodItemRow: Bool,
         amount: String,
         measurementDescription: String) {
        self.mealType = mealType
        self.isFromSearchView = isFromSearchView
        self.isFromFoodItemRow = isFromFoodItemRow
        _foodViewModel = StateObject(wrappedValue: FoodViewModel(
            food: food,
            searchViewModel: searchViewModel,
            mainViewModel: mainViewModel,
            initialAmount: amount,
            initialMeasurementDescription: measurementDescription,
            isFromFoodItemRow: isFromFoodItemRow
        ))
    }
    
    var body: some View {
        ZStack {
            List {
                if !foodViewModel.isLoading {
                    servingSizeSection
                    nutrientActionSection
                    nutrientDetailSection
                }
            }
            .listSectionSpacing(10)
            .scrollDismissesKeyboard(.never)
            
            if foodViewModel.isLoading {
                LoadingView()
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
                    .foregroundColor(.gray)
                Spacer()
                Button("Done") {
                    isTextFieldFocused = false
                }
                .foregroundStyle(.customGreen)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundStyle(.customGreen)
            }
        }
        .task {
            await foodViewModel.fetchFoodDetails()
        }
        .alert(item: $foodViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.errorDescription),
                dismissButton: .default(Text("OK"))
            )
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
                .disabled(foodViewModel.isError)
                ServingButtonView(
                    title: "Serving",
                    description: foodViewModel.servingDescription,
                    showActionSheet: $foodViewModel.showActionSheet
                ) {
                    foodViewModel.showActionSheet.toggle()
                }
                .disabled(foodViewModel.isError)
            }
            .padding(.bottom, 10)
        }
    }
    
    private var nutrientActionSection: some View {
        Section {
            VStack {
                HStack {
                    ForEach(foodViewModel.compactNutrientDetails) { nutrient in
                        CompactNutrientDetailRow(nutrient: nutrient)
                    }
                }
                .padding(.vertical, 10)
                
                HStack {
                    switch isFromSearchView {
                    case true:
                        ActionButtonView(
                            title: "Add",
                            action: {
                                foodViewModel.addFoodItem(in: mealType)
                            },
                            backgroundColor: .customGreen,
                            isEnabled: foodViewModel.canAddFood
                        )
                    case false:
                        ActionButtonView(
                            title: "Remove",
                            action: {
                                // Remove from Diary
                            },
                            backgroundColor: .customRed,
                            isEnabled: true
                        )
                        
                        ActionButtonView(
                            title: "Save",
                            action: {
                                // Save
                            },
                            backgroundColor: .customGreen,
                            isEnabled: true
                        )
                    }
                    
                    BookmarkButtonView(
                        action: {
                            foodViewModel.toggleBookmark()
                        },
                        isFilled: foodViewModel.isBookmarkFilled,
                        isEnabled: !foodViewModel.isError
                    )
                }
                .padding(.bottom, 10)
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
    FoodView(
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
        isFromSearchView: true,
        isFromFoodItemRow: true,
        amount: "",
        measurementDescription: ""
    )
}
