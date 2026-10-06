//
//  CustomIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

protocol CustomIntakeViewModelProtocol {
    var caloriesKcal: String { get }
    var fat: String { get }
    var carbohydrate: String { get }
    var protein: String { get }
    
    func loadCustomIntake() async
    func saveCustomIntakeView() async
    func conditionallyClearCustomIntake()
    func clearCustomIntake()
    func normalizeInputs()
    func energyUnitChanged(to newUnit: EnergyUnit)
}

final class CustomIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var protein: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyCustomIntake: Bool = false
    
    private var lastEnergyUnit: EnergyUnit
    
    private let mainViewModel: MainViewModelProtocol
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        self.lastEnergyUnit = mainViewModel.energyUnit
    }
    
    // MARK: - Load CustomIntake Data
    func loadCustomIntake() async {
        do {
            let data = try await firestore.loadCustomIntakeFirestore()
            
            await MainActor.run {
                let kcal = Double(data.calories) ?? 0
                let display = mainViewModel.energyUnit.fromKcal(fromKcal: kcal)
                calories = display > 0 ? display.asWhole(grouping: false) : ""
                fat = data.fat
                carbohydrate = data.carbohydrate
                protein = data.protein
                lastEnergyUnit = mainViewModel.energyUnit
                didLoadNonEmptyCustomIntake = !data.calories.isEmpty ||
                !data.fat.isEmpty ||
                !data.carbohydrate.isEmpty ||
                !data.protein.isEmpty
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func conditionallyClearCustomIntake() {
        if !didSaveSuccessfully && !didLoadNonEmptyCustomIntake {
            clearCustomIntake()
        }
        
        didSaveSuccessfully = false
        didLoadNonEmptyCustomIntake = false
    }
    
    func clearCustomIntake() {
        calories = ""
        protein = ""
        fat = ""
        carbohydrate = ""
    }
    
    // MARK: - Save CustomIntake Data
    func saveCustomIntakeData() async {
        let kcal = lastEnergyUnit.toKcal(
            fromKj: calories.doubleValue ?? 0
        )
        
        let data = CustomIntake(
            calories: kcal > 0 ? kcal.asWhole(grouping: false) : "",
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros
        )
        
        do {
            try await firestore.saveCustomIntakeFirestore(data)
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    func saveCustomIntakeView() async {
        await saveCustomIntakeData()
        
        await MainActor.run {
            didSaveSuccessfully = true
        }
        
        await mainViewModel.saveCurrentIntakeMainView(
            source: IntakeSource.custom.rawValue
        )
    }
    
    // MARK: - Energy Changed
    func energyUnitChanged(to newUnit: EnergyUnit) {
        guard newUnit != lastEnergyUnit else { return }
        
        let currentValue = calories.doubleValue ?? 0
        let kcal = lastEnergyUnit.toKcal(fromKj: currentValue)
        let newValue = newUnit.fromKcal(fromKcal: kcal)
        
        calories = newValue > 0 ? newValue.asWhole(grouping: false) : ""
        lastEnergyUnit = newUnit
        
        Task {
            await saveCustomIntakeData()
        }
    }
    
    var caloriesKcal: String {
        let kcal = lastEnergyUnit
            .toKcal(fromKj: calories.doubleValue ?? 0)
        return kcal > 0 ? kcal.asWhole(grouping: false) : ""
    }
    
    // MARK: - Keyboard
    func normalizeInputs() {
        calories = calories.trimmedLeadingZeros
        protein = protein.trimmedLeadingZeros
        fat = fat.trimmedLeadingZeros
        carbohydrate = carbohydrate.trimmedLeadingZeros
    }
    
    func handleFocusChange(
        focus: CustomIntakeFocus,
        didGainFocus: Bool
    ) {
        normalizeInputs()
        
        switch focus {
        case .calories:
            if didGainFocus {
            } else if calories.isValidNumericInput() {
                calories = calories.trimmedLeadingZeros
            }
            
        case .fat:
            if didGainFocus {
            } else if fat.isValidNumericInput() {
                fat = fat.trimmedLeadingZeros
            }
            
        case .carbohydrate:
            if didGainFocus {
            } else if carbohydrate.isValidNumericInput() {
                carbohydrate = carbohydrate.trimmedLeadingZeros
            }
            
        case .protein:
            if didGainFocus {
            } else if protein.isValidNumericInput() {
                protein = protein.trimmedLeadingZeros
            }
        }
    }
    
    // MARK: - UI Helper
    var energyUnit: EnergyUnit {
        mainViewModel.energyUnit
    }
}

extension CustomIntakeViewModel: CustomIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
