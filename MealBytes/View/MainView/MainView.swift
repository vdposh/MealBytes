//
//  MainView.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    dateCarouselSection
                    caloriesSection
                    MealSection(
                        title: "Breakfast",
                        iconName: "sunrise.fill",
                        color: .customBreakfast,
                        calories: 500.0,
                        fats: 20.5,
                        proteins: 30.0,
                        carbohydrates: 50.0
                    )
                    detailedInformationSection
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: .date)
                            .accentColor(.customGreen)
                            .labelsHidden()
                    }
                }
            }
        }
        .listSectionSpacing(.compact)
        .accentColor(.customGreen)
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
                    Text("0")
                }
                HStack {
                    Text("F")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("0")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("P")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.leading)
                    Text("0")
                        .foregroundColor(.gray)
                        .font(.footnote)
                    Text("C")
                        .foregroundColor(.gray)
                        .font(.footnote)
                        .padding(.leading)
                    Text("0")
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
        }
    }
}

#Preview {
    MainView()
}
