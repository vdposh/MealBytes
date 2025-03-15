//
//  MainView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    private let formatter = Formatter()
    
    var body: some View {
        NavigationStack {
            List {
                dateCarouselSection
                caloriesSection
                
                MealSection(
                    title: "Breakfast",
                    iconName: "sunrise.fill",
                    color: .customBreakfast,
                    calories: viewModel.nutrientSummaries[.calories] ?? 0.0,
                    fats: viewModel.nutrientSummaries[.fat] ?? 0.0,
                    proteins: viewModel.nutrientSummaries[.protein] ?? 0.0,
                    carbohydrates: viewModel.nutrientSummaries[.carbohydrates] ?? 0.0,
                    foodItems: viewModel.foodItems,
                    mainViewModel: viewModel
                )
                
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
                    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
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
    
    private var caloriesSection: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                    Spacer()
                    Text(formatter.formattedValue(viewModel.nutrientSummaries[.calories] ?? 0.0, unit: .empty))
                }
                HStack {
                    Text("F")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(formatter.formattedValue(viewModel.nutrientSummaries[.fat] ?? 0.0, unit: .empty))
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("P")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.leading)
                    Text(formatter.formattedValue(viewModel.nutrientSummaries[.protein] ?? 0.0, unit: .empty))
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("C")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.leading)
                    Text(formatter.formattedValue(viewModel.nutrientSummaries[.carbohydrates] ?? 0.0, unit: .empty))
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Spacer()
                    Text("0")
                        .foregroundColor(.gray)
                        .font(.footnote)
                }
                
            }
            .padding(.vertical, 5)
        }
    }
    
    private var detailedInformationSection: some View {
        Section {
            Text("Detailed Information")
                .font(.headline)
                .listRowSeparator(.hidden)
                .padding(.top, 10)
            
            ForEach(NutrientType.allCases, id: \.self) { nutrient in
                HStack {
                    Text(nutrient.title)
                        .foregroundColor(.primary)
                    Spacer()
                    Text(
                        formatter.formattedValue(
                            viewModel.nutrientSummaries[nutrient] ?? 0.0,
                            unit: .init(rawValue: nutrient.alternativeUnit) ?? .empty
                        )
                    )
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
