//
//  CustomIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

protocol CustomIntakeViewModelProtocol {
    var isValid: Bool { get }
    
    func loadCustomIntake() async
    func saveCustomIntake() async
    func conditionallyClearCustomIntake()
    func clearCustomIntake()
    func normalizeInputs()
}

final class CustomIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = "" {
        didSet {
            recalculateIsValid()
        }
    }
    @Published var protein: String = "" {
        didSet {
            recalculateIsValid()
        }
    }
    @Published var fat: String = "" {
        didSet {
            recalculateIsValid()
        }
    }
    @Published var carbohydrate: String = "" {
        didSet {
            recalculateIsValid()
        }
    }
    @Published var isValid: Bool = false
    @Published var didSaveSuccessfully: Bool = false
    @Published var didLoadNonEmptyCustomIntake: Bool = false
    
    private let mainViewModel: MainViewModelProtocol
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Load CustomIntake Data
    func loadCustomIntake() async {
        do {
            let data = try await firestore.loadCustomIntakeFirestore()
            
            await MainActor.run {
                calories = data.calories
                fat = data.fat
                carbohydrate = data.carbohydrate
                protein = data.protein
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
        isValid = false
    }
    
    // MARK: - Save CustomIntake Data
    func saveCustomIntake() async {
        let trimmedCalories = calories.trimmedLeadingZeros
        let data = CustomIntake(
            calories: trimmedCalories,
            fat: fat.trimmedLeadingZeros,
            carbohydrate: carbohydrate.trimmedLeadingZeros,
            protein: protein.trimmedLeadingZeros
        )
        
        do {
            try await firestore.saveCustomIntakeFirestore(data)
            
            await MainActor.run {
                mainViewModel.updateIntake(to: trimmedCalories)
                mainViewModel
                    .updateMacros(
                        fat: fat.trimmedLeadingZeros,
                        carbohydrate: carbohydrate.trimmedLeadingZeros,
                        protein: protein.trimmedLeadingZeros
                    )
                didSaveSuccessfully = true
            }
            
            await mainViewModel
                .saveCurrentIntakeMainView(
                    source: IntakeSource.custom.rawValue
                )
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Calculation
    private func recalculateIsValid() {
        isValid = validate(
            calories: calories,
            fat: fat,
            carbohydrate: carbohydrate,
            protein: protein
        )
    }
    
    private func validate(
        calories: String,
        fat: String,
        carbohydrate: String,
        protein: String
    ) -> Bool {
        let hasAnyValue = !calories.isEmpty ||
        !fat.isEmpty ||
        !carbohydrate.isEmpty ||
        !protein.isEmpty
        
        guard hasAnyValue else { return false }
        
        if !calories.isEmpty && !calories.isValidNumericInput() {
            return false
        }
        if !fat.isEmpty && !fat.isValidNumericInput() {
            return false
        }
        if !carbohydrate.isEmpty && !carbohydrate.isValidNumericInput() {
            return false
        }
        if !protein.isEmpty && !protein.isValidNumericInput() {
            return false
        }
        
        return true
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
}

extension CustomIntakeViewModel: CustomIntakeViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}
