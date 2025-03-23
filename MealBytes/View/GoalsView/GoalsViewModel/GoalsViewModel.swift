//
//  GoalsViewModel.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI
import Combine

final class GoalsViewModel: ObservableObject {
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var isUsingPercentage: Bool = true
    
    private let formatter: Formatter
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    init(formatter: Formatter = Formatter()) {
        self.formatter = formatter
        setupBindings()
    }
    
    // MARK: - Setup Bindings
    private func setupBindings() {
        Publishers.CombineLatest3($fat, $carbohydrate, $protein)
            .sink { [weak self] fat, carb, protein in
                self?.calculateCalories(fat: fat,
                                        carbohydrate: carb,
                                        protein: protein)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Calculations
    private func calculateCalories(fat: String,
                                   carbohydrate: String,
                                   protein: String) {
        guard !isUsingPercentage else {
            calories = formatter.formattedValue(0.0, unit: .empty)
            return
        }
        let fatValue = Double(fat) ?? 0
        let carbValue = Double(carbohydrate) ?? 0
        let protValue = Double(protein) ?? 0
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        calories = formatter.formattedValue(totalCalories, unit: .empty)
    }
    
    // MARK: - Actions
    func togglePercentageMode() {
        isUsingPercentage.toggle()
        if isUsingPercentage {
            fat = ""
            carbohydrate = ""
            protein = ""
            calories = "0"
        }
    }
    
    // MARK: - UI Helpers
    func titleColor(for value: String) -> Color {
        switch value.isEmpty {
        case true: .customRed
        case false: .primary
        }
    }
    
    var caloriesTextColor: Color {
        switch isCaloriesTextFieldActive {
        case true: .secondary
        case false: .primary
        }
    }
    
    // MARK: - Unit Helpers
    func unitSymbol(inverted: Bool = false) -> String {
        switch (isUsingPercentage, inverted) {
        case (true, false): "%"
        case (true, true): "g"
        case (false, false): "g"
        case (false, true): "%"
        }
    }
    
    var toggleButtonText: String {
        switch isUsingPercentage {
        case true: "Use gramms"
        case false: "Use %"
        }
    }
    
    var isCaloriesTextFieldActive: Bool {
        switch isUsingPercentage {
        case true: false
        case false: true
        }
    }
}

#Preview {
    NavigationStack {
        GoalsView(viewModel: GoalsViewModel())
    }
    .accentColor(.customGreen)
}
