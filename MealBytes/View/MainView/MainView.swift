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
                    caloriesSection
                    MealSection(title: "Breakfast", iconName: "sunrise.fill", color: .customBreakfast)
                    MealSection(title: "Lunch", iconName: "sun.max.fill", color: .customLunch)
                    MealSection(title: "Dinner", iconName: "moon.fill", color: .customDinner)
                    MealSection(title: "Other", iconName: "applelogo", color: .customOther)
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
