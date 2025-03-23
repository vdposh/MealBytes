//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI
import Combine

final class GoalsViewModel: ObservableObject {
    @Published var calories: String = "0"
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var isUsingPercentage: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() { setupBindings() }
    
    private func setupBindings() {
        Publishers.CombineLatest3($fat, $carbohydrate, $protein)
            .sink { [weak self] fat, carb, protein in
                self?.calculateCalories(fat: fat, carbohydrate: carb, protein: protein)
            }
            .store(in: &cancellables)
    }
    
    private func calculateCalories(fat: String, carbohydrate: String, protein: String) {
        guard !isUsingPercentage else {
            calories = "0"
            return
        }
        let fatValue = Double(fat) ?? 0
        let carbValue = Double(carbohydrate) ?? 0
        let proteinValue = Double(protein) ?? 0
        calories = String(format: "%.0f", (fatValue * 9) + (carbValue * 4) + (proteinValue * 4))
    }
    
    func togglePercentageMode() {
        isUsingPercentage.toggle()
        if isUsingPercentage {
            fat = ""
            carbohydrate = ""
            protein = ""
            calories = "0"
        }
    }
    
    func titleColor(for value: String) -> Color {
        value.isEmpty ? .customRed : .primary
    }
    
    var isCaloriesTextFieldActive: Bool { !isUsingPercentage }
    var caloriesTextColor: Color { isUsingPercentage ? .primary : .secondary }
}

#Preview {
    NavigationStack {
        GoalsView(viewModel: GoalsViewModel())
    }
    .accentColor(.customGreen)
}
