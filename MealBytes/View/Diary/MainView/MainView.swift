//
//  MainView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI
import FirebaseCore

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        mainViewContentBody
            .navigationTitle("Diary")
            .navigationSubtitle(mainViewModel.date.formattedWeekdayDate())
            .toolbarTitleDisplayMode(.inlineLarge)
            .safeAreaPadding(.top)
            .toolbar {
                mainViewToolbar
            }
            .alert(
                isPresented: $mainViewModel.showClearDayAlert,
                content: {
                    mainViewModel.clearDayAlert(for: mainViewModel.date)
                }
            )
            .onChange(of: mainViewModel.date) {
                mainViewModel.scrollToTop()
            }
            .task {
                await mainViewModel.loadMainData()
            }
    }
    
    private var mainViewContentBody: some View {
        Form {
            goalsSection
            mealSection
            nutrientTotalsButtonView
        }
        .sheet(isPresented: $mainViewModel.showGoals) {
            NavigationStack {
                GoalsView(goalsViewModel: mainViewModel.goalsViewModel)
            }
        }
        .sheet(item: $mainViewModel.selectedMealType) { _ in
            if let searchViewModel = mainViewModel
                .searchViewModel as? SearchViewModel {
                NavigationStack {
                    SearchView(searchViewModel: searchViewModel)
                }
            }
        }
        .sheet(item: $mainViewModel.selectedFoodItem) { mealItem in
            NavigationStack {
                FoodView(
                    mealType: mealItem.mealType,
                    food: Food(
                        searchFoodId: mealItem.foodId,
                        searchFoodName: mealItem.foodName,
                        searchFoodDescription: ""
                    ),
                    searchViewModel: mainViewModel.searchViewModel,
                    mainViewModel: mainViewModel,
                    amount: mealItem.amount.asDecimal(grouping: false),
                    measurementDescription: mealItem.measurementDescription,
                    isEditingMealItem: true,
                    originalCreatedAt: mealItem.createdAt,
                    originalMealItemId: mealItem.id,
                    originalDate: mealItem.date
                )
            }
        }
        .sheet(isPresented: $mainViewModel.showItemDatePicker) {
            DatePickerSheet(
                selectedDate: $mainViewModel.itemMoveDate,
                isPresented: $mainViewModel.showItemDatePicker,
                onConfirm: {
                    if let item = mainViewModel.itemToMove {
                        mainViewModel
                            .moveMealItem(
                                item,
                                date: mainViewModel.itemMoveDate
                            )
                    }
                }
            )
        }
        .sheet(isPresented: $mainViewModel.showNutrientTotals) {
            NutrientTotalsSheet(
                nutrients: mainViewModel.filteredNutrientValues,
                hasMealItems: mainViewModel.hasMealItems
            )
        }
    }
    
    @ViewBuilder
    private var goalsSection: some View {
        if mainViewModel.displayGoals {
            GoalsSection(mainViewModel: mainViewModel)
        }
    }
    
    private var mealSection: some View {
        ForEach(MealType.allCases, id: \.self) { mealType in
            MealSectionView(
                mainViewModel: mainViewModel,
                mealType: mealType
            )
        }
    }
    
    private var nutrientTotalsButtonView: some View {
        Section {
            Button {
                mainViewModel.showNutrientTotals = true
            } label: {
                Text("Nutrient Totals")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .overlay(alignment: .leading) {
                        Image(systemName: "text.rectangle.page")
                            .imageScale(.large)
                            .fontWeight(.semibold)
                        
                    }
            }
            .padding(.vertical)
            .padding(.horizontal, UIScreen.horizontalPadding(focused: true))
            .glassEffect(.regular.interactive())
        }
        .listRowInsets(.vertical, 0)
        .listSectionMargins(.horizontal, 0)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    @ToolbarContentBuilder
    private var mainViewToolbar: some ToolbarContent {
        if !mainViewModel.isTodaySelected {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    mainViewModel.setDate(Date())
                } label: {
                    Text("Today")
                        .fontWeight(.medium)
                }
            }
        }
        
        ToolbarSpacer(.fixed, placement: .topBarTrailing)
        
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                mainViewModel.showDatePicker.toggle()
            } label: {
                Image(systemName: "calendar")
            }
            .popover(isPresented: $mainViewModel.showDatePicker) {
                DatePickerView(mainViewModel: mainViewModel)
            }
        }
        
        if mainViewModel.hasMealItems {
            ToolbarOverflowMenu {
                Button {
                    
                } label: {
                    Label("Select", systemImage: "checkmark.circle")
                }
                
                Divider()
                
                Button(role: .destructive) {
                    mainViewModel.showClearDayAlert = true
                } label: {
                    Label("Clear Day", systemImage: "trash")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
