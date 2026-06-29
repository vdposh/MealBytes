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
            .toolbarTitleDisplayMode(.inlineLarge)
            .safeAreaPadding(.top, 8)
            .safeAreaBar(edge: .top) {
                dateSection
            }
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
            caloriesSection
            mealSections
            detailedInformationSection
        }
        .sheet(item: $selectedMealItemForMove) { item in
            MoveMealSheet(mainViewModel: mainViewModel, mealItem: item)
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
            MealSectionView(
                selectedMealItemForMove: $selectedMealItemForMove,
                mainViewModel: mainViewModel,
                mealType: mealType
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
        if !mainViewModel.isTodaySelected {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    withAnimation {
                        mainViewModel.date = Date()
                    }
                } label: {
                    Text("Today")
                        .fontWeight(.medium)
                }
            }
        }
        
        ToolbarSpacer(.fixed, placement: .primaryAction)
        
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                mainViewModel.showDatePicker.toggle()
            } label: {
                Image(systemName: "calendar")
            }
            .popover(isPresented: $mainViewModel.showDatePicker) {
                DatePickerView(mainViewModel: mainViewModel)
            }
            
            if mainViewModel.hasMealItems {
                Menu {
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
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
