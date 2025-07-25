//
//  FoodView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct FoodView: View {
    @FocusState private var amountFocused: Bool
    @Environment(\.dismiss) private var dismiss
    
    private let navigationTitle: String
    private let showAddButton: Bool
    private let showSaveRemoveButton: Bool
    private let showMealTypeButton: Bool
    
    @StateObject private var foodViewModel: FoodViewModel
    
    init(navigationTitle: String,
         food: Food,
         searchViewModel: SearchViewModel,
         mainViewModel: MainViewModel,
         mealType: MealType,
         amount: String,
         measurementDescription: String,
         showAddButton: Bool,
         showSaveRemoveButton: Bool,
         showMealTypeButton: Bool,
         originalCreatedAt: Date = Date(),
         originalMealItemId: UUID? = nil) {
        self.navigationTitle = navigationTitle
        self.showAddButton = showAddButton
        self.showSaveRemoveButton = showSaveRemoveButton
        self.showMealTypeButton = showMealTypeButton
        _foodViewModel = StateObject(wrappedValue: FoodViewModel(
            food: food,
            mealType: mealType,
            searchViewModel: searchViewModel,
            mainViewModel: mainViewModel,
            initialAmount: amount,
            initialMeasurementDescription: measurementDescription,
            showSaveRemoveButton: showSaveRemoveButton,
            originalCreatedAt: originalCreatedAt,
            originalMealItemId: originalMealItemId
        ))
    }
    
    var body: some View {
        ZStack {
            if let error = foodViewModel.appError {
                contentUnavailableView(
                    for: error,
                    mealType: foodViewModel.mealType
                ) {
                    Task {
                        foodViewModel.appError = nil
                        await foodViewModel.fetchFoodDetails()
                    }
                }
            } else {
                if foodViewModel.isLoading {
                    LoadingView()
                } else {
                    List {
                        servingSizeSection
                        nutrientActionSection
                        nutrientDetailSection
                    }
                    .listSectionSpacing(15)
                }
            }
        }
        .navigationBarTitle(navigationTitle, displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                DoneButtonView {
                    amountFocused = false
                }
            }
            
            if showAddButton {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.body)
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
                ServingTextFieldView(
                    text: $foodViewModel.amount,
                    title: "Size",
                    placeholder: "Enter serving size"
                )
                .focused($amountFocused)
                .onChange(of: amountFocused) { oldValue, newValue in
                    foodViewModel.handleFocusChange(from: oldValue,
                                                    to: newValue)
                }
                
                ServingButtonView(
                    showActionSheet: $foodViewModel.showServingDialog,
                    title: "Serving",
                    description: foodViewModel.servingDescription
                ) {
                    foodViewModel.showServingDialog.toggle()
                    amountFocused = false
                }
                .confirmationDialog(
                    "Select a Serving",
                    isPresented: $foodViewModel.showServingDialog,
                    titleVisibility: .visible
                ) {
                    if let servings = foodViewModel
                        .foodDetail?.servings.serving {
                        ForEach(servings, id: \.self) { serving in
                            Button(foodViewModel.servingDescription(
                                for: serving)) {
                                    foodViewModel.updateServing(serving)
                                }
                        }
                    }
                }
                
                if showMealTypeButton {
                    ServingButtonView(
                        showActionSheet: $foodViewModel.showMealTypeDialog,
                        title: "Meal Type",
                        description: foodViewModel.mealType.rawValue
                    ) {
                        foodViewModel.showMealTypeDialog.toggle()
                        amountFocused = false
                    }
                    .confirmationDialog(
                        "Select a Meal Type",
                        isPresented: $foodViewModel.showMealTypeDialog,
                        titleVisibility: .visible
                    ) {
                        ForEach(MealType.allCases, id: \.self) { meal in
                            Button(meal.rawValue) {
                                foodViewModel.mealType = meal
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 10)
        }
    }
    
    private var nutrientActionSection: some View {
        Section {
            VStack {
                HStack {
                    ForEach(foodViewModel.compactNutrientDetails,
                            id: \.id) { nutrient in
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
                                foodViewModel.addMealItemFoodView(
                                    in: foodViewModel.mealType,
                                    for: foodViewModel.mainViewModel.date
                                )
                                dismiss()
                            },
                            backgroundColor: .customGreen,
                            isEnabled: foodViewModel.canAddFood
                        )
                        
                        BookmarkButtonView(
                            action: {
                                foodViewModel.toggleBookmarkFoodView()
                            },
                            isFilled: foodViewModel.isBookmarkFilled,
                            width: 55,
                            height: 30
                        )
                    case false:
                        ActionButtonView(
                            title: "Remove",
                            action: {
                                Task {
                                    await foodViewModel.deleteMealItemFoodView()
                                    dismiss()
                                }
                            },
                            backgroundColor: .customRed
                        )
                        
                        ActionButtonView(
                            title: "Save",
                            action: {
                                Task {
                                    await foodViewModel.updateMealItemFoodView(
                                        for: foodViewModel.mainViewModel.date
                                    )
                                    dismiss()
                                }
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
}


#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel()
    )
    .environmentObject(ThemeManager())
}

#Preview {
    FoodView(
        navigationTitle: "Add to Diary",
        food: Food(
            searchFoodId: 3092,
            searchFoodName: "Egg",
            searchFoodDescription: "1 cup"
        ),
        searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
        mainViewModel: MainViewModel(),
        mealType: .breakfast,
        amount: "1",
        measurementDescription: "Grams",
        showAddButton: false,
        showSaveRemoveButton: true,
        showMealTypeButton: true,
        originalMealItemId: UUID()
    )
}
