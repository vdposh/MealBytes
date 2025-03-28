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
        List {
            dateCarouselSection
            caloriesSection
            mealSections
            detailedInformationSection
        }
        .listSectionSpacing(15)
    }
    
    private var dateCarouselSection: some View {
        Section {
            HStack {
                let daysBeforeAndAfter = 3
                ForEach(-daysBeforeAndAfter...daysBeforeAndAfter, id: \.self) {
                    offset in
                    let date = mainViewModel.date(for: offset)
                    Button(action: {
                        mainViewModel.selectedDate = date
                    }) {
                        dateView(for: date)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listRowInsets(EdgeInsets())
        .listRowBackground(Color.clear)
        .padding(.bottom, 5)
    }
    
    private func dateView(for date: Date) -> some View {
        DateView(
            date: date,
            isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
            isSelected: Calendar.current.isDate(date, inSameDayAs: mainViewModel.selectedDate)
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
    MainView(mainViewModel: MainViewModel())
}
