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
                breakfastSection
                detailedInformationSection
            }
        }
        .accentColor(.customGreen)
        .listSectionSpacing(.compact)
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
    
    private var breakfastSection: some View {
        MealSection(
            title: "Breakfast",
            iconName: "sunrise.fill",
            color: .customBreakfast,
            calories: viewModel.value(for: .calories),
            fats: viewModel.value(for: .fat),
            proteins: viewModel.value(for: .protein),
            carbohydrates: viewModel.value(for: .carbohydrates),
            foodItems: viewModel.foodItems,
            mainViewModel: viewModel
        )
    }
    
    private var caloriesSection: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                    Spacer()
                    Text(formatter.formattedValue(viewModel.value(for: .calories), unit: .empty))
                }
                
                HStack {
                    NutrientLabel(label: "F", value: viewModel.value(for: .fat), formatter: formatter)
                    NutrientLabel(label: "P", value: viewModel.value(for: .protein), formatter: formatter)
                        .padding(.leading, 5)
                    NutrientLabel(label: "C", value: viewModel.value(for: .carbohydrates), formatter: formatter)
                        .padding(.leading, 5)
                    Spacer()
                }
            }
            .padding(.vertical, 5)
        }
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
