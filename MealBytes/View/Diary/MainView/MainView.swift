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
        ZStack(alignment: .top) {
            if mainViewModel.isExpandedCalendar {
                VStack {
                    datePickerView
                }
                .zIndex(2)
                
                CalendarButtonView {
                    mainViewModel.isExpandedCalendar = false
                }
                .zIndex(1)
            }
            
            Form {
                dateSection
                caloriesSection
                mealSections
                detailedInformationSection
            }
            .scrollIndicators(.hidden)
            .listSectionSpacing(15)
        }
        .navigationBarTitle("Diary", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button {
                    mainViewModel.isExpandedCalendar.toggle()
                } label: {
                    Text(mainViewModel.formattedDate())
                        .font(.headline)
                }
            }
        }
        .task {
            await mainViewModel.loadMainData()
        }
    }
    
    private var datePickerView: some View {
        VStack {
            CalendarView(
                selectedDate: $mainViewModel.date,
                isPresented: $mainViewModel.isExpandedCalendar,
                mainViewModel: mainViewModel
            )
        }
        .background(Color(.systemBackground))
    }
    
    private var dateSection: some View {
        Section {
            HStack {
                ForEach(-3...3, id: \.self) { offset in
                    Button {
                        mainViewModel.date = mainViewModel
                            .dateByAddingOffset(for: offset)
                    } label: {
                        dateView(
                            for: mainViewModel.dateByAddingOffset(for: offset)
                        )
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
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
}
