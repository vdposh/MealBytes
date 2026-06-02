//
//  MainView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI
import FirebaseCore

struct MainView: View {
    @State private var selectedMealItemForMove: MealItem?
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        mainViewContentBody
            .navigationTitle("Diary")
            .navigationSubtitle(mainViewModel.formattedDate())
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(
                Color(.systemGroupedBackground).opacity(0.9),
                for: .navigationBar
            )
            .safeAreaInset(edge: .top) {
                dateSection
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .background {
                        Color(.systemGroupedBackground).opacity(0.9)
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .white,
                                        .white,
                                        .white,
                                        .clear
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
            }
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
        .padding(.top, -40)
        .environment(\.defaultMinListRowHeight, 0)
        .scrollIndicators(.hidden)
        .listSectionSpacing(20)
        .sheet(item: $selectedMealItemForMove) { item in
            MoveMealSheet(mealItem: item, mainViewModel: mainViewModel)
        }
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
    }
    
    private var dateSection: some View {
        DateSection(mainViewModel: mainViewModel)
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
                selectedMealItemForMove: $selectedMealItemForMove,
                mealType: mealType,
                mealItems: filteredItems,
                mainViewModel: mainViewModel
            )
        }
    }
    
    private var detailedInformationSection: some View {
        if mainViewModel.hasMealItems {
            NutrientValueSection(
                nutrients: mainViewModel.filteredNutrientValues,
                isExpandable: $mainViewModel.isExpanded,
                macroDistribution: mainViewModel
                    .macroDistribution(from: mainViewModel.nutrientSummaries),
                intake: mainViewModel
                    .canDisplayIntake() ? mainViewModel.currentIntake : nil,
                intakePercentage: mainViewModel.canDisplayIntake()
                ? mainViewModel.totalIntakePercentage()
                : nil
            )
        } else {
            NutrientValueSection(
                nutrients: NutrientValueProvider().placeholderMacros(),
                isExpandable: nil,
                emptyMealItems: true
            )
        }
    }
    
    @ToolbarContentBuilder
    private var mainViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                mainViewModel.showDatePicker.toggle()
            } label: {
                Image(systemName: "calendar")
            }
            .popover(isPresented: $mainViewModel.showDatePicker) {
                DatePickerView(date: $mainViewModel.date)
            }
        }
        
        if !mainViewModel.isTodaySelected {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    mainViewModel.date = Date()
                } label: {
                    Text("Today")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
