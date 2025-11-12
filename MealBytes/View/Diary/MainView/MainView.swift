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
            .navigationSubtitle(mainViewModel.navigationSubtitle)
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
        .environment(\.defaultMinListRowHeight, 0)
        .scrollIndicators(.hidden)
        .listSectionSpacing(15)
        .overlay(alignment: .top) {
            if mainViewModel.isExpandedCalendar {
                CalendarButtonView {
                    mainViewModel.isCalendarInteractive = false
                    
                    withAnimation {
                        mainViewModel.isExpandedCalendar = false
                        mainViewModel.isCalendarInteractive = true
                    }
                }
            }
        }
        .overlay(alignment: .top) {
            if mainViewModel.isExpandedCalendar {
                CalendarView(mainViewModel: mainViewModel)
                    .allowsHitTesting(mainViewModel.isCalendarInteractive)
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
        if mainViewModel.hasMealItems {
            NutrientValueSection(
                nutrients: mainViewModel.filteredNutrientValues,
                isExpandable: $mainViewModel.isExpanded,
                macroDistribution: mainViewModel
                    .macroDistribution(from: mainViewModel.nutrientSummaries),
                intake: mainViewModel
                    .canDisplayIntake() ? mainViewModel.intake : nil,
                intakePercentage: mainViewModel.canDisplayIntake()
                ? mainViewModel
                    .intakePercentage(
                        for: mainViewModel.nutrientSummaries[.calories]
                    )
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
        if mainViewModel.isExpandedCalendar {
            ToolbarItemGroup {
                Button {
                    withTransaction(
                        Transaction(animation: .bouncy)
                    ) {
                        mainViewModel.changeMonth(
                            by: -1,
                            selectedDate: &mainViewModel.date
                        )
                    }
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Button {
                    withTransaction(
                        Transaction(animation: .bouncy)
                    ) {
                        mainViewModel.changeMonth(
                            by: 1,
                            selectedDate: &mainViewModel.date
                        )
                    }
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button("Today") {
                    withAnimation {
                        mainViewModel.isCalendarInteractive = false
                    }
                    
                    withTransaction(
                        Transaction(animation: .bouncy)
                    ) {
                        mainViewModel.selectDate(
                            Date(),
                            selectedDate: &mainViewModel.date,
                            isPresented: &mainViewModel.isExpandedCalendar
                        )
                    }
                    
                    withAnimation {
                        mainViewModel.isCalendarInteractive = true
                    }
                }
                .font(.headline)
            }
        }
        
        ToolbarSpacer(.fixed)
        
        ToolbarItemGroup(placement: .topBarTrailing) {
            if mainViewModel.isExpandedCalendar {
                Button(role: .cancel) {
                    mainViewModel.isCalendarInteractive = false
                    
                    withAnimation {
                        mainViewModel.isExpandedCalendar = false
                        mainViewModel.isCalendarInteractive = true
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
