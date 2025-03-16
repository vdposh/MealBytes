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
    
    private var mealSections: some View {
        ForEach(MealType.allCases) { mealType in
            MealSection(
                mealType: mealType,
                title: mealType.rawValue,
                iconName: mealType == .breakfast ? "sunrise.fill" :
                    mealType == .lunch ? "sun.max.fill" :
                    mealType == .dinner ? "moon.fill" : "tray.fill",
                color: mealType == .breakfast ? .customBreakfast :
                    mealType == .lunch ? .customLunch :
                    mealType == .dinner ? .customDinner : .customOther,
                calories: viewModel.mealItems[mealType]?.reduce(0) { $0 + ($1.nutrients[.calories] ?? 0.0) } ?? 0,
                fats: viewModel.mealItems[mealType]?.reduce(0) { $0 + ($1.nutrients[.fat] ?? 0.0) } ?? 0,
                proteins: viewModel.mealItems[mealType]?.reduce(0) { $0 + ($1.nutrients[.protein] ?? 0.0) } ?? 0,
                carbohydrates: viewModel.mealItems[mealType]?.reduce(0) { $0 + ($1.nutrients[.carbohydrates] ?? 0.0) } ?? 0,
                foodItems: viewModel.mealItems[mealType] ?? [],
                mainViewModel: viewModel
            )
        }
    }
    
    private var caloriesSection: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(formatter.formattedValue(viewModel.nutrientSummaries[.calories] ?? 0.0, unit: .empty))
                        .font(.headline)
                }
                HStack {
                    NutrientLabel(label: "F", value: viewModel.nutrientSummaries[.fat] ?? 0.0, formatter: formatter)
                    NutrientLabel(label: "P", value: viewModel.nutrientSummaries[.protein] ?? 0.0, formatter: formatter)
                        .padding(.leading, 5)
                    NutrientLabel(label: "C", value: viewModel.nutrientSummaries[.carbohydrates] ?? 0.0, formatter: formatter)
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

enum MealType: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case other = "Other"
    
    var id: String { rawValue }
}

#Preview {
    MainView()
}
