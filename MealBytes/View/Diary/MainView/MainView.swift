//
//  MainView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI
import FirebaseCore

struct MainView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            if mainViewModel.isLoading {
                LoadingView()
            } else {
                ZStack(alignment: .top) {
                    if mainViewModel.isExpandedCalendar {
                        VStack {
                            datePickerView
                        }
                        .zIndex(2)
                        Color.primary
                            .opacity(0.4)
                            .ignoresSafeArea()
                            .zIndex(1)
                    }
                    
                    List {
                        dateSection
                        caloriesSection
                        mealSections
                        detailedInformationSection
                    }
                    .listSectionSpacing(15)
                }
            }
        }
        .task {
            await initializeMainView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !mainViewModel.isLoading {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        mainViewModel.isExpandedCalendar.toggle()
                    }) {
                        HStack(spacing: 4) {
                            Text(mainViewModel.formattedYearDisplay())
                                .fontWeight(.medium)
                            Image(systemName: {
                                switch mainViewModel.isExpandedCalendar {
                                case true:
                                    "chevron.up"
                                case false:
                                    "chevron.down"
                                }
                            }())
                            .font(.caption)
                            .fontWeight(.medium)
                        }
                    }
                    .foregroundStyle(.customGreen)
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private var datePickerView: some View {
        VStack {
            DatePickerView(selectedDate: $mainViewModel.date,
                           isPresented: $mainViewModel.isExpandedCalendar,
                           mainViewModel: mainViewModel)
        }
        .background(Color(.systemBackground))
    }
    
    private var dateSection: some View {
        Section {
            HStack {
                ForEach(-3...3, id: \.self) { offset in
                    Button(action: {
                        mainViewModel.date = mainViewModel
                            .dateByAddingOffset(for: offset)
                    }) {
                        dateView(for: mainViewModel
                            .dateByAddingOffset(for: offset))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
    }
    
    private func dateView(for date: Date) -> some View {
        DateView(
            date: date,
            isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
            isSelected: Calendar.current.isDate(
                date,
                inSameDayAs: mainViewModel.date
            ),
            mainViewModel: mainViewModel
        )
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
        DetailedInformationSection(
            isExpanded: $mainViewModel.isExpanded,
            nutrients: mainViewModel.filteredNutrients
        )
    }
    
    private func initializeMainView() async {
        await mainViewModel.loadMealItemsMainView()
        await mainViewModel.searchViewModel.loadBookmarksSearchView()
        await mainViewModel.loadMainRdiMainView()
        await mainViewModel.loadDisplayRdiMainView()
        await MainActor.run {
            mainViewModel.updateProgress()
            mainViewModel.isLoading = false
        }
    }
}
