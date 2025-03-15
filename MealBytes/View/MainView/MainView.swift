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
                    calories: calculateCalories(),
                    fats: calculateFats(),
                    proteins: calculateProteins(),
                    carbohydrates: calculateCarbohydrates(),
                    foodItems: viewModel.foodItems,
                    mainViewModel: viewModel
                )
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
        return DateView(date: date,
                        isToday: Calendar.current.isDate(date, inSameDayAs: Date()),
                        isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate))
    }
    
    private var caloriesSection: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                    Spacer()
                    Text(formatter.formattedValue(calculateCalories(), unit: .empty))
                }
                HStack {
                    Text("F")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text(formatter.formattedValue(calculateFats(), unit: .empty))
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("P")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.leading)
                    Text(formatter.formattedValue(calculateProteins(), unit: .empty))
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("C")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.leading)
                    Text(formatter.formattedValue(calculateCarbohydrates(), unit: .empty))
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
    
    private func calculateCalories() -> Double {
        viewModel.foodItems.reduce(0) { $0 + $1.calories }
    }
    
    private func calculateFats() -> Double {
        viewModel.foodItems.reduce(0) { $0 + $1.fats }
    }
    
    private func calculateProteins() -> Double {
        viewModel.foodItems.reduce(0) { $0 + $1.proteins }
    }
    
    private func calculateCarbohydrates() -> Double {
        viewModel.foodItems.reduce(0) { $0 + $1.carbohydrates }
    }
}

#Preview {
    MainView()
}
