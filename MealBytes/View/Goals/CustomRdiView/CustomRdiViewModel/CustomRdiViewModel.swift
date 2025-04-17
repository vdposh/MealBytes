//
//  CustomRdiViewModel.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI
import Combine

final class CustomRdiViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var protein: String = ""
    @Published var toggleOn: Bool = false
    @Published var isLoading: Bool = true
    @Published var isSaved: Bool = false
    
    private let formatter = Formatter()
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    let mainViewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        calories = "0"
        fat = ""
        carbohydrate = ""
        protein = ""
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load CustomGoals Data
    func loadCustomRdiView() async {
        do {
            let customGoalsData = try await firestore
                .loadCustomRdiFirestore()
            await MainActor.run {
                calories = customGoalsData.calories
                fat = customGoalsData.fat
                carbohydrate = customGoalsData.carbohydrate
                protein = customGoalsData.protein
                toggleOn = customGoalsData.isCaloriesActive
                isSaved = !calories.isEmpty
                isLoading = false
            }
        } catch {
            await MainActor.run {
                appError = .decoding
                isLoading = false
            }
        }
    }
    
    // MARK: - Save Textfields Info
    func saveCustomRdiView() async {
        let customGoalsData = CustomRdiData(
            calories: calories,
            fat: fat,
            carbohydrate: carbohydrate,
            protein: protein,
            isCaloriesActive: toggleOn
        )
        do {
            try await firestore.saveCustomRdiFirestore(customGoalsData)
            await MainActor.run {
                mainViewModel.rdi = calories
                isSaved = true
            }
            await mainViewModel.saveMainRdiMainView()
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
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
        guard toggleOn && !calories.isEmpty else {
            return
        }
        
        let fatValue = Double(fat) ?? 0
        let carbValue = Double(carbohydrate) ?? 0
        let protValue = Double(protein) ?? 0
        let totalCalories = (fatValue * 9) + (carbValue * 4) + (protValue * 4)
        calories = formatter.formattedValue(totalCalories, unit: .empty)
    }
    
    // MARK: - UI Helpers
    func titleColor(for value: String) -> Color {
        switch value.isEmpty {
        case true: .customRed
        case false: .secondary
        }
    }
    
    var caloriesTextColor: Color {
        switch toggleOn {
        case true: .secondary
        case false: .primary
        }
    }
    
    var showStar: Bool {
        return !toggleOn
    }
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
