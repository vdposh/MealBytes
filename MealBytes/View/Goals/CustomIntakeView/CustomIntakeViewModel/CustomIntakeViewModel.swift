//
//  CustomIntakeViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

protocol CustomIntakeViewModelProtocol {
    var calories: String { get set }
    var isValid: Bool { get }
    
    func loadCustomIntake() async
    func saveCustomIntake()
    func normalizeCalories()
}

final class CustomIntakeViewModel: ObservableObject {
    @Published var calories: String = ""
    @Published var appError: AppError?
    
    private let mainViewModel: MainViewModelProtocol
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Load
    func loadCustomIntake() async {
        await MainActor.run {
            calories = mainViewModel.intake
        }
    }
    
    // MARK: - Save
    func saveCustomIntake() {
        guard isValid else { return }
        
        Task {
            await MainActor.run {
                mainViewModel.updateIntake(to: calories)
            }
            
            await mainViewModel.saveCurrentIntakeMainView(source: "customView")
        }
    }
    
    // MARK: - Text
    var text: String {
        guard let caloriesValue = calories.doubleValue,
                caloriesValue > 0 else {
            return "Fill in the data"
        }
        
        let formattedValue = caloriesValue.asWhole()
        
        return caloriesValue == 1
        ? "\(formattedValue) calorie"
        : "\(formattedValue) calories"
    }
    
    // MARK: - Keyboard
    func normalizeCalories() {
        calories = calories.trimmedLeadingZeros
    }
    
    var isValid: Bool {
        calories.isValidNumericInput()
    }
}

extension CustomIntakeViewModel: CustomIntakeViewModelProtocol {}
