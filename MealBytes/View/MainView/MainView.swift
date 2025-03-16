//
//  MainView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @State private var isExpanded: Bool = false
    private let formatter = Formatter()
    
    var body: some View {
        NavigationStack {
            List {
                dateCarouselSection
                caloriesSection
                mealSections
                detailedInformationSection
            }
        }
        .accentColor(.customGreen)
        .listSectionSpacing(15)
    }
    
    private var dateCarouselSection: some View {
        Section {
            HStack {
                ForEach(-3...3, id: \.self) { offset in
                    let date = Calendar.current.date(
                        byAdding: .day, value: offset, to: Date()) ?? Date()
                    dateView(for: date)
                        .onTapGesture {
                            viewModel.selectedDate = date
                        }
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
            isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
        )
    }
    
    private var mealSections: some View {
        ForEach(MealType.allCases) { mealType in
            MealSectionView(
                mealType: mealType,
                mealItems: viewModel.mealItems[mealType] ?? [],
                viewModel: viewModel
            )
        }
    }
    
    private var caloriesSection: some View {
        CaloriesSection(
            summaries: viewModel.nutrientSummaries,
            formatter: formatter
        )
    }
    
    private var detailedInformationSection: some View {
        DetailedInformationSection(
            nutrients: nutrients,
            isExpanded: $isExpanded
        )
    }
    
    private var nutrients: [DetailedNutrient] {
        let summaries = viewModel.nutrientSummaries
        let allNutrients = DetailedNutrientProvider()
            .getDetailedNutrients(from: summaries)
        
        switch isExpanded {
        case true:
            return allNutrients
        case false:
            return allNutrients.filter {
                [.calories, .fat, .protein, .carbohydrates].contains($0.type)
            }
        }
    }
}

#Preview {
    MainView()
}
