//
//  MainView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI
import FirebaseCore

struct MainView: View {
    @State private var isExpanded: Bool = false
    @State private var isLoading: Bool = true
    @StateObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
            } else {
                ZStack(alignment: .top) {
                    if isExpanded {
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
            await mainViewModel.loadMealItemsMainView()
            await mainViewModel.searchViewModel.loadBookmarksSearchView()
            
            await MainActor.run {
                isLoading = false
            }
        }
        .animation(.easeInOut, value: isExpanded)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isLoading {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        isExpanded.toggle()
                    }) {
                        HStack(spacing: 4) {
                            Text(mainViewModel.formattedYearDisplay())
                                .fontWeight(.medium)
                            Image(systemName: {
                                switch isExpanded {
                                case true:
                                    "chevron.up"
                                case false:
                                    "chevron.down"
                                }
                            }())
                            .font(.caption)
                            .fontWeight(.semibold)
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
                           isPresented: $isExpanded,
                           mainViewModel: mainViewModel)
        }
        .background(Color(.systemBackground))
    }
    
    private var dateSection: some View {
        Section {
            HStack {
                let daysBeforeAndAfter = 3
                ForEach(-daysBeforeAndAfter...daysBeforeAndAfter,
                         id: \.self) { offset in
                    let date = mainViewModel.date(for: offset)
                    Button(action: {
                        mainViewModel.date = date
                    }) {
                        dateView(for: date)
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
            let filteredItems = mainViewModel.mealItems[mealType, default: []]
                .filter {
                    mainViewModel.calendar.isDate(
                        $0.date,
                        inSameDayAs: mainViewModel.date
                    )
                }
            
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
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
