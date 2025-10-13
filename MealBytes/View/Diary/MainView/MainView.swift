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
            .navigationTitle(mainViewModel.navigationTitle)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                mainViewToolbar
            }
            .task {
                await mainViewModel.loadMainData()
            }
    }
    
    private var mainViewContentBody: some View {
        Form {
            caloriesSection
            mealSections
            detailedInformationSection
        }
        .scrollIndicators(.hidden)
        .listSectionSpacing(16)
        .overlay(alignment: .top) {
            if mainViewModel.isExpandedCalendar {
                CalendarButtonView {
                    mainViewModel.isExpandedCalendar = false
                }
            }
        }
        .overlay(alignment: .top) {
            if mainViewModel.isExpandedCalendar {
                CalendarView(mainViewModel: mainViewModel)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .transition(.blurReplace)
            }
        }
        .animation(
            .bouncy(duration: 0.4),
            value: mainViewModel.isExpandedCalendar
        )
        .navigationDestination(
            item: $mainViewModel.selectedMealType
        ) { mealType in
            if let searchViewModel = mainViewModel
                .searchViewModel as? SearchViewModel {
                SearchView(
                    searchViewModel: searchViewModel,
                    mealType: mealType
                )
            }
        }
        .navigationDestination(
            item: $mainViewModel.selectedMealItem
        ) { item in
            FoodView(
                food: Food(
                    searchFoodId: item.foodId,
                    searchFoodName: item.foodName,
                    searchFoodDescription: ""
                ),
                searchViewModel: mainViewModel.searchViewModel,
                mainViewModel: mainViewModel,
                mealType: item.mealType,
                amount: String(item.amount),
                measurementDescription: item.measurementDescription,
                showAddButton: false,
                showSaveRemoveButton: true,
                originalCreatedAt: item.createdAt,
                originalMealItemId: item.id
            )
        }
    }
    
    private var caloriesSection: some View {
        CaloriesSection(
            summaries: mainViewModel.summariesForCaloriesSection(),
            mainViewModel: mainViewModel
        )
    }
    
    private var mealSections: some View {
        ForEach(MealType.allCases, id: \.self) { mealType in
            let filteredItems = mainViewModel.filteredMealItems(
                for: mealType,
                on: mainViewModel.date
            )
            
            MealSectionView(
                mealType: mealType,
                mealItems: filteredItems,
                mainViewModel: mainViewModel
            )
        }
    }
    
    private var detailedInformationSection: some View {
        NutrientValueSection(
            nutrients: mainViewModel.filteredNutrientValues,
            isExpandable: $mainViewModel.isExpanded
        )
        .animation(nil, value: UUID())
    }
    
    @ToolbarContentBuilder
    private var mainViewToolbar: some ToolbarContent {
        if mainViewModel.isExpandedCalendar {
            ToolbarItemGroup {
                Button {
                    mainViewModel.changeMonth(
                        by: -1,
                        selectedDate: &mainViewModel.date
                    )
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    mainViewModel.changeMonth(
                        by: 1,
                        selectedDate: &mainViewModel.date
                    )
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation {
                        mainViewModel.selectDate(
                            Date(),
                            selectedDate: &mainViewModel.date,
                            isPresented: &mainViewModel.isExpandedCalendar
                        )
                    }
                } label: {
                    Text("Today")
                        .font(.headline)
                }
            }
        }
        
        ToolbarSpacer(.fixed)
        
        ToolbarItemGroup(placement: .topBarTrailing) {
            if mainViewModel.isExpandedCalendar {
                Button(role: .cancel) {
                    withAnimation {
                        mainViewModel.isExpandedCalendar = false
                    }
                }
            } else {
                Button {
                    withAnimation {
                        mainViewModel.isExpandedCalendar = true
                    }
                } label: {
                    Image(systemName: "calendar")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
