//
//  MainView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MainView: View {
    @State private var isExpanded: Bool = false
    @StateObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            if isExpanded {
                datePickerView
            }
            
            List {
                dateCarouselSection
                caloriesSection
                mealSections
                detailedInformationSection
            }
            .listSectionSpacing(15)
        }
        .animation(.easeInOut, value: isExpanded)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(mainViewModel.date.formatted(.dateTime.month(.wide)))
                    .fontWeight(.medium)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Image(systemName: "calendar")
                }
            }
        }
    }
    
    private var datePickerView: some View {
        VStack {
            DatePickerView(selectedDate: $mainViewModel.date)
        }
    }
    
    private var dateCarouselSection: some View {
        Section {
            HStack {
                let daysBeforeAndAfter = 3
                ForEach(-daysBeforeAndAfter...daysBeforeAndAfter, id: \.self) {
                    offset in
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
            )
        )
    }
    
    private var mealSections: some View {
        ForEach(MealType.allCases) { mealType in
            MealSectionView(
                mealType: mealType,
                mealItems: mainViewModel.mealItems[mealType, default: []],
                mainViewModel: mainViewModel
            )
        }
    }
    
    private var caloriesSection: some View {
        CaloriesSection(
            summaries: mainViewModel.nutrientSummaries,
            mainViewModel: mainViewModel
        )
    }
    
    private var detailedInformationSection: some View {
        DetailedInformationSection(
            nutrients: mainViewModel.filteredNutrients,
            isExpanded: $mainViewModel.isExpanded
        )
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
