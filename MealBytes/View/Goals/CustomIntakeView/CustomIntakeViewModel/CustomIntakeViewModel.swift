//
//  CustomIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

protocol CustomIntakeViewModelProtocol {
    func loadCustomIntake() async
    func saveCustomIntakeView() async
    func conditionallyClearCustomIntake()
    func clearCustomIntake()
    func normalizeInputs()
}

final class CustomIntakeViewModel: ObservableObject {
    @Published var appError: AppError?
    @Published var calories: String = ""
    @Published var protein: String = ""
    @Published var fat: String = ""
    @Published var carbohydrate: String = ""
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
    }
    
    // MARK: - Save CustomIntake Data
    func saveCustomIntakeData() async {
        let data = CustomIntake(
            calories: calories.trimmedLeadingZeros,
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
